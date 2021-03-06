//
// Created by Yves Le Borgne on 2015-11-16.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "NotificationsModelFilter.h"
#import "AppState.h"
#import "UserModel.h"
#import "NotificationsModel.h"
#import "PatientNotification.h"
#import "IBUser.h"
#import "Patient.h"
#import "IBMessageContent.h"
#import "IBMessageDistribution.h"
#import "IBAppointment.h"

@implementation NotificationsModelFilter

@synthesize showInfoNotifications = _showInfoNotifications;
@synthesize showAlertNotifications = _showAlertNotifications;
@synthesize showPatientNotifications = _showPatientNotifications;
@synthesize showSponsorNotifications = _showSponsorNotifications;
@synthesize showPractitionerNotifications = _showPractitionerNotifications;
@synthesize showMessageNotifications = _showMessageNotifications;
@synthesize showPrivateMessageNotifications = _showPrivateMessageNotifications;
@synthesize showAppointmentNotifications = _showAppointmentNotifications;
@synthesize notificationsPerPage = _notificationsPerPage;
@synthesize showUnreadOnly = _showUnreadOnly;
@synthesize showArchived = _showArchived;
@synthesize filterType = _filterType;
@dynamic sortedKeys;
@dynamic numberOfUnseen;
@dynamic numberOfArchived;
@dynamic numberOfActionRequired;
@dynamic numberOfPrivateMessages;
@dynamic cursor;
@dynamic next;
@dynamic previous;
@dynamic count;

TRACE_OFF

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        self.notificationsPerPage = 25;
        _filterType                      = NotificationFilterTypeAll;
        _showInfoNotifications           = YES;
        _showPatientNotifications        = YES;
        _showSponsorNotifications        = YES;
        _showPractitionerNotifications   = YES;
        _showMessageNotifications        = YES;
        _showPrivateMessageNotifications = YES;
        _showAppointmentNotifications    = NO;
        _showAlertNotifications          = YES;
        _showArchived                    = NO;
        _sortedKeys                      = [NSMutableArray array];
        _patientSelector                 = [NSMutableArray array];
        _cursorIndex                     = 0;
        _appState                        = [AppState sharedAppState];

        [[NSNotificationCenter defaultCenter]
                addObserver:self selector:@selector(refreshFilter)
                       name:kNotificationsModelRefreshNotification
                     object:nil
        ];

    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNotificationsModelRefreshNotification
                                                  object:nil
    ];

    _sortedKeys = nil;
}

#pragma mark - static configurations

+ (NotificationsModelFilter *)patientFilter __unused {
    NotificationsModelFilter *nf = [[NotificationsModelFilter alloc] init];
    [nf setFilterType:NotificationFilterTypePatient];
    [nf resetPatientSelector];
    return nf;
}

+ (NotificationsModelFilter *)sponsorFilter __unused {
    NotificationsModelFilter *nf = [[NotificationsModelFilter alloc] init];
    [nf setFilterType:NotificationFilterTypeSponsor];
    nf->_filterType = NotificationFilterTypeSponsor;
    [nf resetPatientSelector];
    return nf;
}

+ (NotificationsModelFilter *)infoFilter __unused {
    NotificationsModelFilter *nf = [[NotificationsModelFilter alloc] init];
    [nf setFilterType:NotificationFilterTypeInfo];
    [nf resetPatientSelector];
    return nf;
}

+ (NotificationsModelFilter *)alertFilter __unused {
    NotificationsModelFilter *nf = [[NotificationsModelFilter alloc] init];
    [nf setFilterType:NotificationFilterTypeAlert];
    [nf resetPatientSelector];
    return nf;
}

+ (NotificationsModelFilter *)practitionerFilter __unused {
    NotificationsModelFilter *nf = [[NotificationsModelFilter alloc] init];
    [nf setFilterType:NotificationFilterTypePractitioner];
    [nf resetPatientSelector];
    return nf;
}

+ (NotificationsModelFilter *)messageFilter __unused {
    NotificationsModelFilter *nf = [[NotificationsModelFilter alloc] init];
    [nf setFilterType:NotificationFilterTypeMessage];
    [nf resetPatientSelector];
    return nf;
}

+ (NotificationsModelFilter *)appointmentFilter  __unused {
    NotificationsModelFilter *nf = [[NotificationsModelFilter alloc] init];
    [nf setFilterType:NotificationFilterTypeAppointment];
    [nf resetPatientSelector];
    return nf;
}

