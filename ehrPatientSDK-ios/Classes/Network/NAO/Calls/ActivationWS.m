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
#import "OBManualActivationSpec.h"
#import "WebServices.h"

@interface ActivationWS () {
    NSInteger _instanceNumber;
    NSString  *_savedFirebaseToken;
}
@end

@implementation ActivationWS

- (void)setFirebaseDeviceToken:(NSString *)token onSuccess:(VoidBlock)successBlock onError:(VoidBlock)errorBlock {

    _savedFirebaseToken = token;

    if (PehrSDKConfig.shared.state.secureCredentials.current.isGuest) {
        NSLog(@"Cant send a device token for guest secure credentials : keepin the token for later use, if device is activated !");
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
    NSString *command = @"validatePIN";

    if (factor == IdentificationFactorEmail) {
        route = @"/app/patient/user/email";
    } else if (factor == IdentificationFactorMobile) {
        route = @"/app/patient/user/mobile";
    } else {
        MPLOGERROR(@"confirmPINforIdentificationFactorpin : invoked with invalid identification factor");
        errorBlock(nil);
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"PIN"] = pin;

    EHRServerRequest *confirmationRequest = [EHRRequests requestWithRoute:route
                                                                  command:command
                                                               parameters:params];

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

- (void)getOfferFor:(OBManualActivationSpec *)spec
          onSuccess:(SenderBlock)successBlock
            onError:(SenderBlock)errorBlock {
    NSMutableDictionary *params  = (NSMutableDictionary *) [spec asDictionary];
    EHRServerRequest    *request = [EHRRequests requestWithRoute:@"/app/user/account"
                                                         command:@"manual"
                                                      parameters:params];

    SenderBlock offerSuccess = ^(EHRCall *call) {
        MPLOG(@"Get offer : SUCCESS");
        IBScannedOffer *offer = [IBScannedOffer objectWithContentsOfDictionary:call.serverResponse.responseContent];
        successBlock(offer);
    };

    SenderBlock offerFail = ^(EHRCall *call) {
        MPLOGERROR(@"Get offer : FAILED");
        errorBlock(call);
    };
    EHRCall     *call     = [EHRCall callWithRequest:request
                                           onSuccess:offerSuccess
                                             onError:offerFail];
    [call startAsGuest];
}

- (void)claimOffer:(IBScannedOffer *)offer
         onSuccess:(SenderBlock)successBlock
           onError:(SenderBlock)errorBlock {

    SenderBlock claimSuccess = ^(EHRCall *call) {
        MPLOG(@"Claim offer : SUCCESS");
        {
            NSDictionary *content = call.serverResponse.responseContent;
            NSString     *status  = WantStringFromDic(content, @"status");
            IBUser       *user    = [IBUser objectWithContentsOfDictionary:WantDicFromDic(content, @"userInfo")];
            IBDeviceInfo *device  = [IBDeviceInfo objectWithContentsOfDictionary:WantDicFromDic(content, @"deviceInfo")];
            MPLOG(@"Got status claim status [%@]", status);
            if (status) {
                if ([status isEqualToString:@"scanned"]
                        || [status isEqualToString:@"granted"]
                        || [status isEqualToString:@"pendingApproval"]) {
                    MPLOG(@"Claiming offer, activating device.");
                    [PehrSDKConfig.shared.models.userModel updateUserInfo:user save:NO];
                    PehrSDKConfig.shared.state.device                                     = device;
                    PehrSDKConfig.shared.state.secureCredentials.current.userGuid         = user.guid;
                    PehrSDKConfig.shared.state.secureCredentials.current.userApiKey       = user.apiKey;
                    PehrSDKConfig.shared.state.secureCredentials.current.hasConsentedEula = NO;
                    PehrSDKConfig.shared.state.secureCredentials.current.deviceGuid       = device.deviceGuid;
                    PehrSDKConfig.shared.state.secureCredentials.current.appEula          = [[IBUserEula alloc] init];
                    PehrSDKConfig.shared.state.secureCredentials.current.deviceGuid       = device.deviceGuid;
                    [PehrSDKConfig.shared.state.secureCredentials persist];

                    [self setFirebaseDeviceToken:self->_savedFirebaseToken onSuccess:^() {
                        MPLOG(@"Associated device to Firebase token : SUCCESS");
                        successBlock(call);
                    }                    onError:^() {
                        MPLOGERROR(@"Associated device to Firebase token : FAILED, but will carry on");
                        // THIS IS RIGHT : firebase tokenization will all be redone every time
                        // luser starts the App.  This is a last ditch attempt as part of the
                        // device activation process, to enable APNS immediately if possible.
                        successBlock(call);
                    }];

                } else if ([status isEqualToString:@"cancelled"]) {
                    MPLOGERROR(@"Claimed cancelled offer , bailing out.");
                    errorBlock(call);
                } else if ([status isEqualToString:@"expired"]) {
                    MPLOGERROR(@"Claimed expired offer , bailing out.");
                    errorBlock(call);
                } else {
                    MPLOGERROR(@"Claimed cancelled offer , bailing out.");
                    errorBlock(call);
                }
            } else {
                MPLOGERROR(@"Claim offer : did not get an offer status !");
                errorBlock(call);
            }
        }
    };
    SenderBlock claimError   = ^(EHRCall *call) {
        MPLOGERROR(@"Claim offer : FAILED with [%@]", call.serverResponse.requestStatus.status);
        errorBlock(call);
    };

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"guid"]       = offer.scannedCode;
    params[@"deviceInfo"] = [PehrSDKConfig.shared.state.device asDictionary];

    EHRServerRequest *request   = [EHRRequests requestWithRoute:@"/app/user/account"
                                                        command:@"scan"
                                                     parameters:params];
    EHRCall          *claimCall = [EHRCall callWithRequest:request
                                                 onSuccess:claimSuccess
                                                   onError:claimError];

    [claimCall startAsGuest];

}

- (void)registerUserWithSpec:(OBManualActivationSpec *)spec
                   onSuccess:
                           (SenderBlock)successBlock
                     onError:
                             (SenderBlock)errorBlock {

    VoidBlock pullSuccess = ^() {
        MPLOG(@"Pull user data : SUCCESS");
        successBlock(nil);
    };

    VoidBlock pullError = ^() {
        MPLOGERROR(@"Pull user data : FAILED");
        errorBlock(nil);
    };

    SenderBlock activateSuccess = ^(EHRCall *call) {
        [PehrSDKConfig.shared.ws.commands pullUserData:pullSuccess onError:pullError];
    };
    SenderBlock activateError   = ^(EHRCall *call) {
        errorBlock(call);
    };

    SenderBlock offerSuccess = ^(IBScannedOffer *scannedOffer) {
        [self claimOffer:scannedOffer onSuccess:activateSuccess onError:activateError];
    };

    SenderBlock offerFailed = ^(EHRCall *call) {
        errorBlock(call);
    };

    [self getOfferFor:spec onSuccess:offerSuccess onError:offerFailed];

}

- (void)deactivateDevice:(NSString *)deviceGuid onSuccess:(VoidBlock)successBlock onError:(SenderBlock)errorBlock {

    SenderBlock callSuccess = ^(EHRCall *theCall) {
        MPLOG(@"Device deactivation call [%@] : SUCCESS", deviceGuid);
        successBlock();
    };
    SenderBlock callError   = ^(EHRCall *theCall) {
        MPLOGERROR(@"Device deactivation call [%@] : FAILED", deviceGuid);
        errorBlock(theCall);
    };

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"guid"] = deviceGuid;
    EHRServerRequest *request        = [EHRRequests requestWithRoute:@"/app/user/device"
                                                             command:@"deactivate"
                                                          parameters:params];
    EHRCall          *deactivateCall = [EHRCall callWithRequest:request
                                                      onSuccess:callSuccess
                                                        onError:callError];

    [deactivateCall start];
}

TRACE_ON

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        _savedFirebaseToken = nil;
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
