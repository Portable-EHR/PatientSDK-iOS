//
// Created by Yves Le Borgne on 2015-10-02.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "AppState.h"
#import "GEFileUtil.h"
#import "IBUser.h"
#import "EHRApiServer.h"
#import "UserModel.h"
#import "NotificationsModel.h"
#import "EHRReachability.h"
#import "IBDeviceInfo.h"
#import "UserDeviceSettings.h"
#import "AuthSequencer.h"
#import "NotificationsModelFilter.h"
#import "SecureCredentials.h"
#import "UserCredentials.h"
#import "ServicesModel.h"
#import "IBAppInfo.h"
#import "IBUserEula.h"
#import "EulaModel.h"
#import "IBEula.h"
#import "EHRServerResponse.h"
#import "EHRCall.h"
#import "EHRServerRequest.h"
#import "EHRRequestStatus.h"
#import "Version.h"
#import "AppSignature.h"
#import "EHRState.h"
#include "Models.h"
#import "PehrSDKConfig.h"

@implementation AppState

TRACE_OFF

@synthesize patientModel = _patientModel;
@synthesize eulaModel = _eulaModel;
@synthesize patient = _patient;
@synthesize server = _server;
@synthesize isPrivacyCompromised = _isPrivacyCompromised;
@synthesize servicesModel = _servicesModel;
@synthesize isForegroundRefreshActivated = _isForegroundRefreshActivated;
@synthesize isInBackground = _isInBackground;
@synthesize appBadgeNumber = _appBadgeNumber;
@synthesize appBadgeNumberAtStart = _appBadgeNumberAtStart;

//@synthesize deviceLanguage = _deviceLanguage;

@dynamic rootViewController;
@dynamic isAppUsable;
@dynamic isServerReachable;
@dynamic user;
@dynamic userModel;
@dynamic maximumNumberOfDevices;

// some statics


static NSString   *_appStateFile;
static GEFileUtil *_fileUtils;
static float      _foregroundUpdateIntervalInSeconds __unused;
static float      _backgroundUpdateIntervalInSeconds __unused;
static AppState   *_sharedInstance;

+ (void)initialize {

    _fileUtils                         = [GEFileUtil sharedFileUtil];
    _appStateFile                      = [_fileUtils getAppStateFQN];
    _foregroundUpdateIntervalInSeconds = kNetworkForegroundRefreshInSecs;
    _backgroundUpdateIntervalInSeconds = kNetworkBackgroundRefreshInSecs;

}

- (id)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        _timeOfLastSync = [NSDate dateWithTimeIntervalSince1970:0];
//        _deviceLanguage = [[[[[NSBundle mainBundle] localizations] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0];
        self.deviceLanguage = [[NSLocale preferredLanguages][0] componentsSeparatedByString:@"-"][0];
//        _deviceLanguage = @"en";
        _server               = [[EHRApiServer alloc] init];
        _isServerReachable    = NO;
        _authSequencer        = [[AuthSequencer alloc] init];
        _isPrivacyCompromised = YES;
        _isInBackground       = NO;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processNotificationsModelUpdate:)
                                                     name:kNotificationsModelRefreshNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processAuthenticationFailure:)
                                                     name:kAuthenticationFailure
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processServerMaintenance:)
                                                     name:kServerMaintenance
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processAppUpdate:)
                                                     name:kAppMustUpdate
                                                   object:nil];
    } else {
        MPLOGERROR(@"*** super returned nil!");
    }
    return self;
}

+ (id)sharedAppState {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        @try {
            _sharedInstance = [[self alloc] init];
        } @catch (NSException *ex) {
            MPLOGERROR(@"Exeeption at %@", ex.callStackReturnAddresses);
        }
    });
    return _sharedInstance;
}

#pragma mark - some getters, mostly debug

- (void)isDoingOneRefresh:(BOOL)isit {
    _isDoingOneRefresh = isit;
//    TRACE(@"isDoingOneRefresh now %@", isit ? @"true" : @"false");
};

- (BOOL)isDoingOneRefresh {
    return _isDoingOneRefresh;
}

#pragma mark - initialized at startup

