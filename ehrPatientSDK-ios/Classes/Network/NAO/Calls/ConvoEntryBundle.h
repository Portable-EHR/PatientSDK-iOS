//
// Created by Yves Le Borgne on 2023-04-10.
//

#import <Foundation/Foundation.h>
#import "Conversation.h"
#import "ConversationEntry.h"
#import "GERuntimeConstants.h"
#import "EHRLibRuntimeGlobals.h"
#import "EHRCall.h"
#import "ConversationEnvelope.h"

@interface ConvoEntryBundle : NSObject <EHRInstanceCounterP> {

}

@property(nonatomic) BOOL                                 hasMore;
@property(nonatomic) NSInteger                            offset;
@property(nonatomic) NSInteger                            maxItems;
@property(nonatomic) NSMutableArray <ConversationEntry *> *results;

+ (void)pullConvo:(ConversationEnvelope *)envelope
         maxItems:(NSInteger)count
        onSuccess:(SenderBlock)successBlock
          onError:(SenderBlock)errorBlock;

+ (void)pullMoreEntries:(Conversation *)conversation
               atOffset:(NSInteger)offset
               maxItems:(NSInteger)maxItems
              onSuccess:(SenderBlock)successBlock
                onError:(SenderBlock)errorBlock;

@end