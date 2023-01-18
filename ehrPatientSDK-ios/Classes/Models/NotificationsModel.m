//
// Created by Yves Le Borgne on 2015-10-07.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "EHRServerResponse.h"
#import "NotificationsModel.h"
#import "GEFileUtil.h"
#import "AppState.h"
#import "EHRApiServer.h"
#import "EHRServerRequest.h"
#import "UserModel.h"
#import "IBUser.h"
#import "EHRCall.h"
#import "EHRRequestStatus.h"
#import "PatientNotification.h"
#import "NotificationsModelFilter.h"
#import "UserDeviceSettings.h"
#import "NotificationProgressChange.h"
#import "MessageDistributionProgressChange.h"
#import "IBMessageDistribution.h"
#import "IBMessageContent.h"
#import "SecureCredentials.h"
#import "UserCredentials.h"
#import "WebServices.h"
#import "NotificationWS.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation NotificationsModel

static NSString *_notificationsFileFQN;

@synthesize lastRefreshed = _lastRefreshed;
@synthesize lastPurgedExpired = _lastPurgedExpired;
@dynamic allNotificationFilter, numberOfUnseen;
@dynamic numberOfActionRequired;

TRACE_OFF

+ (void)initialize {
    _notificationsFileFQN = [[GEFileUtil sharedFileUtil] getNotificationsFQN];
}

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        _appState                            = [AppState sharedAppState];
        _allNotifications                    = [NSMutableDictionary dictionary];
        _lastRefreshed                       = [NSDate dateWithTimeIntervalSince1970:0];
        _lastPurgedExpired                   = [NSDate dateWithTimeIntervalSince1970:0];
        _allNotificationFilter               = [NotificationsModelFilter allFilter];
        _patientNotificationFilter           = [NotificationsModelFilter patientFilter];
        _infoNotificationFilter              = [NotificationsModelFilter infoFilter];
        _alertNotificationFilter             = [NotificationsModelFilter alertFilter];
        _practitionerNotificationFilter      = [NotificationsModelFilter practitionerFilter];
        _privateMessageNotificationFilter    = [NotificationsModelFilter telexFilter];
        _appointmentNotificationFilter       = [NotificationsModelFilter appointmentFilter];
        _conversationNotificationFilter      = [NotificationsModelFilter convoListFilter];
        _queuedNotificationStateChanges      = [NSMutableArray array];
        _stackedNotificationStateChanges     = [NSMutableArray array];
        _queuedMessageStateChanges           = [NSMutableArray array];
        _stackedMessageStateChanges          = [NSMutableArray array];
        _isSendingStackedMessageChanges      = NO;
        _isSendingStackedNotificationChanges = NO;
        [self setRefreshEnabled:YES];

    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

+ (NotificationsModel *)objectWithJSON:(NSString *)jsonString {
    NSDictionary *dic = [NSDictionary dictionaryWithJSON:jsonString];
    return [NotificationsModel objectWithContentsOfDictionary:dic];
}

+ (NotificationsModel *)objectWithJSONdata:(NSData *)jsonData {
    NSDictionary *dic = [NSDictionary dictionaryWithJSONdata:jsonData];
    return [NotificationsModel objectWithContentsOfDictionary:dic];
}

- (NSData *)asJSONdata {
    NSDictionary *dic = [self asDictionary];
    return [dic asJSONdata];
}

- (NSString *)asJSON {
    NSDictionary *dic = [self asDictionary];
    return [dic asJSON];
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary      *dic  = [NSMutableDictionary dictionary];
    NSMutableDictionary      *nots = [NSMutableDictionary dictionary];
    for (PatientNotification *pn in [_allNotifications allValues]) {
        nots[pn.seq] = [pn asDictionary];
    }
    dic[@"notifications"]          = nots;
    PutDateInDic(_lastRefreshed, dic, @"lastRefreshed");
    PutDateInDic(_lastPurgedExpired, dic, @"lastPurgedExpired");
    return dic;
}

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    NotificationsModel *nm = [[self alloc] init];
    [nm loadFromDic:dic];
    return nm;
}

- (void)loadFromDic:(NSDictionary *)dic {
    [self->_allNotifications removeAllObjects];
    [self->_stackedNotificationStateChanges removeAllObjects];
    [self->_queuedNotificationStateChanges removeAllObjects];

    NSDictionary      *nots = dic[@"notifications"];
    for (NSDictionary *pnAsDic in [nots allValues]) {
        PatientNotification *pn = [PatientNotification objectWithContentsOfDictionary:pnAsDic];
        self->_allNotifications[pn.seq] = pn;
    }
    self->_lastRefreshed     = WantDateFromDic(dic, @"lastRefreshed");
    self->_lastPurgedExpired = WantDateFromDic(dic, @"lastPurgedExpired");
    [self refreshFilters];
}

#pragma mark -
#pragma mark - some getters and setters

- (BOOL)isRefreshEnabled {
    return _isRefreshEnabled;
}

- (void)setRefreshEnabled:(BOOL)isit {
    _isRefreshEnabled = isit;
}

#pragma mark -
#pragma mark - dynamic properties

- (NSInteger)numberOfUnseen {
    NSInteger num = 0;
    num += _patientNotificationFilter.numberOfUnseen;
    num += _infoNotificationFilter.numberOfUnseen;
    num += _alertNotificationFilter.numberOfUnseen;
    num += _privateMessageNotificationFilter.numberOfUnseen;
    num += _practitionerNotificationFilter.numberOfUnseen;
    num += _appointmentNotificationFilter.numberOfUnseen;
    return num;
}

