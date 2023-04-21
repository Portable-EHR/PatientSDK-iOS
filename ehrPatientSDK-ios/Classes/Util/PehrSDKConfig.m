//
//  PehrSDKConfig.m
//  ehrPatientSDK-ios
//
//  Created by Rahul Asthana on 20/09/21.
//

#import <UserNotifications/UserNotifications.h>
#import "PehrSDKConfig.h"
#import "WebServices.h"
#import "Models.h"

@interface PehrSDKConfig () {
    NSInteger _instanceNumber;
}

@end

@implementation PehrSDKConfig

static PehrSDKConfig *_Instance = nil;

+ (void)initialize {
}

@synthesize deviceLanguage = _deviceLanguage;


//region SDK life cycle

- (void)startWithCompletion:(VoidBlock)successBlock
                    onError:(VoidBlock)errorBlock {
    if ([self.state.user isGuest]) {
        NSLog(@"Not starting : user is guest !");
        errorBlock();
    } else if ([SecureCredentials sharedCredentials].current.isGuest) {
        NSLog(@"PehrSDKConfig.shared.start : Secure Credentials are set to guest.  Please register a user first.");
        errorBlock();
    } else {
        NSLog(@"PehrSDKConfig.shared.start : starting ...");
        [self doStartWFwithCompletion:successBlock onError:errorBlock];
    }
}

- (void)stop {
}

- (void)stopWithCompletion:(VoidBlock)successBlock onError:(VoidBlock)errorBlock {
}

- (void)registerUser:(EHRUserRegistrationManifest *)manifest {
}

- (void)deregisterUser {
}

- (void)doStartWFwithCompletion:(VoidBlock)successBlock onError:(VoidBlock)errorBlock {
    // get userinfo
    // get notifications model
}
//

- (void)deregisterUserWithCompletion:(VoidBlock)successBlock onError:(VoidBlock)errorBlock {
}


//endregion

TRACE_OFF

- (id)init {

    self = [super init];
    if (self) {

        GE_ALLOC();
        GE_ALLOC_ECHO();

        // no need to deregister, if this deallocs, the app is dying

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appBecameActive)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];

    } else {
        TRACE(@"*** super returned nil !");
    }
    return self;

}

+ (PehrSDKConfig *)shared {

    static dispatch_once_t once;
    static PehrSDKConfig   *_instance;
    dispatch_once(&once, ^{
        _instance = [[PehrSDKConfig alloc] init];
        _instance-> _ws             = [[WebServices alloc] init];
        _instance->_deviceLanguage = [[NSLocale preferredLanguages][0] componentsSeparatedByString:@"-"][0];
        _instance->_state          = [[EHRState alloc] init];
        _instance->_models         = [[Models alloc] init];

    });
    return _instance;

}

- (WebServices *)ws __attribute__((unused)) {
    return _ws;
}

- (Models *)models __attribute__((unused)) {
    return _models;
}

- (EHRState *)state __attribute__((unused)) {
    return _state;
}

- (IBAppInfo *)appInfo {
    return _appInfo;
}

- (NSString *)getAppGuid {
    return _appGuid;
}

- (NSString *)getAppAlias {
    return _appAlias;
}

- (Version *)getAppVersion {
    return [Version versionWithString:_appVersion];
}

- (NSString *)getAppStackKey {
    return _stackKey;
}

- (NSString *)getLocalIPaddress {
    return _localIPaddress;
}

- delegate:(id <EHRLibStateDelegate>)delegate
   appGuid:(NSString *)appGuid
  appAlias:(NSString *)appAlias
appVersion:(NSString *)appVersion
  stackKey:(NSString *)stackKey
 onSuccess:(SenderBlock)successBlock
   onError:(SenderBlock)errorBlock __unused {

    self->_appGuid        = appGuid;
    self->_appAlias       = appAlias;
    self->_appVersion     = appVersion;
    self->_stackKey       = stackKey;
    self->_localIPaddress = nil;
    self->_appInfo        = nil;

    [GERuntimeConstants initialize];
    [GERuntimeConstants setAppGuid:appGuid];
    [GERuntimeConstants setAppAlias:appAlias];
    [GERuntimeConstants setAppVersion:appVersion];
    [GERuntimeConstants setStackKey:stackKey];

    [self resetDeviceIfNeeded];

    [self getAppInfo:successBlock onError:errorBlock];

    [delegate onSDKinitialized];
    [self echoOnInitialize];

    return self;
}

