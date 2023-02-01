//
//  PehrSDKConfig.m
//  ehrPatientSDK-ios
//
//  Created by Rahul Asthana on 20/09/21.
//

#import <SecureCredentials.h>
#import <UserNotifications/UserNotifications.h>
#import "EHRPersistableP.h"
#import "WebServices.h"
#import "Models.h"
#import "IBAppInfo.h"
#import "EHRLibState.h"
#import "EHRServerResponse.h"
#import "SecureCredentials.h"
#import "IBUser.h"
#import "UserCredentials.h"


@interface PehrSDKConfig(){
    NSInteger _instanceNumber;
}

@end

@implementation PehrSDKConfig

static PehrSDKConfig *_Instance = nil;

+(void) initialize {

}



//region SDK life cycle

-(void) startWithCompletion : (VoidBlock) successBlock
         onError:(VoidBlock) errorBlock{
    if ([self.state.user isGuest]){
        NSLog(@"Not starting : user is guest !");
        errorBlock();
    } else if ([SecureCredentials sharedCredentials].current.isGuest) {
        NSLog(@"EHRLib.start : Secure Credentials are set to guest.  Please register a user first.");
        errorBlock();
    } else{
        NSLog(@"EHRLib.start : starting ...");
        [self doStartWFwithCompletion:successBlock onError:errorBlock];
    }
}
-(void) stop{}
-(void) stopWithCompletion:(VoidBlock)successBlock onError:(VoidBlock)errorBlock{}
-(void) registerUser:(EHRUserRegistrationManifest *) manifest{}
-(void) deregisterUser{}

-(void) doStartWFwithCompletion:(VoidBlock) successBlock onError:(VoidBlock) errorBlock{
    // get userinfo
    // get notifications model
}
//

-(void) deregisterUserWithCompletion:(VoidBlock)successBlock onError:(VoidBlock)errorBlock{}


//endregion

TRACE_OFF

- (id)init {

    self = [super init];
    if (self) {

        GE_ALLOC();
        _ws             = [[WebServices alloc] init];
//        _models         = [[Models alloc] init];
        _deviceLanguage = [[NSLocale preferredLanguages][0] componentsSeparatedByString:@"-"][0];

    } else {
        TRACE(@"*** super returned nil !");
    }
    return self;

}

+ (PehrSDKConfig *)shared {

    static dispatch_once_t once;
    static PehrSDKConfig   *_Instance;
    dispatch_once(&once, ^{
        _Instance = [[PehrSDKConfig alloc] init];

    });
    return _Instance;

}

- (WebServices *)ws __attribute__((unused)) {
    return _ws;
}

- (Models *)models __attribute__((unused)) {
    return _models;
}

- (EHRLibState *)state __attribute__((unused)) {
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

- (NSString *)getDeviceLanguage {
    return _deviceLanguage;
}

- setup:(NSString *)appGuid appAlias:(NSString *)appAlias appVersion:(NSString *)appVersion stackKey:(NSString *)stackKey onSuccess:(SenderBlock)successBlock onError:(SenderBlock)errorBlock __unused {
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
    [GERuntimeConstants setBuildNumber:10]; // todo : figure out this old dependency (from MaxPower Game Engine)

    [self getAppInfo:successBlock onError:errorBlock];

    return self;
}

- setup:(NSString *)appGuid appAlias:(NSString *)appAlias appVersion:(NSString *)appVersion localIPaddress:(NSString *)address onSuccess:(SenderBlock)successBlock onError:(SenderBlock)errorBlock  __unused {
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

    [GERuntimeConstants setBuildNumber:10]; // todo : figure out this old dependency (from MaxPower Game Engine)
    [self getAppInfo:successBlock onError:errorBlock];

    return self;
}

- (void)getAppInfo:(SenderBlock)successBlock onError:(SenderBlock)errorBlock {



    SenderBlock aisb = ^(id theCall) {
        EHRCall *call = theCall;
        IBAppInfo *appInfo = [IBAppInfo objectWithContentsOfDictionary:call.serverResponse.responseContent[@"appInfo"]];
        [self->_state setApp:appInfo] ;


        successBlock(theCall);
    };

    SenderBlock aieb = ^(id theCall) {
        errorBlock(theCall);
    };

    EHRCall *aic = [self.ws.commands getAppInfoCallWithSuccessBlock:aisb onError:aieb];
    [aic startAsGuest];

}

@end