- (NSInteger)numberOfActionRequired {
    NSInteger num = 0;
    num += _patientNotificationFilter.numberOfActionRequired;
    num += _infoNotificationFilter.numberOfActionRequired;
    num += _alertNotificationFilter.numberOfActionRequired;
    num += _privateMessageNotificationFilter.numberOfActionRequired;
    num += _practitionerNotificationFilter.numberOfActionRequired;
    num += _appointmentNotificationFilter.numberOfActionRequired;
    num += _conversationNotificationFilter.numberOfActionRequired;
    return num;
}

// server interface

- (void)readFromServer __unused {
    TRACE_KILLROY
    [_allNotifications removeAllObjects];
    [self->_stackedNotificationStateChanges removeAllObjects];
    [self->_queuedNotificationStateChanges removeAllObjects];
    [self refreshFilters];
    [self readFromServerSince:[NSDate dateWithTimeIntervalSince1970:0]];
}

- (void)readFromServerWithSuccess:(VoidBlock)successBlock andError:(VoidBlock)errorBlock __unused {
    TRACE_KILLROY
    _refreshSuccessBlock = [successBlock copy];
    _refreshFailedBlock  = [errorBlock copy];
    [self readFromServer];
}

- (void)readFromServerSince:(NSDate *)since {

    TRACE_KILLROY

    if ([AppState sharedAppState].isInBackground) {
        MPLOG(@"App is in background , not reading from server.");
        return;
    }

    //region Shit happens, we fail the call

    VoidBlock onFailure = ^{
        TRACE(@"**** Bailing out of readFromServer, not reading from server.");
        self->_isRefreshing = NO;
        if (self->_refreshFailedBlock) {
            self->_refreshFailedBlock();
            self->_refreshSuccessBlock = nil;
            self->_refreshFailedBlock  = nil;
        }
        return;
    };

    if (_isRefreshing) {
        MPLOGERROR(@"App is in already refreshing, will bail out.");
        onFailure();
        return;
    };

    NSString *apiKey = [SecureCredentials sharedCredentials].current.userApiKey;
    if ([apiKey isEqualToString:[IBUser guest].apiKey]) {
        MPLOGERROR(@"Guest cant do a notifications list, will bail out.");
        onFailure();
        return;
    }

    //endregion

    // start by purging expired notifications

    _isRefreshing = YES;
    [_allNotificationFilter refreshFilter];

    BOOL          deletedOne = NO;
    for (NSString *seq in _allNotificationFilter.sortedKeys) {
        PatientNotification *pn = _allNotifications[seq];
        if ([pn isExpired]) {
            [_allNotifications removeObjectForKey:seq];
            deletedOne = YES;
        }
    }
    if (deletedOne) {
        [self refreshFilters];
        [self saveOnDevice];
    }

    // now go talk to mama

    EHRApiServer     *server = [SecureCredentials sharedCredentials].current.server;
    EHRServerRequest *req    = [EHRServerRequest serverRequestWithApiKey:[SecureCredentials sharedCredentials].current.userApiKey];
    req.server   = server;
    req.route    = @"/app/notification";
    req.command  = @"list";
    req.language = [AppState sharedAppState].deviceLanguage;

    NSString *sinceAsString = NetworkDateFromDate(since);
    req.parameters = [@{@"status": @"all", @"since": sinceAsString, @"type": @"all"} mutableCopy];
    EHRCall *call        = [EHRCall
            callWithRequest:req
                  onSuccess:^(EHRCall *theCall) {
                      EHRServerResponse *resp = theCall.serverResponse;
                      TRACE(@"Got response with requestStatus %@", [resp.requestStatus asDictionary]);
                      NSString  *apiStatus = resp.requestStatus.status;
                      VoidBlock _after     = ^{
                          if (self->_refreshSuccessBlock) {
                              self->_refreshSuccessBlock();
                              self->_refreshSuccessBlock = nil;
                              self->_refreshFailedBlock  = nil;
                          }
                          self->_isRefreshing = NO;
                      };

                      if ([apiStatus isEqualToString:@"OK"]) {

                          id dic = theCall.serverResponse.responseContent;

                          NSDictionary *notifications = [dic objectForKey:@"notifications"];
                          if (notifications) {
                              TRACE(@"Received [%ld] notifications", (unsigned long) [notifications count]);
                              [self populateFilterFromDictionary:notifications];
                              _after();
                          } else {
                              TRACE(@"Received [0] notifications");
                              _after();
                          }
                      } else {
                          // status was not OK !
                          MPLOGERROR(@"Got status [%@], message [%@]", apiStatus, resp.requestStatus.message);
                          _after();
                      }
                  }
                    onError:^(EHRCall *theCall) {
                        self->_isRefreshing = NO;
                        TRACE(@"Error when listing notifications from Mr Server");
                        if (self->_refreshFailedBlock) {
                            self->_refreshFailedBlock();
                            self->_refreshSuccessBlock = nil;
                            self->_refreshFailedBlock  = nil;
                        }
                    }
    ];
    call.maximumAttempts = 3;
    call.timeOut         = 15;
    [call start];
}