+ (NotificationsModelFilter *)telexFilter __unused {
    NotificationsModelFilter *nf = [[NotificationsModelFilter alloc] init];
    [nf setFilterType:NotificationFilterTypePrivateMessage];
    [nf resetPatientSelector];
    return nf;
}

+ (NotificationsModelFilter *)allFilter __unused {
    NotificationsModelFilter *nf = [[NotificationsModelFilter alloc] init];
    return nf;
}

#pragma mark getters

- (NSArray *)sortedKeys __unused {
    return _sortedKeys;
}

- (NSInteger)numberOfUnseen __unused {
    NSInteger     _number = 0;
    for (NSString *key in _sortedKeys) {
        PatientNotification *not = [AppState sharedAppState].userModel.notificationsModel.allNotifications[key];
        if (not && not.hasUnseenContent) {
            _number++;
            TRACE(@"Notification has unseen content : %@ ", not.seq);
        }
    }
    return _number;
}

- (NSInteger)numberOfActionRequired {
    NSInteger     _number = 0;
    for (NSString *key in _sortedKeys) {
        PatientNotification *not = [AppState sharedAppState].userModel.notificationsModel.allNotifications[key];
        if (!not) continue;
        if (not.isDeleted) continue;
        if (not.isArchived) continue;
        if (not.isActionRequired) {
            _number++;
            TRACE(@"Notification has unseen content : %@ ", not.seq);
        }
    }
    return _number;
}

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"

- (NSInteger)numberOfArchived {
    NSInteger     _number = 0;
    for (NSString *key in _sortedKeys) {

        PatientNotification *not = [AppState sharedAppState].userModel.notificationsModel.allNotifications[key];
        if (not && !not.isArchived) _number++;
    }
    return _number;
}

#pragma clang diagnostic pop

- (NSInteger)numberOfPrivateMessages {
    NSInteger     _number    = 0;
    NSDictionary  *allOfThem = [AppState sharedAppState].userModel.notificationsModel.allNotifications;
    for (NSString *key in allOfThem.allKeys) {
        PatientNotification *not = [AppState sharedAppState].userModel.notificationsModel.allNotifications[key];
        if (not && not.isDeleted) continue;
        if (not && not.isPrivateMessage) _number++;
    }
    return _number;
}

- (NSInteger)count {
    return _sortedKeys.count;
}

#pragma mark - setters

- (void)setFilterType:(NotificationFilterType)filterType __unused {
    BOOL change = (filterType != _filterType);
    _filterType = filterType;
    switch (filterType) {
        case NotificationFilterTypeAppointment:_showInfoNotifications = NO;
            _showAlertNotifications          = NO;
            _showPatientNotifications        = NO;
            _showSponsorNotifications        = NO;
            _showPractitionerNotifications   = NO;
            _showMessageNotifications        = NO;
            _showPrivateMessageNotifications = NO;
            _showAppointmentNotifications    = YES;
            break;
        case NotificationFilterTypeSponsor:_showInfoNotifications = NO;
            _showAlertNotifications          = NO;
            _showPatientNotifications        = NO;
            _showSponsorNotifications        = YES;
            _showPractitionerNotifications   = NO;
            _showMessageNotifications        = NO;
            _showPrivateMessageNotifications = NO;
            _showAppointmentNotifications    = NO;
            break;

        case NotificationFilterTypeInfo:

            _showInfoNotifications           = YES;
            _showAlertNotifications          = NO;
            _showPatientNotifications        = NO;
            _showSponsorNotifications        = NO;
            _showPractitionerNotifications   = NO;
            _showMessageNotifications        = NO;
            _showPrivateMessageNotifications = NO;
            _showAppointmentNotifications    = NO;
            break;
        case NotificationFilterTypeAlert:

            _showInfoNotifications           = NO;
            _showAlertNotifications          = YES;
            _showPatientNotifications        = NO;
            _showSponsorNotifications        = NO;
            _showPractitionerNotifications   = NO;
            _showMessageNotifications        = NO;
            _showPrivateMessageNotifications = NO;
            _showAppointmentNotifications    = NO;
            break;
        case NotificationFilterTypePatient:

            _showInfoNotifications           = NO;
            _showAlertNotifications          = NO;
            _showPatientNotifications        = YES;
            _showSponsorNotifications        = NO;
            _showPractitionerNotifications   = NO;
            _showMessageNotifications        = NO;
            _showPrivateMessageNotifications = NO;
            _showAppointmentNotifications    = NO;
            break;

        case NotificationFilterTypePractitioner:

            _showInfoNotifications           = NO;
            _showAlertNotifications          = NO;
            _showSponsorNotifications        = NO;
            _showPatientNotifications        = NO;
            _showPractitionerNotifications   = YES;
            _showMessageNotifications        = NO;
            _showPrivateMessageNotifications = NO;
            _showAppointmentNotifications    = NO;
            break;

        case NotificationFilterTypeMessage:

            _showInfoNotifications           = NO;
            _showAlertNotifications          = NO;
            _showSponsorNotifications        = NO;
            _showPatientNotifications        = NO;
            _showPractitionerNotifications   = NO;
            _showMessageNotifications        = YES;
            _showPrivateMessageNotifications = NO;
            _showAppointmentNotifications    = NO;
            break;

        case NotificationFilterTypePrivateMessage:

            _showInfoNotifications           = NO;
            _showAlertNotifications          = NO;
            _showSponsorNotifications        = NO;
            _showPatientNotifications        = NO;
            _showPractitionerNotifications   = NO;
            _showMessageNotifications        = NO;
            _showPrivateMessageNotifications = YES;
            _showAppointmentNotifications    = NO;
            break;

        case NotificationFilterTypeAll:
        default:

            _showInfoNotifications           = YES;
            _showAlertNotifications          = YES;
            _showPatientNotifications        = YES;
            _showSponsorNotifications        = YES;
            _showPractitionerNotifications   = YES;
            _showMessageNotifications        = NO;
            _showPrivateMessageNotifications = NO;
            _showAppointmentNotifications    = NO;
            break;
    }
    if (change) {
        [self refreshFilter];
    }
}