- (void)initializeAtStartup:(VoidBlock)onSuccess error:(VoidBlock)onError {

    VoidBlock onInitSuccess = ^{
        EHRReachability *reach = [EHRReachability reachabilityWithHostName:[SecureCredentials sharedCredentials].current.server.serverDNSname];
        TRACE(@"Testing reachability of [%@]", [SecureCredentials sharedCredentials].current.server.serverDNSname);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        NetworkStatus reachabilitytoHost = [reach currentReachabilityStatus];
        if (reachabilitytoHost != NotReachable) {
            self->_isServerReachable = YES;
            if ([self isAppUsable]) [self activateForegroundRefresh];
        }
        [reach startNotifier];
        onSuccess();
    };

    [self initializeFromSecureCredentialsUser:onInitSuccess error:onError];
    return;

}

- (void)fetchAllNotifications:(VoidBlock)onSuccess andError:(VoidBlock)onError {

    TRACE_KILLROY

    NotificationsModel *nm = PehrSDKConfig.shared.models.notifications;

    [nm readFromServerWithSuccess:^() {
                onSuccess();
            }
                         andError:^{
                             onError();
                         }];
}

- (void)fetchPriorUserInfo:(VoidBlock)onSuccess error:(VoidBlock)onError {

    TRACE_KILLROY

    // prior user means from SecureCredentials, eg the AppState
    NSString *apikey     = [SecureCredentials sharedCredentials].current.userApiKey;
    NSString *deviceGuid = [SecureCredentials sharedCredentials].current.deviceGuid;

    EHRServerRequest *userInfoRequest = [[EHRServerRequest alloc] init];
    userInfoRequest.server     = [SecureCredentials sharedCredentials].current.server;
    userInfoRequest.deviceGuid = deviceGuid;
    userInfoRequest.route      = @"/app/commands";
    userInfoRequest.command    = @"userinfo";
    userInfoRequest.apiKey     = apikey; // prefer this to seemingly broken secure credentials
    userInfoRequest.parameters = [@{@"action": @"get"} mutableCopy];

    EHRCall *userInfoCall;
    userInfoCall = [EHRCall callWithRequest:userInfoRequest
                                  onSuccess:^(EHRCall *call) {
//                                      TRACE(@"Received user info \n%@", call.serverResponse.responseContent);
                                      IBDeviceInfo *di = [IBDeviceInfo initFromDevice];

                                      [AppState sharedAppState].deviceInfo            = di;
                                      [AppState sharedAppState].deviceInfo.deviceGuid = deviceGuid;
                                      id val = call.serverResponse.responseContent[@"services"];
                                      if (val) {
//                                          TRACE(@"Received services \n%@", val);
                                          ServicesModel *newSM = [ServicesModel objectWithContentsOfDictionary:call.serverResponse.responseContent];
                                          self->_servicesModel = newSM;
                                      }

                                      val = call.serverResponse.responseContent[@"user"];
                                      if (val) {
                                          IBUser *new = [IBUser objectWithContentsOfDictionary:val];
                                          self.userModel = [UserModel userModelFor:new];
                                      }

                                      onSuccess();

                                  }
                                    onError:^(EHRCall *call) {
                                        MPLOGERROR(@"error when refrewhing user info !");
                                        MPLOGERROR(@"Got requestStatus [%@]", call.serverResponse.requestStatus.asDictionary);
                                        onError();
                                    }
    ];

    userInfoCall.timeOut         = 15.0f;
    userInfoCall.maximumAttempts = 1;

    [userInfoCall start];
}