- (void)populateFilterFromDictionary:(NSDictionary *)response {

    if (!self.isRefreshEnabled) {
        TRACE(@"Not posting received notifications, foreground refresh is deactivated");
        return;
    }

    NSDate *lastUpdated = self.lastRefreshed;

    if ([response count] > 0) {
        for (NSDictionary *notAsDic in [response allValues]) {
            PatientNotification *pn = [PatientNotification objectWithContentsOfDictionary:notAsDic];

            if ([lastUpdated timeIntervalSince1970] < [pn.lastUpdated timeIntervalSince1970]) {
                lastUpdated = pn.lastUpdated;
            }

            if (pn.isExpired) {
                if (_allNotifications[pn.seq]) {
                    [_allNotifications removeObjectForKey:pn.seq];
                    TRACE(@"Removing expired patientNotification [%@]", pn.guid);
                }
            } else {

                _allNotifications[pn.seq] = pn;

            }
        }
    }

    // scan for expired notifications

    NSMutableArray           *scrapKeys = [NSMutableArray array];
    for (PatientNotification *pn in [_allNotifications allValues]) {
        if (pn.isExpired) [scrapKeys addObject:pn.seq];
    }

    for (NSString *key in scrapKeys) {
        [_allNotifications removeObjectForKey:key];
    }

    lastUpdated = [NSDate dateWithTimeInterval:1.0 sinceDate:lastUpdated];
    TRACE(@"Setting last refreshed to %@", NetworkDateFromDate(lastUpdated));

    self.lastRefreshed     = lastUpdated;
    self.lastPurgedExpired = [NSDate date];
    [self refreshFilters];
    [self saveOnDevice];
    if ([response count] > 0) [self tellListenersAboutRefresh];
}

- (void)updateWithSinglePatientNotification:(PatientNotification *)pn {
    if (pn.isExpired || pn.isDeleted) {
        if (_allNotifications[pn.seq]) {
            [_allNotifications removeObjectForKey:pn.seq];
            MPLOG(@"Will remove expired patientNotification [%@]", pn.seq);
        } else {
            // all done here
            return;
        }
    } else {

        PatientNotification *old = _allNotifications[pn.seq];
        if (old) {
            MPLOG(@"Will update patientNotification [%@]", pn.seq);
            [old updateWith:pn];
        } else {
            // todo : what about this case ???? should it even be in an 'update' kind of method ???
            MPLOG(@"Will add    patientNotification [%@]", pn.seq);
        }
    }
    [self refreshFilters];
    [self saveOnDevice];
    [self tellListenersAboutRefresh];
}

- (void)tellListenersAboutRefresh {
    if (![AppState sharedAppState].isInBackground) {
        dispatch_async(dispatch_get_main_queue(), ^{
            TRACE(@"Posting patientNotification refresh event.");
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationsModelRefreshNotification object:nil userInfo:nil];
        });
    } else {
        // theory that this could cause the mysterious app disabling account while in background
        MPLOG(@"NOT posting notifications refresh event while in background.");
    }
}

- (void)refreshFromServer {

    TRACE_KILLROY

    [self readFromServerSince:self.lastRefreshed];

}

- (void)refreshFromServerWithSuccess:(VoidBlock)successBlock andError:(VoidBlock)errorBlock  __unused {

    TRACE_KILLROY

    _refreshSuccessBlock = [successBlock copy];
    _refreshFailedBlock  = [errorBlock copy];
    [self refreshFromServer];

}

- (void)refreshFilters {
    [_allNotificationFilter refreshFilter];
    [_patientNotificationFilter refreshFilter];
    [_infoNotificationFilter refreshFilter];
    [_alertNotificationFilter refreshFilter];
    [_practitionerNotificationFilter refreshFilter];
    [_privateMessageNotificationFilter refreshFilter];
    [_appointmentNotificationFilter refreshFilter];
    [_conversationNotificationFilter refreshFilter];
}

- (void)resetFilters {
    [_allNotificationFilter resetFilter];
    [_patientNotificationFilter resetFilter];
    [_infoNotificationFilter resetFilter];
    [_alertNotificationFilter resetFilter];
    [_practitionerNotificationFilter resetFilter];
    [_privateMessageNotificationFilter resetFilter];
    [_appointmentNotificationFilter resetFilter];
    [_conversationNotificationFilter resetFilter];

}

#pragma mark - setters getters

- (NotificationsModelFilter *)allNotificationFilter {
    return _allNotificationFilter;
}

- (NotificationsModelFilter *)patientNotificationFilter {
    return _patientNotificationFilter;
}

- (NotificationsModelFilter *)infoNotificationFilter {
    return _infoNotificationFilter;
}

- (NotificationsModelFilter *)practitionerNotificationFilter {
    return _practitionerNotificationFilter;
}

- (NotificationsModelFilter *)appointmentNotificationsFilter {
    return _appointmentNotificationFilter;
}

- (NotificationsModelFilter *)privateMessageNotificationFilter {
    return _privateMessageNotificationFilter;
}

- (NotificationsModelFilter *)conversationNotificationFilter {
    return _conversationNotificationFilter;
}

- (void)setPatientNotificationsFilter:(NotificationsModelFilter *)patientFilter {
    _patientNotificationFilter = patientFilter;
    [_patientNotificationFilter refreshFilter];
}

- (void)setInfoNotificationsFilter:(NotificationsModelFilter *)infoFilter {
    _infoNotificationFilter = infoFilter;
    [_infoNotificationFilter refreshFilter];
}

- (void)setPractitionerNotificationsFilter:(NotificationsModelFilter *)practitionerFilter {
    _practitionerNotificationFilter = practitionerFilter;
    [_practitionerNotificationFilter refreshFilter];
}

- (void)setAlertNotificationsFilter:(NotificationsModelFilter *)alertFilter {
    _alertNotificationFilter = alertFilter;
    [_alertNotificationFilter refreshFilter];
}

- (void)setPrivateMessageNotificationsFilter:(NotificationsModelFilter *)telexFilter {
    _privateMessageNotificationFilter = telexFilter;
    [_privateMessageNotificationFilter refreshFilter];
}

