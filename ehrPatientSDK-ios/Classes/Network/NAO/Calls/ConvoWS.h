//
// Created by Yves Le Borgne on 2022-12-28.
//

#import <Foundation/Foundation.h>
#import "GERuntimeConstants.h"
#import "EHRInstanceCounterP.h"
#import "EHRCall.h"
#import "ConvoDispensary.h"

@class EHRCall;
@class ConvoEntrySpec;
@class ConvoEntryAddSpec;
@class Conversation;
@class ConversationEntry;

@interface ConvoWS : NSObject <EHRInstanceCounterP>

- (EHRCall *)__unused  addConvoEntryCall:(SenderBlock)successBlock
                                 onError:(SenderBlock)errorBlock
                                withSpec:(ConvoEntryAddSpec *)spec;

- (EHRCall *)__unused  createConvoCall:(SenderBlock)successBlock
                               onError:(SenderBlock)errorBlock;

- (EHRCall *)__unused  getConvoDetailCall:(SenderBlock)successBlock
                                  onError:(SenderBlock)errorBlock
                                 forConvo:(NSString *)guid
                                 atOffset:(NSInteger)offset
                             withMaxItems:(NSInteger)maxItems;

- (EHRCall *)__unused listConvosCall:(SenderBlock)successBlock
                             onError:(SenderBlock)errorBlock
                            atOffset:(NSInteger)offset
                        withMaxItems:(NSInteger)maxItems;

- (EHRCall *)__unused getEntryPointsCallFor:(NSString *)dispensaryGuid
                                  onSuccess:(SenderBlock)successBlock
                                      onError:(SenderBlock)errorBlock;

- (EHRCall*)__unused getMyConvoDispensariesCall:(SenderBlock)successBlock
                                        onError:(SenderBlock)errorBlock;

- (void)__unused getMyEntryPoints:(SenderBlock)successBlock
                          onError:(SenderBlock)errorBlock;


- (EHRCall *)__unused  getConvoEntriesCall:(SenderBlock)successBlock onError:(SenderBlock)errorBlock;

- (EHRCall *)__unused  getConvoEnvelopesCall:(SenderBlock)successBlock
                                     onError:(SenderBlock)errorBlock
                                    atOffset:(NSInteger)offset
                                withMaxItems:(NSInteger)maxItems;

- (EHRCall *)__unused  getEntryAttachmentCall:(SenderBlock)successBlock
                                      onError:(SenderBlock)errorBlock
                              forConversation:(Conversation*)conversation
                                        entry:(ConversationEntry*) entry
                                   attachment:(NSString*) guid;


@end