-     delegate:(id <EHRLibStateDelegate>)delegate
       appGuid:(NSString *)appGuid
      appAlias:(NSString *)appAlias
    appVersion:(NSString *)appVersion
localIPaddress:(NSString *)address
     onSuccess:(SenderBlock)successBlock
       onError:(SenderBlock)errorBlock  __unused {


    self->_appGuid        = appGuid;
    self->_appAlias       = appAlias;
    self->_appVersion     = appVersion;
    self->_stackKey       = @"CA.local";
    self->_localIPaddress = address;
    self->_appInfo        = nil;


    [GERuntimeConstants initialize];
    [GERuntimeConstants setAppGuid:appGuid];
    [GERuntimeConstants setAppAlias:appAlias];
    [GERuntimeConstants setAppVersion:appVersion];
    [GERuntimeConstants setLocalIPaddress:address];
    kHostNames[@"CA.local"] = address;
    kHostName = address;
    [GERuntimeConstants setStackKey:@"CA.local"];
    [[SecureCredentials sharedCredentials] setupServer];
    [[SecureCredentials sharedCredentials] persist];

    [self resetDeviceIfNeeded];

    [self getAppInfo:successBlock onError:errorBlock];

    [delegate onSDKinitialized];

    [self echoOnInitialize];

    return self;
}

/**
*    first thing, check if stack key is same as the one found in SecureCredentials
 *
 *   if different , bring SDK in safe place : guest, no device, desired server stack
 *
 */

-(void) resetDeviceIfNeeded {

    NSString *credsHost = [SecureCredentials sharedCredentials].current.server.host;
    NSString *desiredHost = [EHRApiServer serverForStackKey:_stackKey].host;
    if (![credsHost isEqualToString:desiredHost]){
        MPLOGERROR(@"Hack possible : secure creds point to a different statk.  Reseting to [%@]",_stackKey);
        [self resetToDesirecStackKey];
    }

}

-(void)  resetToDesirecStackKey {
    UserCredentials *userCreds = [[UserCredentials alloc] init];
    userCreds.server     = [EHRApiServer serverForHost:kHostName];
    userCreds.userGuid   = [IBUser guest].guid;
    userCreds.userApiKey = [IBUser guest].apiKey;
    [[SecureCredentials sharedCredentials] setCurrentUserCredentials:userCreds];
    [[SecureCredentials sharedCredentials] persist];
}

- (void)getAppInfo:(SenderBlock)successBlock onError:(SenderBlock)errorBlock {

    SenderBlock aisb = ^(id theCall) {
        EHRCall   *call    = theCall;
        IBAppInfo *appInfo = [IBAppInfo objectWithContentsOfDictionary:call.serverResponse.responseContent[@"appInfo"]];
        [self->_state setApp:appInfo];
        [self->_state.delegate onAppInfoUpdate];
        successBlock(theCall);
    };

    SenderBlock aieb = ^(id theCall) {
        errorBlock(theCall);
    };

    EHRCall *aic = [self.ws.commands getAppInfoCallWithSuccessBlock:aisb onError:aieb];
    [aic startAsGuest];

}
-(void) echoOnInitialize {
    CGSize sz = [UIScreen mainScreen].bounds.size;

    MPLOG(@"Initializing Run time constants %@", NSStringFromBool(YES));
    MPLOG(@"Running iOS version : %@", kSystemVersion);
    MPLOG(@"Running on          : %@", [GEDeviceHardware platformString]);
    MPLOG(@"Screen dimensions   : %@", NSStringFromCGSize(sz));
    MPLOG(@"App alias           : %@", kAppAlias);
    MPLOG(@"App version         : %@", [kAppVersion toString]);
    MPLOG(@"App build number    : %@", [[NSBundle mainBundle] infoDictionary][(NSString *) kCFBundleVersionKey]);
}

-(void) appBecameActive{

    // flush past delivered APNS notifications

    [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications]; // removes notifications that were queued while we were gone
    [_state.delegate onAppBecameActive];

}

-(void) appWillResignActive{

    // flush past delivered APNS notifications

    [_state.delegate onAppBecameActive];

}

@end