- (void)setAppointmentFilter:(NotificationsModelFilter *)appointmentFilter {
    _appointmentNotificationFilter = appointmentFilter;
    [_appointmentNotificationFilter refreshFilter];
}

#pragma mark - change stack

- (void)addMessageChange:(MessageDistributionProgressChange *)change __unused {

    // first find the message, then the notification

    IBMessageDistribution *distribution = change.messageDistribution;
    PatientNotification   *notification = nil;

    for (PatientNotification *not in [_allNotifications allValues]) {
        if (not.message) {
            for (IBMessageDistribution *dist in [not.message distribution]) {
                if ([dist.guid isEqualToString:distribution.guid]) {
                    notification = not;
                }
            }
        }
    }

    if (!notification || !distribution) {
        MPLOGERROR(@"*** Cant add change : no patientNotification or distribution ");
        return;
    }

    if ([change.progress isEqualToString:@"archived"]) {
        if (distribution.archivedOn) return;
        distribution.archivedOn = change.date;
        distribution.progress   = change.progress;
        [self->_queuedMessageStateChanges addObject:change];
    } else if ([change.progress isEqualToString:@"seen"]) {
        if (distribution.seenOn) return;
        distribution.seenOn   = change.date;
        distribution.progress = change.progress;
        [self->_queuedMessageStateChanges addObject:change];
    } else if ([change.progress isEqualToString:@"acknowledged"]) {
        if (distribution.ackedOn) return;
        if (!distribution.mustAck) {
            MPLOGERROR(@"*** Cant add change : wont ack a distribution that does not require ack ");
            return;
        }
        distribution.ackedOn  = change.date;
        distribution.progress = change.progress;
        [self->_queuedMessageStateChanges addObject:change];
    } else {
        MPLOGERROR(@"*** Cant add change : no rule for progress [%@] ", change.progress);
        return;
    }
}

- (void)addNotificationChange:(NotificationProgressChange *)change {
    PatientNotification *notification = _allNotifications[change.notification.seq];
    if (notification) {
        if ([change.progress isEqualToString:@"seen"]) {
            if ([notification.progress isEqualToString:@"created"] ||
                    [notification.progress isEqualToString:@"delivered"]
                    ) {
                [self->_queuedNotificationStateChanges addObject:change];
                notification.progress = change.progress;
                notification.seenOn   = change.date;
                [self refreshFilters];
            } else {
                TRACE(@"Not changing progress from [%@] to [%@]", notification.progress, change.progress);
            }
        } else if ([change.progress isEqualToString:@"archived"]) {
            if (![notification.progress isEqualToString:@"archived"]) {
                [self->_queuedNotificationStateChanges addObject:change];
                notification.progress = change.progress;
                [self refreshFilters];
            }
        } else if ([change.progress isEqualToString:@"acknowledged"]) {
            if (![notification.progress isEqualToString:@"acknowledged"]) {
                [self->_queuedNotificationStateChanges addObject:change];
                notification.progress = change.progress;
                notification.ackedOn  = change.date;
                [self refreshFilters];
            }
        }
    } else {
        MPLOGERROR(@"*** Cant change state of notification with guid [%@], no such patientNotification.", change.notification.guid);
    }
}

- (void)sendStackedMessageChanges __unused {
    if (_isSendingStackedMessageChanges) {
        MPLOGERROR(@"*** Currently sending message changes, not sending again.");
        return;
    }
    [self sendStackedMessageChangesOnSuccess:^() {
        TRACE(@"Immediate message changes send succesful.");
    }                                onError:^() {
        MPLOGERROR(@"*** Immediate message changes send failed.");
    }];
}

- (void)sendStackedNotificationChanges __unused {
    if (_isSendingStackedNotificationChanges) {
        TRACE(@"*** Currently sending changes, not sending again.");
        return;
    }
    [self sendStackedNotificationChangesOnSuccess:^() {
        TRACE(@"Immediate patientNotification changes send succesful.");
    }                                     onError:^() {
        MPLOGERROR(@"*** Immediate patientNotification changes send failed.");
    }];
}

- (BOOL)hasQueuedMessageChanges {
    return (_queuedMessageStateChanges.count > 0);
}

- (BOOL)hasQueuedNotificationChanges {
    return (_queuedNotificationStateChanges.count > 0);
}

