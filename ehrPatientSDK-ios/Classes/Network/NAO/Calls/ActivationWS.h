//
// Created by Yves Le Borgne on 2023-01-31.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRLibRuntimeGlobals.h"
#import "UserModel.h"
#import "Models.h"
#import "PehrSDKConfig.h"
#import "OBManualActivationSpec.h"
#import "IBScannedOffer.h"
#import "IBUserEula.h"
#import "OBPinActivationSpec.h"

#import "OBPinActivationSpec.h"

typedef enum : NSInteger {
    IdentificationFactorUnknown,
    IdentificationFactorEmail,
    IdentificationFactorMobile
} IdentificationFactor;

@interface ActivationWS : NSObject <EHRInstanceCounterP> {
}

- (void)setFirebaseDeviceToken:(NSString *)token onSuccess:(VoidBlock)successBlock onError:(VoidBlock)errorBlock;
- (void)confirmPINforIdentificationFactorpin:(IdentificationFactor)factor
                                     withPIN:(NSString *)pin
                                   onSuccess:(SenderBlock)successBlock
                                     onError:(SenderBlock)errorBlock;

- (void)getOfferFor:(OBManualActivationSpec *)spec
          onSuccess:(SenderBlock)successBlock
            onError:(SenderBlock)errorBlock;

- (void)claimOffer:(IBScannedOffer *)offer
         onSuccess:(SenderBlock)successBlock
           onError:(SenderBlock)errorBlock;

- (void)scanQRCodeclaimOffer:(NSString *)interimQRcode
         onSuccess:(SenderBlock)successBlock
           onError:(SenderBlock)errorBlock;

- (void)registerUserWithSpec:(OBManualActivationSpec *)spec
                   onSuccess:(SenderBlock)successBlock
                     onError:(SenderBlock)errorBlock;

- (void)registerUserWithPinSpec:(OBPinActivationSpec *)spec
                   onSuccess:(SenderBlock)successBlock
                     onError:(SenderBlock)errorBlock;

- (void)registerUserWithScanQRSpec:(NSString *)interimCode
                   onSuccess:(SenderBlock)successBlock
                     onError:(SenderBlock)errorBlock;

- (void)deactivateDevice:(NSString *)deviceGuid onSuccess:(VoidBlock)successBlock onError:(SenderBlock)errorBlock;

@end