- (void)setShowInfoNotifications:(BOOL)showInfoNotifications __unused {
    BOOL change = (showInfoNotifications != _showInfoNotifications);
    self->_showInfoNotifications = showInfoNotifications;
    if (change) [self refreshFilter];
}

#pragma mark - private stuff, filter management

- (void)resetFilter {
    [_sortedKeys removeAllObjects];
    _cursorIndex = 0;
    [self resetPatientSelector];
}

- (void)refreshFilter {

    NSArray *allNotifications = [AppState sharedAppState].userModel.notificationsModel.allNotifications.allValues;

    PatientNotification *oldCursor = [self notificationAtIndex:_cursorIndex];

    _cursorIndex = 0;
    [_sortedKeys removeAllObjects];

    if ([AppState sharedAppState].userModel.notificationsModel.allNotifications.count == 0) {
        return;
    }

    [self resetPatientSelector];

    NSMutableArray *ar = [NSMutableArray array];

    for (PatientNotification *not in allNotifications) {
        BOOL keeper = NO;
        if (not.isExpired) continue;
        if (not.isDeleted) continue;
        if (not.isArchived && !_showArchived) continue;
        if (!not.isArchived && _showArchived) continue;
        if (_showUnreadOnly && not.seenOn) continue;

        // retain only the notification for the patients of interest
        if (not.isPrivateMessage && !_showPrivateMessageNotifications) continue;
        if (not.isAppointment && !_showAppointmentNotifications) continue;
        if (not.isPatient && _showPatientNotifications) {
            if (_patientSelector.count > 0) {
                if (not.patientGuid && ![_patientSelector containsObject:not.patientGuid]) continue;
                keeper = YES;
            }
        } else if (not.isInfo && _showInfoNotifications) {
            keeper = YES;
        } else if (not.isAlert && _showAlertNotifications) {
            keeper = YES;
        } else if (not.isSponsor && _showSponsorNotifications) {
            keeper = YES;
        } else if (not.isMessage && _showMessageNotifications) {
            keeper = YES;
        } else if (not.isPrivateMessage && _showPrivateMessageNotifications) {
            if (not.isArchived) {
                keeper = _showArchived;
            } else {
                keeper = YES;
            }
        } else if (not.isAppointment && _showAppointmentNotifications) {
            if (not.isArchived) {
                keeper = _showArchived;
            } else {
                keeper = YES;
            }
        }

        if (keeper) {
            TRACE(@"%lu : keeping notification with seq %@", (unsigned long) self.filterType, not.seq);
            [ar addObject:not];
        }
    }

    if (ar.count == 0) {
        return;
    }

    if (_filterType == NotificationFilterTypeAppointment) {
        [ar sortUsingComparator:^NSComparisonResult(PatientNotification *obj1, PatientNotification *obj2) {

            if (obj1.appointment.getSortOrder <  obj2.appointment.getSortOrder) {
                return (NSComparisonResult)NSOrderedDescending;
            }

            if (obj1.appointment.getSortOrder >  obj2.appointment.getSortOrder) {
                return (NSComparisonResult)NSOrderedAscending;
            }

            return (NSComparisonResult)NSOrderedSame;

        }];
    } else {
        [ar sortUsingComparator:^NSComparisonResult(PatientNotification *obj1, PatientNotification *obj2) {
            return [obj2.seq compare:obj1.seq]; // from recent to old
        }];
    }

    for (PatientNotification *not in ar) {
        [_sortedKeys addObject:not.seq];
    }

    if (oldCursor) {
        if ([ar containsObject:oldCursor]) {
            // lets locate the new (possibly) index of our cursor

            for (NSUInteger scan = 0; scan < ar.count; scan++) {
                NSString *key = _sortedKeys[scan];
                if ([key isEqualToString:oldCursor.seq]) {
                    _cursorIndex = scan;
                    return;
                }
            }
            // !! eeeek , should never get here
            MPLOG(@"*** Old cursor not found in sorted keys , reseting to top");
            _cursorIndex = 0;

        } else {
            // the refreshe flushed our old cursor , lets move to top
            _cursorIndex = 0;
        }
    } else {
        // did not hava a cursor before, lest move to top
        _cursorIndex = 0;
    }

}