- (void)sendStackedMessageChangesOnSuccess:(VoidBlock)stackSuccess onError:(VoidBlock)stackError {

    if (_isSendingStackedMessageChanges) {
        TRACE(@"*** Currently sending message changes, not sending again.");
        if (stackSuccess) stackSuccess();
        return;
    }

    _stackedMessageChangesSuccessBlock = [stackSuccess copy];
    _stackedMessageChangesErrorBlock   = [stackError copy];
    _isSendingStackedMessageChanges    = YES;
    _stackedMessageStateChanges        = _queuedMessageStateChanges;
    _queuedMessageStateChanges         = [NSMutableArray array];

    // now go talk to mama

    if (_stackedMessageStateChanges.count <= 0) {
        if (_stackedMessageChangesSuccessBlock) {
            _stackedMessageChangesSuccessBlock();
        }
        _stackedMessageChangesSuccessBlock = nil;
        _stackedMessageChangesErrorBlock   = nil;
        _isSendingStackedMessageChanges    = NO;
        return;
    }

    EHRApiServer     *server = [SecureCredentials sharedCredentials].current.server;
    EHRServerRequest *req    = [EHRServerRequest serverRequestWithApiKey:[SecureCredentials sharedCredentials].current.userApiKey];
    req.server   = server;
    req.route    = @"/app/message/distribution";
    req.command  = @"setProgress";
    req.language = [AppState sharedAppState].deviceLanguage;

    req.parameters = [NSMutableDictionary dictionary];
    req.parameters[@"since"] = NetworkDateFromDate(self.lastRefreshed);
    NSMutableArray                         *ar = [NSMutableArray array];
    for (MessageDistributionProgressChange *progressChange in _stackedMessageStateChanges) {
        [ar addObject:[progressChange asNetworkObject]];
    }
    req.parameters[@"changes"] = ar;

    EHRCall *call        = [EHRCall callWithRequest:req onSuccess:^(EHRCall *theCall) {
        EHRServerResponse *resp = theCall.serverResponse;
        TRACE(@"Got response from /app/message/distribution[setProgress] with requestStatus %@", [resp.requestStatus asDictionary]);
        NSString  *apiStatus = resp.requestStatus.status;
        VoidBlock _after     = ^{
            if (self->_stackedMessageChangesSuccessBlock) {
                self->_stackedMessageChangesSuccessBlock();
                self->_stackedMessageChangesSuccessBlock = nil;
                self->_stackedMessageChangesErrorBlock   = nil;
            }
            self->_isSendingStackedMessageChanges = NO;
            [self->_stackedMessageStateChanges removeAllObjects];
        };

        if ([apiStatus isEqualToString:@"OK"]) {
            id dic = theCall.serverResponse.responseContent;
            if ([dic count] == 0) {
                TRACE(@"Received [%ld] messages", (unsigned long) [dic count]);
                _after();
            } else {
                NSDictionary *notifications = [dic objectForKey:@"notifications"];
                if (notifications) {
                    TRACE(@"Received [%ld] notifications", (unsigned long) [notifications count]);
                    [self populateFilterFromDictionary:notifications];
                    _after();
                } else {
                    TRACE(@"Received [0] notifications");
                    _after();
                }
            }
        } else {
            // status was not OK !
            MPLOGERROR(@"*** Got status [%@], message [%@]", apiStatus, resp.requestStatus.message);
            if (self->_stackedMessageChangesErrorBlock) {
                self->_stackedMessageChangesErrorBlock();
                self->_stackedMessageChangesSuccessBlock = nil;
                self->_stackedMessageChangesErrorBlock   = nil;
            }
            self->_isSendingStackedMessageChanges = NO;
            [self->_stackedMessageStateChanges removeAllObjects];
        }
    }                                       onError:^(EHRCall *theCall) {

        // restored queued changes for next call if needed

        if (self->_queuedMessageStateChanges.count > 0) {

            // restore a _queuedMessageStateChanges for next attempt

            NSMutableArray *array = [NSMutableArray arrayWithArray:
                    [self->_stackedMessageStateChanges arrayByAddingObjectsFromArray:self->_queuedMessageStateChanges]];
            self->_queuedMessageStateChanges  = array;
            self->_stackedMessageStateChanges = [NSMutableArray array];

        } else {
            self->_queuedMessageStateChanges  = self->_stackedMessageStateChanges;
            self->_stackedMessageStateChanges = [NSMutableArray array];
        }
        self->_isRefreshing                   = NO;
        if (self->_stackedMessageChangesErrorBlock) {
            self->_stackedMessageChangesErrorBlock();
            self->_stackedMessageChangesSuccessBlock = nil;
            self->_stackedMessageChangesErrorBlock   = nil;
        }
        self->_isSendingStackedMessageChanges = NO;
    }];
    call.maximumAttempts = 3;
    call.timeOut         = 15;
    [call start];
}

