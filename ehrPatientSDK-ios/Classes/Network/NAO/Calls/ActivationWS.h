//
// Created by Yves Le Borgne on 2023-01-31.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRLibRuntimeGlobals.h"
#import "UserModel.h"
#import "Models.h"
#import "PehrSDKConfig.h"

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

@end