- (void)getAppInfo:(VoidBlock)onSuccess error:(VoidBlock)onError {

    EHRCall          *appInfoCall;
    EHRServerRequest *appInfoRequest = [[EHRServerRequest alloc] init];
    appInfoRequest.server     = [EHRApiServer defaultApiServer];
    appInfoRequest.route      = @"/app/commands";
    appInfoRequest.command    = @"appinfo";
    appInfoRequest.apiKey     = [UserModel guest].user.apiKey;
    appInfoRequest.parameters = [NSMutableDictionary dictionary];

    appInfoCall = [EHRCall callWithRequest:appInfoRequest
                                 onSuccess:^(EHRCall *call) {
                                     EHRServerResponse *resp = call.serverResponse;
                                     if ([[resp requestStatus].status isEqualToString:@"OK"]) {
                                         NSDictionary *appInfoDic = resp.responseContent[@"appInfo"];
                                         IBAppInfo    *appInfo    = [IBAppInfo objectWithContentsOfDictionary:appInfoDic];
                                         self->_appInfo   = appInfo;
//                                         [self.appInfo refreshFrom:appInfo];
                                         self->_eulaModel = [[EulaModel alloc] init];
                                         onSuccess();
                                     } else {
//                                         TRACE(@"Got response with requestStatus %@", [resp.requestStatus asDictionary]);
                                         MPLOGERROR(@"Will invoke onError after app info call failed.");
                                         onError();
                                     }
                                 }
                                   onError:^(EHRCall *call) {
                                       EHRServerResponse *resp = call.serverResponse;
                                       if ([[resp requestStatus].status isEqualToString:@"APP_VERSION"]) {
                                           MPLOG(@"Got an APP_VERSION issue, will let StartViewController deal with it");
                                           onError();
                                       } else {
                                           TRACE(@"*** Error : got response with requestStatus %@", [resp.requestStatus asDictionary]);
                                           MPLOGERROR(@"Will invoke onError after app info call failed.");
                                           onError();
                                       }
                                   }
    ];

    appInfoCall.timeOut = 15.0f;
    appInfoCall.verbose = NO;
    [appInfoCall start];
}

- (void)initializeFromSecureCredentialsUser:(VoidBlock)onSuccess error:(VoidBlock)onError {

    TRACE_KILLROY

    VoidBlock fetchNotificationsSuccess = ^{

        SecureCredentials *creds = [SecureCredentials sharedCredentials];
        if (self->_appInfo.eula && ![self->_appInfo.eula.version.description isEqualToString:[SecureCredentials sharedCredentials].current.appEula.eulaVersion.description]) {
            // eula update from server !
            creds.current.appEula.eulaVersion   = self->_appInfo.eula.version;
            creds.current.appEula.eulaGuid      = self->_appInfo.eula.guid;
            creds.current.appEula.dateSeen      = nil;
            creds.current.appEula.dateConsented = nil;
            [creds persist];
            [self signPreferences];
            onSuccess();
        } else {
            MPLOGERROR(@"Unable to persist AppState on device");
            onError();
        }
    };

    VoidBlock fetchUserSuccess = ^{
        if (![SecureCredentials sharedCredentials].current.isGuest) {
            [self fetchAllNotifications:fetchNotificationsSuccess
                               andError:^{
                                   MPLOGERROR(@"*** Notifications fetch failed, passing it on to StartViewController");
                                   onError();
                               }];
        } else {
            MPLOG(@"Secure credentials user is guest, skipping notifications fetch !");
            fetchNotificationsSuccess();
        }
    };

    VoidBlock appInfoSuccess = ^{
        [self fetchPriorUserInfo:fetchUserSuccess
                           error:^{
                               MPLOGERROR(@"*** Prior user fetch failed, passing it on to StartViewController");
                               onError();
                           }];
    };
    [self getAppInfo:appInfoSuccess error:^{
        MPLOGERROR(@"*** AppInfo fetch failed, passing it on to StartViewController");
        onError();
    }];

}

- (BOOL)isServerReachable __unused {
    return _isServerReachable;
}

- (void)reachabilityChanged:(EHRReachability *)reachability {

    TRACE(@"Reachability changed patientNotification.");

    if (reachability.currentReachabilityStatus == NotReachable) {
        TRACE(@"*** Unreachable !");
        [self deactivateForegroundRefresh];
    } else {
        TRACE(@"*** Yay ! Reachable !");
        if ([self isAppUsable]) [self activateForegroundRefresh];
    }

}

#pragma mark - getters

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"

- (NSInteger)maximumNumberOfDevices {
    return 3;
}

#pragma clang diagnostic pop

- (IBUserEula *)getAppUserEula {
    IBUserEula *userEula = [[IBUserEula alloc] init];

    SecureCredentials *creds = [SecureCredentials sharedCredentials];
    if (self.appInfo.eula) {
        userEula = creds.current.appEula;
        userEula.eula = self.appInfo.eula;
    }

    return userEula;

}

- (AuthSequencer *)authSequencer __unused {
    return _authSequencer;
}

- (NSString *)deviceLanguage {
    return _deviceLanguage;
}

- (IBUser *)user {
    return _userModel.user;
}

- (UserModel *)userModel {
    return _userModel;
}

- (void)setUserModel:(UserModel *)userModel {

    [_userModel pause];
    _userModel = nil;
    _userModel = userModel;

    [PehrSDKConfig.shared.models.notifications refreshFilters];

}

