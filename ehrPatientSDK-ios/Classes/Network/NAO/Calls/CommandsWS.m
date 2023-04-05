//
// Created by Yves Le Borgne on 2022-12-28.
//

#import "CommandsWS.h"
#import "EHRRequests.h"
#import "SecureCredentials.h"
#import "WebServices.h"
#import "EHRState.h"
#import "PehrSDKConfig.h"
#import "Models.h"

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

- (void)getAppInfo:(VoidBlock)successBlock onError:(VoidBlock)errorBlock {

    SenderBlock callSuccess = ^(EHRCall *theCall) {
        // todo : replace this with a SDKDelegate call
        IBAppInfo *appInfo = [IBAppInfo objectWithContentsOfDictionary:theCall.serverResponse.responseContent[@"appInfo"]];
        PehrSDKConfig.shared.state.app = appInfo;
        [PehrSDKConfig.shared.state.delegate onAppInfoUpdate];
        successBlock();
    };
    SenderBlock callError   = ^(EHRCall *theCall) {
        MPLOGERROR(@"getAppInfo : FAILED.");
        errorBlock();
    };

    EHRCall *appInfo = [self getAppInfoCallWithSuccessBlock:callSuccess onError:callError];
    [appInfo start];

}

-(void) refreshNotifications:(VoidBlock) successBlock onError:(VoidBlock) errorBlock{
    VoidBlock sdkSuccess = ^(){
        [PehrSDKConfig.shared.state.delegate onNotificationsModelUpdate];
        successBlock();
    };
    [PehrSDKConfig.shared.models.notifications refreshFromServerWithSuccess:sdkSuccess andError:errorBlock];
}


- (void)getUserInfo:(VoidBlock)successBlock onError:(VoidBlock)errorBlock {
    SenderBlock callSuccess = ^(EHRCall *theCall) {
        id val = theCall.serverResponse.responseContent[@"services"];
        if (val) {
            [[AppState sharedAppState].servicesModel populateWithServices:[val allValues]];
            // todo :: this is obsolete (?)
        }

        val = theCall.serverResponse.responseContent[@"user"];
        if (val) {
            IBUser *new = [IBUser objectWithContentsOfDictionary:val];
            [PehrSDKConfig.shared.models.userModel updateUserInfo:new];
            [PehrSDKConfig.shared.state.delegate onUserInfoUpdate];
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

    VoidBlock prematureEnd = ^() {
        MPLOGERROR(@"Terminating pullUserDate : INCOMPLETE");
        errorBlock();
    };

    SenderBlock consentsSuccess = ^(id sender) {
        MPLOG(@"Consents pulled from forever : SUCCESS");
        // here we gat an NSArray of consents
        PehrSDKConfig.shared.models.consents = [NSArray arrayWithArray:sender];
        [PehrSDKConfig.shared.state.delegate onConsentsUpdate];
        successBlock();
    };
    SenderBlock consentsError   = ^(id sender) {
        MPLOGERROR(@"Consents pulled from forever : FAILED");
        prematureEnd();
    };


    VoidBlock notificationsSuccessBlock = ^() {
        MPLOG(@"Notifications pulled from forever : SUCCESS");
        [PehrSDKConfig.shared.state.delegate onNotificationsModelUpdate];
        [PehrSDKConfig.shared.ws.consent getConsents:consentsSuccess onError:consentsError];
    };
    VoidBlock notificationsErrorBlock   = ^() {
        MPLOGERROR(@"Notifications pulled from forever : FAILED");
        prematureEnd();
    };

    VoidBlock userInfoSuccess = ^() {
        MPLOG(@"UserInfo pulled from forever : SUCCESS");
        [PehrSDKConfig.shared.state.delegate onUserInfoUpdate];
        [PehrSDKConfig.shared.ws.notifications pullForever:notificationsSuccessBlock onError:notificationsErrorBlock];
    };

    VoidBlock userInfoError = ^() {
        MPLOGERROR(@"UserInfo pulled from forever : SUCCESS");
        prematureEnd();
    };

    VoidBlock appInfoSuccess = ^() {
        MPLOG(@"AppInfo pulled from forever : SUCCESS");
        [self getUserInfo:userInfoSuccess onError:userInfoError];
    };
    VoidBlock appInfoError   = ^() {
        MPLOG(@"AppInfo pulled from forever : FAILED");
        prematureEnd();
    };
    [self getAppInfo:appInfoSuccess onError:appInfoError];
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end