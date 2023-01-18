//
// Created by Yves Le Borgne on 2022-12-29.
//

#import <Foundation/Foundation.h>
#import "GERuntimeConstants.h"
#import "EHRInstanceCounterP.h"

@class EHRCall;
@class IBConsent;

@interface ConsentWS : NSObject <EHRInstanceCounterP>

- (EHRCall *)__unused  getAllConsents:(SenderBlock)successBlock
                              onError:(SenderBlock)errorBlock;

- (EHRCall *)__unused  getAllConsentsWith:(NSMutableDictionary *)parameters
                                onSuccess:(SenderBlock)successBlock
                                  onError:(SenderBlock)errorBlock;

- (EHRCall *)__unused getOneConsentWithGuid:(NSString *)guid
                                  onSuccess:(SenderBlock)successBlock
                                    onError:(SenderBlock)errorBlock;

- (EHRCall *)__unused  revoke:(IBConsent *)consent
                    onSuccess:(SenderBlock)successBlock
                      onError:(SenderBlock)errorBlock;

- (EHRCall *)__unused  consent:(IBConsent *)consent
                   patientGuid:(NSString *)guid
                     onSuccess:(SenderBlock)successBlock
                       onError:(SenderBlock)errorBlock;

@end