#pragma mark - setters

- (void)setDeviceLanguage:(NSString *)deviceLanguage {
    if ([deviceLanguage isEqualToString:@"en"] || [deviceLanguage isEqualToString:@"fr"]) {
        TRACE(@"Device language is [%@]", deviceLanguage);
    } else {
        MPLOGERROR(@"Unsupported device language, defaulting to english.");
        deviceLanguage = @"en";
    }
    _deviceLanguage = nil;
    _deviceLanguage = deviceLanguage;
}

//region NSPreferences

- (void)signPreferences {

    AppSignature *as = [[AppSignature alloc] init];
    as.installedOn = [NSDate date];
    as.buildNumber = (NSInteger)  [[NSBundle mainBundle] infoDictionary][(NSString *) kCFBundleVersionKey]; // todo : evaluate impace of switching to string (on running patient apps)
    NSDictionary *asAsDic = [as asDictionary];
    [[NSUserDefaults standardUserDefaults] setObject:asAsDic forKey:@"signature"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)unsignPreferences __unused {

    // utility method, used in developement only (sometimes) to simulate a fresh install

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"signature"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (BOOL)isPreferencesSigned {
    NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"signature"];
    return nil != dictionary;
}

//endregion

#pragma mark - getters

- (UIViewController *)rootViewController {
    return [UIApplication sharedApplication].windows[0].rootViewController;
}

- (BOOL)isAppUsable {
//    if (![self existsOnDevice]) return NO;
    if (!self.userModel) return NO;
    if (!self.userModel.user) return NO;
    if (self.userModel.isGuest) return NO;

    // user is not a guest, we have a configured device

    return [self isUserConfirmed];

}

- (BOOL)isUserConfirmed {
    return [self.userModel.user.status isEqualToString:@"active"];
}

#pragma mark - listen to devics shit and stuff

- (void)processNotificationsModelUpdate:(NSNotification *)notification {
    TRACE(@"[%ld]/[%lX] Got patientNotification [%@]", (long) _instanceNumber, (long) self, notification.name);
//    NSInteger unread = _sharedInstance.userModel.notificationsModel.allNotificationFilter.numberOfUnseen;
//    [self setApplicationIconBadgeNumber:unread];

}

- (void)processAuthenticationFailure:(NSNotification *)notification {
    TRACE(@"[%ld]/[%lX] Got patientNotification [%@]", (long) _instanceNumber, (long) self, notification.name);
}

- (void)processServerMaintenance:(NSNotification *)notification {
    TRACE(@"[%ld]/[%lX] Got patientNotification [%@]", (long) _instanceNumber, (long) self, notification.name);
}

- (void)processAppUpdate:(NSNotification *)notification {
    TRACE(@"[%ld]/[%lX] Got patientNotification [%@]", (long) _instanceNumber, (long) self, notification.name);
}

#pragma mark - EHRPersistableP

+ (id)objectWithContentsOfDictionary:(NSDictionary *)theDictionary {
    AppState *pn = [[AppState alloc] init];
    [pn loadWithContentsOfDictionary:theDictionary];
    return pn;
}

- (void)loadWithContentsOfDictionary:(NSDictionary *)theDictionary {

    id val;

    self.timeOfLastSync = WantDateFromDic(theDictionary, @"timeOfLastSync");

    if ((val = theDictionary[@"deviceInfo"])) self.deviceInfo = [IBDeviceInfo objectWithContentsOfDictionary:val];

    if (!self.deviceInfo) { // todo : is this really correct, should we not reload from server ???
        TRACE(@"Generating scratch deviceInfo, was not present in persisted appState.");
        self.deviceInfo = [IBDeviceInfo initFromDevice];
    }

    if ((val = theDictionary[@"appInfo"])) self.appInfo = [IBAppInfo objectWithContentsOfDictionary:val];
    if (!self.appInfo) self.appInfo = [[IBAppInfo alloc] init];

//    NSString *lang = [[WantStringFromDic(theDictionary, @"language") componentsSeparatedByString:@"-"] objectAtIndex:0];
//    if (lang) self.deviceLanguage = lang;

}

- (NSDictionary *)asDictionary {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    PutStringInDic(self.deviceLanguage, dic, @"language");
    PutDateInDic(self.timeOfLastSync, dic, @"timeOfLastSync");
//    if (self.server) [dic setObject:[self.server asDictionary] forKey:@"server"];
    dic[@"deviceInfo"] = [_deviceInfo asDictionary];
    PutPersistableInDic(self.appInfo, dic, @"appInfo");
    return dic;
}

#pragma mark - backbround updates stuff (the app MUST be usable for this)

- (void)activateBackgroundRefresh __unused {
    [self deactivateForegroundRefresh];
    if (_isBackgroundRefreshActivated) return;
    if ([_userModel isGuest]) return;
    [self createAutoRefreshTimer:_backgroundUpdateIntervalInSeconds];
    _isBackgroundRefreshActivated = YES;
}

- (void)deactivateBackgroundRefresh __unused {
    if (!_isBackgroundRefreshActivated) return;
    _isBackgroundRefreshActivated = NO;
    [self nukeAutoRefreshTimer];
}

- (void)activateForegroundRefresh {
    [self deactivateBackgroundRefresh];
    if ([_userModel isGuest]) return;

    [self createAutoRefreshTimer:_foregroundUpdateIntervalInSeconds];

    _isForegroundRefreshActivated = YES;
}

- (void)deactivateForegroundRefresh {
    _isForegroundRefreshActivated = NO;
    [self nukeAutoRefreshTimer];
}

- (void)enterBackground {
    TRACE_KILLROY
    @try {
        _isInBackground = YES;
        if (!self.isAppUsable) {
            MPLOGERROR(@"Entering background, app not usable, ignored.");
            [self nukeAutoRefreshTimer];
            return;
        }

        self.isPrivacyCompromised = YES;
        [self activateBackgroundRefresh];
    } @catch (NSException *e) {
        MPLOGERROR(@"*** an exception [%@] occured while enterinb background.\n%@\n\n%@",
                e.debugDescription,
                e.callStackSymbols,
                e.callStackReturnAddresses);
        exit(0);
    }

}

- (void)resumeForeground {
    TRACE_KILLROY
    _isInBackground = NO;
    if (!self.isLaunching) {
        // note to self : this is to counteract the unexplainable
        // account deactivation (in our state, never in credentials)
        // after a long background stint
        [[SecureCredentials sharedCredentials] reload];
    }
    if (!self.isAppUsable) {
        [self nukeAutoRefreshTimer];
        return;
    }
    [self activateForegroundRefresh];

}

- (void)refreshWithCompletion:(VoidBlock)block {
    _refreshCompletionBlock = block;
    [self doOneRefresh];
}

- (void)resumePolling {

    [self stopPolling];

    if (_isInBackground) {
        [self activateBackgroundRefresh];
    } else {
        [self activateForegroundRefresh];
    }

}

- (void)stopPolling {
    [self deactivateForegroundRefresh];
    [self deactivateBackgroundRefresh];
}

- (void)doOneRefresh {

    VoidBlock _after = ^{
        if (self->_refreshCompletionBlock) {
            self->_refreshCompletionBlock();
            self->_refreshCompletionBlock = nil;
        }
        [self isDoingOneRefresh:NO];
    };

    if ([self isInBackground]) {
        MPLOG(@"*** Not refreshing :  app is in background. ");
        _after();
        return;
    }

    if (_isDoingOneRefresh) {
        MPLOG(@"*** Not refreshing : refresh currently in progress.");
        _after();
        return;
    }

    [self isDoingOneRefresh:YES];

    VoidBlock _afterServices = ^{

        if ([AppState sharedAppState].isInBackground) {
            MPLOG(@"Not refreshing notifications :  not while app is in background.");
            _after();
            return;

        }

        [self->_notificationsModel refreshFromServerWithSuccess:^() {
                    TRACE(@"Synchronized notifications model.");
                    _after();
                }
                                                       andError:^() {
                                                           MPLOGERROR(@"*** Failed to synchronize notifications model.");
                                                           _after();
                                                       }
        ];
    };

    VoidBlock _afterSendingQueuedMessages = ^{
        if ([AppState sharedAppState].isInBackground) {
            MPLOG(@"refresh services :  not while app is in background. No.");
            _after();
            return;

        }

        [self->_servicesModel refreshFromServerWithSuccess:^() {
                    TRACE(@"Synchronized serviceModel.");
                    _afterServices();
                }
                                                  andError:^() {
                                                      MPLOGERROR(@"*** Failed to synchronize serviceModel.");
                                                      _afterServices();
                                                  }
        ];
    };

    VoidBlock _afterSendingQueuedNotifications = ^{

        // that is all ok, even when in background (id the app was backgrounded
        // during this method !

        if ([self->_notificationsModel hasQueuedMessageChanges]) {
            [self->_notificationsModel sendStackedMessageChangesOnSuccess:^() {
                TRACE(@"Sent stacked message changes, with success.");
                _afterSendingQueuedMessages();
            }                                                     onError:^() {
                MPLOGERROR(@"*** Failed to send stacked messages changes, reloading");
                _afterSendingQueuedMessages();
            }];
        } else {
            _afterSendingQueuedMessages();
        }
    };

    if ([_notificationsModel hasQueuedNotificationChanges]) {
        [_notificationsModel sendStackedNotificationChangesOnSuccess:^() {
            TRACE(@"Sent stacked patientNotification changes, with success.");
            _afterSendingQueuedNotifications();
        }                                                    onError:^() {
            MPLOGERROR(@"*** Failed to send stacked patientNotification changes, reloading");
            [self->_notificationsModel reloadFromDevice];
            _afterSendingQueuedNotifications();
        }];
    } else {
        _afterSendingQueuedNotifications();
    }
}

- (void)nukeAutoRefreshTimer {
    if (_autoRefreshTimer) {
        [_autoRefreshTimer invalidate];
        _autoRefreshTimer = nil;
    }
    _isForegroundRefreshActivated = NO;
}

- (void)createAutoRefreshTimer:(float)intervalInSeconds {
    [self nukeAutoRefreshTimer];
    _autoRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:intervalInSeconds // _foregroundUpdateIntervalInSeconds
                                                         target:self
                                                       selector:@selector(doOneRefresh)
                                                       userInfo:nil
                                                        repeats:YES
    ];
}

