//
// Created by Yves Le Borgne on 2022-12-29.
//

#import <Foundation/Foundation.h>
#import "GERuntimeConstants.h"
#import "EHRInstanceCounterP.h"
#import "EHRCall.h"
#import "IBConsent.h"

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

//region workflows

- (void)__unused sharePrivateMessage:(NSString *)privateMessageGuid
                           ofPatient:(NSString *)patientGuid
                      inConversation:(NSString *)conversationGuid
                            withText:(NSString *)shareMessage
                           onSuccess:(SenderBlock)successBlock
                             onError:(SenderBlock)errorBlock;

/**
 *
 * @param guid the guid of the consent being pulled. Cant be nil
 * @param successBlock  will return a single IBConsent object
 * @param errorBlock  will return the failed EHRCall
 */

- (void)__unused getConsentWithGuid:(NSString *)guid
                          onSuccess:(SenderBlock)successBlock
                            onError:(SenderBlock)errorBlock;

/**
 *
 * @param successBlock will return an array of IBConstnt object !
 * @param errorBlock will return the failed EHRCall
 */
- (void)__unused getConsents:(SenderBlock)successBlock
                     onError:(SenderBlock)errorBlock;

//endregion

@end