- (BOOL)isAtBottom __unused {
    if (_sortedKeys.count > 0) {
        return _cursorIndex == (_sortedKeys.count - 1);
    }
    return true;
}

- (BOOL)isAtTop __unused {
    if (_sortedKeys.count > 0) {
        return _cursorIndex == 0;
    }
    return true;
}

- (BOOL)isEmpty __unused {
    return (_sortedKeys.count == 0);
}

- (void)setCursorAtTop __unused {

    _cursorIndex = 0;
}

- (void)setCursorAtBottom __unused {
    if (_sortedKeys.count > 0) {
        _cursorIndex = _sortedKeys.count - 1;
    } else {
        _cursorIndex = 0;
    }
}

- (void)setCursorAtNotification:(PatientNotification *)notification {
    if (!notification) return;
    if (_sortedKeys.count > 0) {
        if ([_sortedKeys containsObject:notification.seq]) {
            _cursorIndex = [_sortedKeys indexOfObject:notification.seq];
        } else {
            // at top
            _cursorIndex = 0;
        }
    } else {
        _cursorIndex = 0;
    }
}

- (void)moveToNext __unused {
    if (_sortedKeys.count == 0) return;
    if (_cursorIndex < (_sortedKeys.count - 1)) _cursorIndex++;
}

- (void)moveToPrevious __unused {
    if (_sortedKeys.count == 0) return;
    if (_cursorIndex > 0) {
        _cursorIndex--;
    }
}

- (PatientNotification *)cursor __unused {
    if (_sortedKeys.count == 0) return nil;

    if (_cursorIndex == 0) return [self notificationAtIndex:0];

    if (_cursorIndex <= _sortedKeys.count - 1) {
        return [self notificationAtIndex:_cursorIndex];
    } else {
        return nil;
    }
}

- (PatientNotification *)next __unused {
    if (_sortedKeys.count == 0) return nil;                 // no next, empty set
    if (_cursorIndex == _sortedKeys.count - 1) return nil;  // no next, we are on last
    return [self notificationAtIndex:(_cursorIndex + 1)];
}

- (PatientNotification *)previous __unused {
    if (_sortedKeys.count == 0) return nil;
    if (_cursorIndex >= 1) return [self notificationAtIndex:(_cursorIndex - 1)];
    return nil;
}

- (PatientNotification *)notificationAtIndex:(NSUInteger)index {
    NSDictionary *allNotifications = [AppState sharedAppState].userModel.notificationsModel.allNotifications;

    if ([allNotifications count] == 0) {
        TRACE(@"*** notification at index [%lu] invoked whene there are NO notification !", (unsigned long) index);
        return nil;
    }

    if (index >= _sortedKeys.count) {
        TRACE(@"*** cursorIndex not in sync with notifications model!");
        return nil;
    }

    NSString            *key    = _sortedKeys[index];
    PatientNotification *_notif = allNotifications[key];
    if (_notif) {
        return _notif;
    } else {
        MPLOGERROR(@"*** notification at index [%lu] key[%@] for a notification not present in  notifications model!", (unsigned long) index, key);
        return nil;
    }

}