- (void)sendStackedNotificationChangesOnSuccess:(VoidBlock)stackSuccess onError:(VoidBlock)stackError {

    if (_isSendingStackedNotificationChanges) {
        TRACE(@"*** Currently sending changes, not sending again.");
        if (stackSuccess) stackSuccess();
        return;
    }

    _stackedNotificationChangesSuccessBlock = [stackSuccess copy];
    _stackedNotificationChangesErrorBlock   = [stackError copy];
    _isSendingStackedNotificationChanges    = YES;
    _stackedNotificationStateChanges        = _queuedNotificationStateChanges;
    _queuedNotificationStateChanges         = [NSMutableArray array];

    // now go talk to mama

    if (_stackedNotificationStateChanges.count <= 0) {
        if (_stackedNotificationChangesSuccessBlock) {
            _stackedNotificationChangesSuccessBlock();
        }
        _stackedNotificationChangesSuccessBlock = nil;
        _stackedNotificationChangesErrorBlock   = nil;
        _isSendingStackedNotificationChanges    = NO;
        return;
    }

    EHRApiServer     *server = [SecureCredentials sharedCredentials].current.server;
    EHRServerRequest *req    = [EHRServerRequest serverRequestWithApiKey:[SecureCredentials sharedCredentials].current.userApiKey];
    req.server   = server;
    req.route    = @"/app/notification";
    req.command  = @"setProgress";
    req.language = [AppState sharedAppState].deviceLanguage;

    req.parameters = [NSMutableDictionary dictionary];
    req.parameters[@"since"] = NetworkDateFromDate(self.lastRefreshed);
    NSMutableArray                  *ar = [NSMutableArray array];
    for (NotificationProgressChange *progressChange in _stackedNotificationStateChanges) {
        [ar addObject:[progressChange asNetworkObject]];
    }
    req.parameters[@"changes"] = ar;

    EHRCall *call        = [EHRCall callWithRequest:req onSuccess:^(EHRCall *theCall) {
        EHRServerResponse *resp = theCall.serverResponse;
        TRACE(@"Got response with requestStatus %@", [resp.requestStatus asDictionary]);
        NSString  *apiStatus = resp.requestStatus.status;
        VoidBlock _after     = ^{
            if (self->_stackedNotificationChangesSuccessBlock) {
                self->_stackedNotificationChangesSuccessBlock();
                self->_stackedNotificationChangesSuccessBlock = nil;
                self->_stackedNotificationChangesErrorBlock   = nil;
            }
            self->_isSendingStackedNotificationChanges = NO;
            [self->_stackedNotificationStateChanges removeAllObjects];
        };

        if ([apiStatus isEqualToString:@"OK"]) {
            id dic = theCall.serverResponse.responseContent;
            if ([dic count] == 0) {
                TRACE(@"Received [%ld] notifications", (unsigned long) [dic count]);
                _after();
            } else {
                NSDictionary *notifications = [dic objectForKey:@"notifications"];
                if (notifications) {
                    TRACE(@"Received [%ld] notifications", (unsigned long) [notifications count]);
                    [self populateFilterFromDictionary:notifications];
                    _after();
                } else {
                    TRACE(@"Received [0] notifications");
                    _after();
                }
            }
        } else {
            // status was not OK !
            MPLOGERROR(@"Got status [%@], message [%@]", apiStatus, resp.requestStatus.message);
            if (self->_stackedNotificationChangesErrorBlock) {
                self->_stackedNotificationChangesErrorBlock();
                self->_stackedNotificationChangesSuccessBlock = nil;
                self->_stackedNotificationChangesErrorBlock   = nil;
            }
            self->_isSendingStackedNotificationChanges = NO;
            [self->_stackedNotificationStateChanges removeAllObjects];
        }
    }                                       onError:^(EHRCall *theCall) {

        // restored queued changes for next call if needed

        if (self->_queuedNotificationStateChanges.count > 0) {

            // restore a _queuedNotificationStateChanges for next attempt

            NSMutableArray *array = [NSMutableArray arrayWithArray:
                    [self->_stackedNotificationStateChanges arrayByAddingObjectsFromArray:self->_queuedNotificationStateChanges]];
            self->_queuedNotificationStateChanges  = array;
            self->_stackedNotificationStateChanges = [NSMutableArray array];

        } else {
            self->_queuedNotificationStateChanges  = self->_stackedNotificationStateChanges;
            self->_stackedNotificationStateChanges = [NSMutableArray array];
        }
        self->_isRefreshing                        = NO;
        if (self->_stackedNotificationChangesErrorBlock) {
            self->_stackedNotificationChangesErrorBlock();
            self->_stackedNotificationChangesSuccessBlock = nil;
            self->_stackedNotificationChangesErrorBlock   = nil;
        }
        self->_isSendingStackedNotificationChanges = NO;
    }];
    call.maximumAttempts = 3;
    call.timeOut         = 15;
    [call start];
}

#pragma mark - persistence

- (void)notificationWasSeen:(PatientNotification *)notification {

    if (!_appState.isAppUsable) return;

    SenderBlock successBlock = ^(EHRCall *theCall) {
#if MP_DEBUG == 1
        EHRServerResponse *resp = theCall.serverResponse;
        TRACE(@"Got response with requestStatus %@", [resp.requestStatus asDictionary]);
#endif
        BOOL updated = [theCall.serverResponse.requestStatus.status isEqualToString:@"OK"];
        if (updated) {
            notification.lastSeen    = [NSDate date];
            notification.lastUpdated = notification.lastSeen;
            if (nil == notification.seenOn) notification.seenOn = notification.lastSeen;
            //                                           self.lastRefreshed  = [NSDate date];
            [self saveOnDevice];
            if (self->_notificationSeenSuccessBlock) {
                self->_notificationSeenSuccessBlock();
                self->_notificationSeenSuccessBlock = nil;
                self->_notificationSeenErrorBlock   = nil;
            }
        } else {
            MPLOGERROR(@"Request to set patientNotification as seen failed.");
            MPLOGERROR(@"status  : %@", theCall.serverResponse.requestStatus.status);
            MPLOGERROR(@"message : %@", theCall.serverResponse.requestStatus.message);
            if (self->_notificationSeenErrorBlock) {
                self->_notificationSeenErrorBlock();
                self->_notificationSeenSuccessBlock = nil;
                self->_notificationSeenErrorBlock   = nil;
            }
        }
        [self refreshFilters];
    };
    SenderBlock errorBlock   = ^(EHRCall *theCall) {
        if (self->_notificationSeenErrorBlock) {
            self->_notificationSeenErrorBlock();
            self->_notificationSeenSuccessBlock = nil;
            self->_notificationSeenErrorBlock   = nil;
        }
    };

    EHRCall *call = [PehrSDKConfig.shared.ws.notification setSeen:notification
                                                        onSuccess:successBlock
                                                          onError:errorBlock];

    call.maximumAttempts = 3;
    call.timeOut         = 15;
    [call start];

}

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"

- (void)notificationWasSeen:(PatientNotification *)notification onSuccess:(VoidBlock)successBlock onError:(VoidBlock)errorBlock {
    _notificationSeenSuccessBlock = [successBlock copy];
    _notificationSeenErrorBlock   = [errorBlock copy];
    [self notificationWasSeen:notification];
}

#pragma clang diagnostic pop


//region Archive notificaitons

- (void)notificationWasArchived:(PatientNotification *)notification onSuccess:(VoidBlock)successBlock onError:(VoidBlock)errorBlock __unused {
    _notificationArchivedSuccessBlock = [successBlock copy];
    _notificationArchivedErrorBlock   = [errorBlock copy];
    [self notificationWasArchived:notification];
}

