//
// Created by Yves Le Borgne on 2022-12-28.
//

#import "CommandsWS.h"
#import "EHRRequests.h"

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

- (EHRCall *)getAppInfoCallWithSuccessBlock:(SenderBlock) success onError:(SenderBlock) error __attribute__((unused)) {

    EHRServerRequest *request = [EHRRequests appInfoRequest];
    EHRCall *call = [EHRCall callWithRequest:request onSuccess:success onError:error];

    return call;
}

- (EHRCall *)getPingServerCallWithSuccessBlock:(SenderBlock) success onError:(SenderBlock) error __attribute__((unused)) {

    EHRServerRequest *request = [EHRRequests pingRequest];
    EHRCall *call = [EHRCall callWithRequest:request onSuccess:success onError:error];

    return call;
}

- (EHRCall *)getGetUserInfoCall:(SenderBlock)success
                     onError:(SenderBlock)error
__attribute__((unused)){

    EHRServerRequest *request = [EHRRequests userInfoRequestWith:[@{@"action": @"get"} mutableCopy]];
    EHRCall *call = [EHRCall callWithRequest:request onSuccess:success onError:error];

    return call;

}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end