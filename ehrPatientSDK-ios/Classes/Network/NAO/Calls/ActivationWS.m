//
// Created by Yves Le Borgne on 2023-01-31.
//

#import "ActivationWS.h"
#import "EHRLibState.h"
#import "IBUser.h"
#import "SecureCredentials.h"
#import "UserCredentials.h"
#import "EHRRequests.h"
#import "EHRCall.h"

@interface ActivationWS () {
    NSInteger _instanceNumber;
}
@end

@implementation ActivationWS

- (void)setFirebaseDeviceToken:(NSString *)token onSuccess:(VoidBlock)successBlock onError:(VoidBlock)errorBlock {
    if (PehrSDKConfig.shared.state.user.isGuest) {
        TRACE(@"Cant send a device token for user [guest]");
        errorBlock();
    } else if (PehrSDKConfig.shared.state.secureCredentials.current.isGuest) {
        NSLog(@"Cant send a device token for guest secure credentials");
        errorBlock();
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"token"] = token;
        EHRServerRequest *request = [EHRRequests requestWithRoute:@"/app/user/device" command:@"setNotificationToken" parameters:params];

        SenderBlock callSuccess = ^(id theCall) {
            successBlock();
        };
        SenderBlock callError   = ^(EHRCall *theCall) {
            NSLog(@"***EHRCall , status   [%@], message[%@]",
                    theCall.serverResponse.requestStatus.status,
                    theCall.serverResponse.requestStatus.message
            );
            NSLog(@"*** EHRCall , route    %@[%@]", theCall.serverRequest.route, theCall.serverRequest.command);
            NSLog(@"*** EHRCall , api key  [%@]", theCall.serverRequest.apiKey);
            NSLog(@"*** EHRCall , dev guid [%@]", theCall.serverRequest.deviceGuid);
            if (theCall.serverRequest.parameters) {
                NSLog(@"*** Cleaning up , parameters\n[%@]", [theCall.serverRequest.parameters asJSON]);
            }
            errorBlock();
        };

        EHRCall *notificationTokenCall = [EHRCall callWithRequest:request
                                                        onSuccess:callSuccess
                                                          onError:callError];
        [notificationTokenCall start];
    }
}

TRACE_ON

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end