- (void)notificationWasArchived:(PatientNotification *)notification __unused {

    if (!_appState.isAppUsable) {
        TRACE(@"Skipping : application not usable on this device.");
        if (_notificationArchivedErrorBlock) {
            _notificationArchivedErrorBlock();
            _notificationArchivedSuccessBlock = nil;
            _notificationArchivedErrorBlock   = nil;
        }
        return;
    }
    if (notification.ackedOn) {
        TRACE(@"Skipping : patientNotification has already been acked.");
        if (_notificationArchivedSuccessBlock) {
            _notificationArchivedSuccessBlock();
            _notificationArchivedSuccessBlock = nil;
            _notificationArchivedErrorBlock   = nil;
        }
        return;
    }

    EHRApiServer     *server = [SecureCredentials sharedCredentials].current.server;
    EHRServerRequest *req    = [EHRServerRequest serverRequestWithApiKey:[SecureCredentials sharedCredentials].current.userApiKey];
    req.server   = server;
    req.route    = @"/app/notification";
    req.command  = @"archive";
    req.language = [AppState sharedAppState].deviceLanguage;

    req.parameters = [@{@"guid": notification.guid} mutableCopy];
    EHRCall *call        = [EHRCall
            callWithRequest:req
                  onSuccess:^(EHRCall *theCall) {
#if MP_DEBUG == 1
                      EHRServerResponse *resp = theCall.serverResponse;
                      TRACE(@"Got response with requestStatus %@", [resp.requestStatus asDictionary]);
#endif
                      BOOL updated = [theCall.serverResponse.requestStatus.status isEqualToString:@"OK"];
                      if (updated) {
                          if (!notification.seenOn) notification.seenOn = [NSDate date];
                          notification.archivedOn = [NSDate date];
                          notification.progress   = @"archived";
//                                           self.lastRefreshed   = [NSDate date];
                          [self refreshFilters];
                          [self saveOnDevice];
                          if (self->_notificationArchivedSuccessBlock) {
                              self->_notificationArchivedSuccessBlock();
                              self->_notificationArchivedSuccessBlock = nil;
                              self->_notificationArchivedErrorBlock   = nil;
                          }
                      } else {
                          MPLOGERROR(@"Request to set patientNotification as seen failed.");
                          MPLOGERROR(@"status  : %@", theCall.serverResponse.requestStatus.status);
                          MPLOGERROR(@"message : %@", theCall.serverResponse.requestStatus.message);
                          if (self->_notificationArchivedErrorBlock) {
                              self->_notificationArchivedErrorBlock();
                              self->_notificationArchivedSuccessBlock = nil;
                              self->_notificationArchivedErrorBlock   = nil;
                          }
                      }
                      [self refreshFilters];
                  }
                    onError:^(EHRCall *theCall) {
                        if (self->_notificationArchivedErrorBlock) {
                            self->_notificationArchivedErrorBlock();
                            self->_notificationArchivedSuccessBlock = nil;
                            self->_notificationArchivedErrorBlock   = nil;
                        }
                    }];
    call.maximumAttempts = 3;
    call.timeOut         = 15;
    [call start];

}

//endregion

//region Delete notifications


- (void)notificationWasDeleted:(PatientNotification *)notification onSuccess:(VoidBlock)successBlock onError:(VoidBlock)errorBlock {
    _notificationDeletedSuccessBlock = [successBlock copy];
    _notificationDeletedErrorBlock   = [errorBlock copy];
    NSMutableArray *notifications = [@[notification] mutableCopy];
    [self notificationsWereDeleted:notifications];
}

- (void)notificationsWereDeleted:(NSArray *)notifications onSuccess:(VoidBlock)successBlock onError:(VoidBlock)errorBlock {
    _notificationDeletedSuccessBlock = [successBlock copy];
    _notificationDeletedErrorBlock   = [errorBlock copy];
    [self notificationsWereDeleted:notifications];
}

