//
// Created by Yves Le Borgne on 2023-01-31.
//

#import "ActivationWS.h"
#import "EHRState.h"
#import "IBUser.h"
#import "SecureCredentials.h"
#import "UserCredentials.h"
#import "EHRRequests.h"
#import "EHRCall.h"
#import "PehrSDKConfig.h"

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

- (void)confirmPINforIdentificationFactorpin:(IdentificationFactor)factor
                                     withPIN:(NSString *)pin
                                   onSuccess:(SenderBlock)successBlock
                                     onError:(SenderBlock)errorBlock {
    NSString *route;
    NSString *command = @"sendPIN";

    if (factor == IdentificationFactorEmail) {
        route = @"/app/patient/user/email";
    } else if (factor == IdentificationFactorMobile) {
        route = @"/app/patient/user/mobile";
    } else {
        MPLOGERROR(@"confirmPINforIdentificationFactorpin : invoked with invalid identification factor");
        errorBlock(nil);
    }

    EHRServerRequest *confirmationRequest = [[EHRServerRequest alloc] init];
    confirmationRequest.server  = [SecureCredentials sharedCredentials].current.server;
    confirmationRequest.route   = route;
    confirmationRequest.command = command;

    // caveat : our user is still not active, so we must call as guest again

    confirmationRequest.apiKey = [SecureCredentials sharedCredentials].current.userApiKey;
    PutStringInDic(pin, confirmationRequest.parameters, @"PIN");

    EHRCall *confirmationCall =
                    [EHRCall callWithRequest:confirmationRequest
                                   onSuccess:^(EHRCall *call) {
                                       EHRServerResponse *resp = call.serverResponse;
                                       MPLOG(@"response is \n%@", [call.serverResponse asDictionary]);
                                       if ([[resp requestStatus].status isEqualToString:@"OK"]) {
                                           if (factor == IdentificationFactorMobile) {
                                               [PehrSDKConfig.shared.models.userModel setDeviceMobileVerified:YES];
                                               successBlock(call);
                                           } else if (factor == IdentificationFactorEmail) {
                                               [PehrSDKConfig.shared.models.userModel setDeviceEmailVerified:YES];
                                               successBlock(call);
                                           } else {
                                               // this would be a bad state !!! what else could be a valid PIN ?
                                               MPLOGERROR(@"Got a positive PIN validation for an unknown identification factor ! bailing out.");
                                               errorBlock(call);
                                           }

                                       } else {
                                           errorBlock(call);
                                       }
                                   } onError:^(EHRCall *call) {
                                EHRServerResponse *resp = call.serverResponse;
                                MPLOG(@"*** Error : got response with requestStatus %@", [resp.requestStatus asDictionary]);
                                errorBlock(call);

                            }
                    ];

    confirmationCall.timeOut = 15.0f;
    [confirmationCall start];

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
