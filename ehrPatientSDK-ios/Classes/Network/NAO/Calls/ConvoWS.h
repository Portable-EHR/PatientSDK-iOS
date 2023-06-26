//
// Created by Yves Le Borgne on 2022-12-28.
//

#import <Foundation/Foundation.h>
#import "GERuntimeConstants.h"
#import "EHRInstanceCounterP.h"
#import "EHRCall.h"
#import "ConvoDispensary.h"
#import "ConversationEntry.h"
#import "OBNewConvo.h"

@class EHRCall;
@class OBEntry;
@class OBNewEntry;
@class Conversation;
@class ConversationEntry;
@class OBNewConvo;
@class ConversationParticipant;

@interface ConvoWS : NSObject <EHRInstanceCounterP>

- (EHRCall *)__unused  addConvoEntryCall:(SenderBlock)successBlock
                                 onError:(SenderBlock)errorBlock
                                withSpec:(OBNewEntry *)spec;

- (EHRCall *)__unused  createConvoCall:(SenderBlock)successBlock
                               onError:(SenderBlock)errorBlock
                                  spec:(OBNewConvo *)spec;

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

- (EHRCall *)__unused getMyConvoDispensariesCall:(SenderBlock)successBlock
                                         onError:(SenderBlock)errorBlock;

- (void)__unused listMyConvoDispensaries:(SenderBlock)successBlock
                                 onError:(SenderBlock)errorBlock;

- (void)__unused getEntryPointsFor:(NSString *)dispensaryGuid onSuccess:(SenderBlock)successBlock
                           onError:(SenderBlock)errorBlock;

- (EHRCall *)__unused  getConvoEntriesCall:(SenderBlock)successBlock onError:(SenderBlock)errorBlock;

- (EHRCall *)__unused  getConvoEnvelopesCall:(SenderBlock)successBlock
                                     onError:(SenderBlock)errorBlock
                                    atOffset:(NSInteger)offset
                                withMaxItems:(NSInteger)maxItems;

- (EHRCall *)__unused  getEntryAttachmentCall:(SenderBlock)successBlock
                                      onError:(SenderBlock)errorBlock
                              forConversation:(Conversation *)conversation
                                        entry:(ConversationEntry *)entry
                                   attachment:(NSString *)guid;

//region business methods

- (void)sendEntriesStatus:(NSArray<EntryParticipantStatus *> *)
        bundle      ofConversation:(Conversation *)convo
                         onSuccess:(VoidBlock)successBlock
                           onError:(SenderBlock)errorBlock __attribute__((unused));

- (void)__unused createConvo:(OBNewConvo *)spec
                   onSuccess:(SenderBlock)successBlock
                     onError:(SenderBlock)errorBlock;

- (void)createEntry:(OBNewEntry *)entry
          onSuccess:(SenderBlock)successBlock
            onError:(SenderBlock)errorBlock __attribute__((unused));

- (void)getSharedPrivateMessageWithConsent:(NSString *)consentGuid
                                       for:(NSString *)participantGuid
                                   inConvo:(NSString *)conversationGuid
                                 onSuccess:(SenderBlock)successBlock
                                   onError:(SenderBlock)errorBlock __attribute__((unused));

- (void)getAccessOffer:(NSString *)offerGuid onSuccess:(SenderBlock)successBlock onErrof:(SenderBlock)errorBlock;
- (void)setOfferStatus:(NSString *)offerGuid status:(NSString *)newStatus onSuccess:(SenderBlock)successBlock onError:(SenderBlock)errorBlock;

//endregion

@end