- (void)notificationsWereDeleted:(NSArray *)notifications {
    if (!_appState.isAppUsable) {
        TRACE(@"Skipping : application not usable on this device.");
        if (_notificationDeletedErrorBlock) {
            _notificationDeletedErrorBlock();
            _notificationDeletedSuccessBlock = nil;
            _notificationDeletedErrorBlock   = nil;
        }
        return;
    }

    EHRApiServer     *server = [SecureCredentials sharedCredentials].current.server;
    EHRServerRequest *req    = [EHRServerRequest serverRequestWithApiKey:[SecureCredentials sharedCredentials].current.userApiKey];
    req.server  = server;
    req.route   = @"/app/notification";
    req.command = @"deleteNotification";

    NSMutableArray           *guids = [NSMutableArray array];
    for (PatientNotification *notification in notifications) {
        [guids addObject:notification.guid];
    }
    req.parameters = @{@"guids": guids}.mutableCopy;
    EHRCall *call        = [EHRCall callWithRequest:req onSuccess:^(EHRCall *theCall) {
#if MP_DEBUG == 1
        EHRServerResponse *resp = theCall.serverResponse;
        TRACE(@"Deleted notifications : got response with requestStatus %@", [resp.requestStatus asDictionary]);
#endif
        BOOL updated = [theCall.serverResponse.requestStatus.status isEqualToString:@"OK"];
        if (updated) {

            // _allNotifications is indexed on SEQ , we have guids

            NSMutableArray           *droppers = [NSMutableArray array];
            for (PatientNotification *pn in [self->_allNotifications allValues]) {
                if ([guids containsObject:pn.guid]) {
                    pn.progress  = @"deleted";
                    pn.deletedOn = [NSDate date];
                    [droppers addObject:pn.guid];
                }
            }

            if ([droppers count] == [guids count]) {
                TRACE(@"Flushing %ld notifications", (unsigned long) [droppers count]);
                for (NSString *seq in droppers) {
                    [self->_allNotifications removeObjectForKey:seq];
                }
                [self refreshFilters];
                [self saveOnDevice];
                if (self->_notificationDeletedSuccessBlock) {
                    self->_notificationDeletedSuccessBlock();
                    self->_notificationDeletedSuccessBlock = nil;
                    self->_notificationDeletedErrorBlock   = nil;
                }
            } else {
                MPLOGERROR(@"*** SEQ index does not match GUID indes !!!");
                if (self->_notificationDeletedErrorBlock) {
                    self->_notificationDeletedErrorBlock();
                    self->_notificationDeletedSuccessBlock = nil;
                    self->_notificationDeletedErrorBlock   = nil;
                }
            }
        } else {
            MPLOGERROR(@"Request to set patientNotification as deleted failed.");
            MPLOGERROR(@"status  : %@", theCall.serverResponse.requestStatus.status);
            MPLOGERROR(@"message : %@", theCall.serverResponse.requestStatus.message);
            if (self->_notificationDeletedErrorBlock) {
                self->_notificationDeletedErrorBlock();
                self->_notificationDeletedSuccessBlock = nil;
                self->_notificationDeletedErrorBlock   = nil;
            }
        }
        [self refreshFilters];
    }                                       onError:^(EHRCall *theCall) {
        MPLOGERROR(@"Request to set patientNotification as deleted failed.");
        MPLOGERROR(@"status  : %@", theCall.serverResponse.requestStatus.status);
        MPLOGERROR(@"message : %@", theCall.serverResponse.requestStatus.message);
        if (self->_notificationDeletedErrorBlock) {
            self->_notificationDeletedErrorBlock();
            self->_notificationDeletedSuccessBlock = nil;
            self->_notificationDeletedErrorBlock   = nil;
        }
    }];
    call.maximumAttempts = 3;
    call.timeOut         = 15;
    [call start];
}

//endregion

- (BOOL)saveOnDevice {
    return YES;
//    if ([AppState sharedAppState].isInBackground) {
//        MPLOG(@"Not saving notifications while in background ...");
//        return YES;
//    }
//    NSDictionary *dictionary = [self asDictionary];
//    BOOL         status      = [dictionary writeToFile:_notificationsFileFQN atomically:YES];
//    if (!status) {
//        MPLOGERROR(@"*** Unknown error while Saving [%@]", _notificationsFileFQN);
//    }
//    return status;
}

- (void)purgeExpired {
    NSMutableArray           *scrapKeys = [NSMutableArray array];
    for (PatientNotification *pn in [_allNotifications allValues]) {
        if (pn.isExpired) [scrapKeys addObject:pn.guid];
    }

    for (NSString *seq in scrapKeys) {
        [_allNotifications removeObjectForKey:seq];
        TRACE(@"Removing expired patientNotification with seq [%@]", seq);
    }
    self.lastPurgedExpired = [NSDate date];
    [self saveOnDevice];

}

+ (NotificationsModel *)readFromDevice {
    NSDictionary       *dic = [NSDictionary dictionaryWithContentsOfFile:_notificationsFileFQN];
    NotificationsModel *nm  = [self objectWithContentsOfDictionary:dic];
    [nm purgeExpired];
    [nm setAllFilters];
    [nm refreshFilters];
    return nm;
}

- (void)reloadFromDevice {
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:_notificationsFileFQN];
    [self loadFromDic:dic];

    [self purgeExpired];
    [self setAllFilters];
    [self refreshFilters];

}

- (void)setAllFilters {

    [self setPatientNotificationsFilter:_appState.userModel.deviceSettings.patientNotificationsFilter];
    [self setAlertNotificationsFilter:_appState.userModel.deviceSettings.alertNotificationsFilter];
    [self setInfoNotificationsFilter:_appState.userModel.deviceSettings.infoNotificationsFilter];
    [self setPractitionerNotificationsFilter:_appState.userModel.deviceSettings.practitionerNotificationsFilter];
    [self setPrivateMessageNotificationsFilter:_appState.userModel.deviceSettings.telexNotificationsFilter];
    [self setAppointmentFilter:_appState.userModel.deviceSettings.appointmentNotificationsFilter];

}

- (BOOL)eraseFromDevice:(BOOL)__unused cascade {
    // keep the 'core' version honest
    [_allNotifications removeAllObjects];
    [self->_stackedNotificationStateChanges removeAllObjects];
    [self->_queuedNotificationStateChanges removeAllObjects];
    [self resetFilters];
    // wipe the device's ass with a silk cloth (sez the merovingian)
    return [[GEFileUtil sharedFileUtil] eraseItemWithFQN:_notificationsFileFQN];
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
    _allNotificationFilter            = nil;
    _patientNotificationFilter        = nil;
    _infoNotificationFilter           = nil;
    _practitionerNotificationFilter   = nil;
    _privateMessageNotificationFilter = nil;
    _refreshFailedBlock               = nil;
    _refreshSuccessBlock              = nil;
    _appState                         = nil;
    _queuedNotificationStateChanges   = nil;
    _stackedNotificationStateChanges  = nil;
    _queuedMessageStateChanges        = nil;
    _stackedMessageStateChanges       = nil;
    _notificationDeletedErrorBlock    = nil;
    _notificationDeletedSuccessBlock  = nil;
    _notificationArchivedErrorBlock   = nil;
    _notificationArchivedSuccessBlock = nil;
    _notificationSeenErrorBlock       = nil;
    _notificationSeenSuccessBlock     = nil;
    _appointmentNotificationFilter    = nil;
}

@end

#pragma clang diagnostic pop