#pragma mark - initialization stuff

- (void)setNewUser:(IBUser *)newUser onSuccess:(VoidBlock)successBlock onError:(VoidBlock)errorBlock {
    // todo : this is a job for SDK, not AppState
    // todo : used in device activation with QR code (known bug there !)

    TRACE_KILLROY
    MPLOG(@"Invoked with user %@", newUser.guid);
    if (!successBlock || !errorBlock) {
        MPLOGERROR(@"*** Attempt to set user with no success or error block.");
        return;
    }
    _sharedInstance->_setUserSuccess = [successBlock copy];
    _sharedInstance->_setUserError   = [errorBlock copy];

    [self deactivateForegroundRefresh];

    if (nil == newUser) {
        MPLOGERROR(@"*** invokec with null user");
        [self resetDeviceWithSuccess:^(AppState *appState) {
            _sharedInstance->_setUserSuccess();
            _sharedInstance->_setUserSuccess = nil;
            _sharedInstance->_setUserError   = nil;

        }                   andError:^(AppState *appState) {
            _sharedInstance->_setUserSuccess();
            _sharedInstance->_setUserSuccess = nil;
            _sharedInstance->_setUserError   = nil;
        }];
    } else {

        TRACE(@"Entering _initializeUserSuccess block");

        UserModel *model = [UserModel userModelFor:newUser];
        [_sharedInstance setUserModel:model];
        [_sharedInstance.notificationsModel setPatientNotificationsFilter:_sharedInstance.userModel.deviceSettings.patientNotificationsFilter];
        [_sharedInstance.notificationsModel setAlertNotificationsFilter:_sharedInstance.userModel.deviceSettings.alertNotificationsFilter];
        [_sharedInstance.notificationsModel setInfoNotificationsFilter:_sharedInstance.userModel.deviceSettings.infoNotificationsFilter];
        [_sharedInstance.notificationsModel setPrivateMessageNotificationsFilter:_sharedInstance.userModel.deviceSettings.telexNotificationsFilter];

        // invoke succes block

        _sharedInstance->_setUserSuccess();
        _sharedInstance->_setUserSuccess = nil;
        _sharedInstance->_setUserError   = nil;

    }
}