- (void)resetPatientSelector {
    [_patientSelector removeAllObjects];
    IBUser *_user = [AppState sharedAppState].userModel.user;
    switch (_filterType) {
        case NotificationFilterTypePractitioner:
            for (Patient *patient in [_user.patients allValues]) {
                [_patientSelector addObject:patient.guid];
            }
            break;
        case NotificationFilterTypeAll:if (_user.patient) [_patientSelector addObject:_user.patient.guid];
            for (Patient *patient in [_user.patients allValues]) {
                [_patientSelector addObject:patient.guid];
            }
            for (Patient *patient in [_user.proxies allValues]) {
                [_patientSelector addObject:patient.guid];
            }
            break;
        case NotificationFilterTypePatient:if (_user.patient) [_patientSelector addObject:_user.patient.guid];
            for (Patient *patient in [_user.patients allValues]) {
                [_patientSelector addObject:patient.guid];
            }
            for (Patient *patient in [_user.proxies allValues]) {
                [_patientSelector addObject:patient.guid];
            }
            break;
        case NotificationFilterTypeMessage:if (_user.patient) [_patientSelector addObject:_user.patient.guid];
            for (Patient *patient in [_user.proxies allValues]) {
                [_patientSelector addObject:patient.guid];
            }
            break;
        default:break;
    }
}

#pragma mark - some helpers for messages

- (IBMessageContent *)messageAtCursor:(PatientNotification *)cursor {
    if (!cursor) return nil;
    if (!self->_showMessageNotifications) return nil;
    PatientNotification *strawman = [_appState.userModel.notificationsModel allNotifications][cursor.seq];
    if (!strawman) {
        MPLOGERROR(@"*** cursor is not in allNotifications");
    }
    if (!strawman.message) return nil;
    return strawman.message;
}


#pragma mark - persistence

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    NotificationsModelFilter *pa = [[self alloc] init];
    pa->_showInfoNotifications           = WantBoolFromDic(dic, @"showInfoNotifications");
    pa->_showAlertNotifications          = WantBoolFromDic(dic, @"showAlertNotifications");
    pa->_showPatientNotifications        = WantBoolFromDic(dic, @"showPatientNotifications");
    pa->_showSponsorNotifications        = WantBoolFromDic(dic, @"showSponsorNotifications");
    pa->_showPractitionerNotifications   = WantBoolFromDic(dic, @"showPractitionerNotifications");
    pa->_showMessageNotifications        = WantBoolFromDic(dic, @"showMessageNotifications");
    pa->_showPrivateMessageNotifications = WantBoolFromDic(dic, @"showPrivateMessageNotifications");
    pa->_showAppointmentNotifications    = WantBoolFromDic(dic, @"showAppointmentNotifications");
    pa->_showUnreadOnly                  = WantBoolFromDic(dic, @"showUnreadOnly");
    pa->_notificationsPerPage            = WantIntegerFromDic(dic, @"notificationsPerPage");
    pa->_filterType                      = (NotificationFilterType) WantIntegerFromDic(dic, @"filterType");
    return pa;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutBoolInDic(self.showInfoNotifications, dic, @"showInfoNotifications");
    PutBoolInDic(self.showAlertNotifications, dic, @"showAlertNotifications");
    PutBoolInDic(self.showPatientNotifications, dic, @"showPatientNotifications");
    PutBoolInDic(self.showSponsorNotifications, dic, @"showSponsorNotifications");
    PutBoolInDic(self.showPractitionerNotifications, dic, @"showPractitionerNotifications");
    PutBoolInDic(self.showMessageNotifications, dic, @"showMessageNotifications");
    PutBoolInDic(self.showPrivateMessageNotifications, dic, @"showPrivateMessageNotifications");
    PutBoolInDic(self.showAppointmentNotifications, dic, @"showAppointmentNotifications");
    PutBoolInDic(self.showUnreadOnly, dic, @"showUnreadOnly");
    PutIntegerInDic(self.notificationsPerPage, dic, @"notificationsPerPage");
    PutIntegerInDic(self.filterType, dic, @"filterType");
    return dic;
}

- (NSString *)asJSON {
    return [[self asDictionary] asJSON];
}

- (NSData *)asJSONdata {
    return [[self asDictionary] asJSONdata];
}

+ (instancetype)objectWithJSONdata:(NSData *)jsonData {
    NSDictionary *dic = [NSDictionary dictionaryWithJSONdata:jsonData];
    return [self objectWithContentsOfDictionary:dic];
}

+ (instancetype)objectWithJSON:(NSString *)jsonString {
    NSDictionary *dic = [NSDictionary dictionaryWithJSON:jsonString];
    return [self objectWithContentsOfDictionary:dic];
}

@end