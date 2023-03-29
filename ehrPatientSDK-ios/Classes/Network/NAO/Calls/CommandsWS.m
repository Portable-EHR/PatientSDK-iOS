//
// Created by Yves Le Borgne on 2022-12-28.
//

#import "CommandsWS.h"
#import "EHRRequests.h"
#import "SecureCredentials.h"
#import "WebServices.h"
#import "EHRState.h"
#import "PehrSDKConfig.h"

@implementation CommandsWS

TRACE_OFF

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        MPLOG(@"*** super returns nil!");
    }
    return self;
}

- (EHRCall *)getAppInfoCallWithSuccessBlock:(SenderBlock)success onError:(SenderBlock)error __attribute__((unused)) {

    EHRServerRequest *request = [EHRRequests appInfoRequest];
    EHRCall          *call    = [EHRCall callWithRequest:request onSuccess:success onError:error];

    return call;
}

- (EHRCall *)getPingServerCallWithSuccessBlock:(SenderBlock)success onError:(SenderBlock)error __attribute__((unused)) {

    EHRServerRequest *request = [EHRRequests pingRequest];
    EHRCall          *call    = [EHRCall callWithRequest:request onSuccess:success onError:error];

    return call;
}

- (EHRCall *)getGetUserInfoCall:(SenderBlock)success
                        onError:(SenderBlock)error
__attribute__((unused)) {

    EHRServerRequest *request = [EHRRequests userInfoRequestWith:[@{@"action": @"get"} mutableCopy]];
    EHRCall          *call    = [EHRCall callWithRequest:request onSuccess:success onError:error];

    return call;

}

//region WF notation

-(void)getAppInfo:(VoidBlock)successBlock onError:(VoidBlock)errorBlock {

    SenderBlock callSuccess = ^(EHRCall *theCall) {
        // todo : replace this with a SDKDelegate call
        IBAppInfo *appInfo = [IBAppInfo objectWithContentsOfDictionary:theCall.serverResponse.responseContent[@"appInfo"]];
        PehrSDKConfig.shared.state.app=appInfo;
        successBlock();
    };
    SenderBlock callError   = ^(EHRCall *theCall) {
        MPLOGERROR(@"getAppInfo : FAILED.");
        errorBlock();
    };

    EHRCall *appInfo = [self getAppInfoCallWithSuccessBlock:callSuccess onError:callError];
    [appInfo start];

}

- (void)getUserInfo:(VoidBlock)successBlock onError:(VoidBlock)errorBlock {
    SenderBlock callSuccess = ^(EHRCall *theCall) {
        id val = theCall.serverResponse.responseContent[@"services"];
        if (val) {
            [[AppState sharedAppState].servicesModel populateWithServices:[val allValues]];
        }

        val = theCall.serverResponse.responseContent[@"user"];
        if (val) {
            IBUser *new = [IBUser objectWithContentsOfDictionary:val];
            [[AppState sharedAppState].userModel updateUserInfo:new];
        }

        successBlock();
    };
    SenderBlock callError   = ^(EHRCall *theCall) {
        MPLOGERROR(@"getUserInfo failed.");
        errorBlock();
    };

    EHRCall *theCall = [self getGetUserInfoCall:callSuccess onError:callError];
    [theCall start];
}

- (void)pullUserData:(VoidBlock)successBlock onError:(VoidBlock)errorBlock {

    VoidBlock after = ^() {

    };

    VoidBlock notificationsSuccessBlock = ^() {
        MPLOG(@"Notifications pulled from forever : SUCCESS");
        after();
    };
    VoidBlock notificationsErrorBlock   = ^() {
        MPLOGERROR(@"Notifications pulled from forever : FAILED");
        after();
    };

    VoidBlock userInfoSuccess = ^() {
        // todo : is this really needed ?
        MPLOG(@"UserInfo pulled from forever : SUCCESS");
        [AppState sharedAppState].deviceInfo            = [IBDeviceInfo initFromDevice];
        [AppState sharedAppState].deviceInfo.deviceGuid = [SecureCredentials sharedCredentials].current.deviceGuid;

        after();
        [PehrSDKConfig.shared.ws.notifications pullForever:notificationsSuccessBlock onError:notificationsErrorBlock];
    };

    VoidBlock userInfoError = ^() {
        MPLOGERROR(@"UserInfo pulled from forever : SUCCESS");
        after();
    };
    [PehrSDKConfig.shared.ws.commands getUserInfo:userInfoSuccess onError:userInfoError];

    VoidBlock appInfoSuccess = ^(){
        [PehrSDKConfig.shared.state.delegate onAppInfoUpdate];
    };
    VoidBlock appInfoError = ^(){};
    [self getAppInfo:appInfoSuccess onError:appInfoError];
}


- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end