- (void)resetDeviceWithSuccess:(SenderBlock)onSuccess
                      andError:
                              (SenderBlock)onError {

    [self resetApplicationBadgeNumber];
    _resetDeviceSuccess = [onSuccess copy];
    _resetDeviceError   = [onError copy];
    [self deactivateForegroundRefresh];
    if (![self doReset]) {
        if (_resetDeviceError) {
            _resetDeviceError(self);
            _resetDeviceError = nil;
        }
        _resetDeviceSuccess = nil;
    } else {
        if (_resetDeviceSuccess) {
            _resetDeviceSuccess(self);
            _resetDeviceSuccess = nil;
        }
        _resetDeviceError = nil;
    }

}

- (BOOL)resetDevice {
    [self resetApplicationBadgeNumber];
    [[SecureCredentials sharedCredentials] setupGuest];
    [[SecureCredentials sharedCredentials] setupServer];
    [SecureCredentials sharedCredentials].current.dismissedResearchConsent = false;
    [[SecureCredentials sharedCredentials] persist];
    [self deactivateForegroundRefresh];
    return [self doReset];
}

#pragma mark - Persistence stuff

- (BOOL)doReset {

    // cleanup entirely the device

    _deviceInfo = nil;
    [self setUserModel:[UserModel userModelFor:[IBUser guest]]];
    [self isDoingOneRefresh:NO];
    [self resetApplicationBadgeNumber];

    self->_patient       = nil;
    self->_patientModel  = nil;
    self.deviceInfo      = [IBDeviceInfo initFromDevice];
    self.deviceLanguage  = [[NSLocale preferredLanguages][0] componentsSeparatedByString:@"-"][0];
    self.server          = [EHRApiServer serverForHost:kHostName];
    self.appInfo         = [[IBAppInfo alloc] init];
    self->_servicesModel = [[ServicesModel alloc] init];
    self->_eulaModel     = [[EulaModel alloc] init];
    return YES;
}

- (void)setApplicationIconBadgeNumber:(NSInteger)number {
    TRACE_KILLROY
    _appBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber];

    if (number > _appBadgeNumber) {
        if ([self isAppUsable] && ![self isLaunching]) {
            NSURL         *fileURL = [NSURL URLWithString:@"/System/Library/Audio/UISounds/new-mail.caf"]; // see list below
            SystemSoundID soundID;
            AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef) fileURL, &soundID);
            AudioServicesPlaySystemSound(soundID);
        }
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:number];

    _appBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber];
}

- (void)resetApplicationBadgeNumber {
    _appBadgeNumberAtStart = 0;
    _appBadgeNumber        = 0;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAuthenticationFailure object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kServerMaintenance object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAppMustUpdate object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationsModelRefreshNotification object:nil];
    _server = nil;
    [_userModel pause];
    _userModel          = nil;
    _patientModel       = nil;
    _patient            = nil;
    _authSequencer      = nil;
    _notificationsModel = nil;
}


//region EHRLibStateDelegate

- (void)onSDKinitialized {
    MPLOG(@"Will initialize self references to SDK entities");
    self.userModel          = PehrSDKConfig.shared.models.userModel;
    self.notificationsModel = PehrSDKConfig.shared.models.notifications;

}

- (void)onDeviceInitialized {
    MPLOG(@"onDeviceInitialized");
    self.deviceInfo     = PehrSDKConfig.shared.state.device;
    self.deviceLanguage = PehrSDKConfig.shared.deviceLanguage;
}

- (void)onAppInfoUpdate {
    MPLOG(@"onAppInfoUpdate");
    self.appInfo     = PehrSDKConfig.shared.state.app;
    self->_eulaModel = [[EulaModel alloc] init];
}

- (void)onUserInfoUpdate {
    MPLOG(@"onUserInfoUpdate");

    [AppState sharedAppState].deviceInfo            = [IBDeviceInfo initFromDevice];
    [AppState sharedAppState].deviceInfo.deviceGuid = [SecureCredentials sharedCredentials].current.deviceGuid;
    self.userModel                                  = PehrSDKConfig.shared.models.userModel;
}

- (void)onNotificationsModelUpdate {
    MPLOG(@"onNotificationsModelUpdate");
}

- (void)onNotificationUpdate:(PatientNotification *)notification {
    MPLOG(@"onNotificationUpdate : %@", notification.description);
}

- (void)onConsentsUpdate {
    MPLOG(@"onConsentsUpdate");
    [self setConsents:PehrSDKConfig.shared.models.consentsModel.allConsents];
}

//endregion

@end
