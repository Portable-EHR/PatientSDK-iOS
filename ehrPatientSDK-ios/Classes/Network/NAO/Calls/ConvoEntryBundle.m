//
// Created by Yves Le Borgne on 2023-04-10.
//

#import "ConvoEntryBundle.h"
#import "ConversationEntry.h"
#import "EHRLibRuntimeGlobals.h"
#import "EHRCall.h"
#import "PehrSDKConfig.h"
#import "WebServices.h"
#import "ConvoWS.h"

@interface ConvoEntryBundle () {
    NSInteger                            _instanceNumber;
    NSMutableArray <ConversationEntry *> *bundle;
}
@end

@implementation ConvoEntryBundle

@synthesize results = _results;
@synthesize hasMore = _hasMore;
@synthesize offset = _offset;
@synthesize maxItems = _maxItems;

+ (void)pullConvo:(ConversationEnvelope *)envelope
         maxItems:(NSInteger)count
        onSuccess:(SenderBlock)successBlock
          onError:(SenderBlock)errorBlock {

    SenderBlock callSuccess = ^(EHRCall *theCall) {
        MPLOG(@"pulled convo from envelope : SUCCESS");
        EHRServerResponse *resp   = theCall.serverResponse;
        Conversation      *_convo = [Conversation objectWithContentsOfDictionary:resp.responseContent];
        _convo.hasMoreEntries = _convo.indexedEntries.count >= count;
        successBlock(_convo);
    };

    SenderBlock callError = ^(id theCall) {
        MPLOGERROR(@"pulled convo from envelope : FAILED");
        errorBlock(theCall);
    };

    EHRCall *theCall = [PehrSDKConfig.shared.ws.convo getConvoDetailCall:callSuccess
                                                                 onError:callError
                                                                forConvo:envelope.guid
                                                                atOffset:0
                                                            withMaxItems:count
    ];
    [theCall start];
}

+ (void)pullMoreEntries:(Conversation *)conversation
               atOffset:(NSInteger)offset
               maxItems:(NSInteger)maxItems
              onSuccess:(SenderBlock)successBlock
                onError:(SenderBlock)errorBlock {

    ConvoEntryBundle *bundle = [[self alloc] init];
    bundle.offset   = offset;
    bundle.maxItems = maxItems;

    SenderBlock callSuccess = ^(EHRCall *theCall) {
        EHRServerResponse *resp   = theCall.serverResponse;
        Conversation      *_convo = [Conversation objectWithContentsOfDictionary:resp.responseContent];
        bundle.hasMore        = _convo.entries.count >= maxItems ? YES : NO;
        _convo.hasMoreEntries = bundle.hasMore;
        [conversation updateWithConversation:_convo];
        successBlock(bundle);
    };

    SenderBlock callError = ^(id theCall) {
        MPLOGERROR(@"pulled convo entries : FAILED");
        errorBlock(theCall);
    };

    EHRCall *theCall = [PehrSDKConfig.shared.ws.convo getConvoDetailCall:callSuccess
                                                                 onError:callError
                                                                forConvo:conversation.id
                                                                atOffset:offset
                                                            withMaxItems:maxItems
    ];
    [theCall start];
}

+ (void)pullFirstEntry:(Conversation *)conversation
              atOffset:(NSInteger)offset
              maxItems:(NSInteger)maxItems
             onSuccess:(SenderBlock)successBlock
               onError:(SenderBlock)errorBlock {

    ConvoEntryBundle *bundle = [[self alloc] init];
    bundle.offset   = offset;
    bundle.maxItems = maxItems;

    SenderBlock callSuccess = ^(EHRCall *theCall) {
        EHRServerResponse *resp   = theCall.serverResponse;
        Conversation      *_convo = [Conversation objectWithContentsOfDictionary:resp.responseContent];
        [conversation updateWithConversation:_convo];
        bundle.hasMore        = (bundle.results.count < maxItems) ? NO : YES;
        _convo.hasMoreEntries = bundle.hasMore;
        successBlock(bundle);
    };

    SenderBlock callError = ^(id theCall) {
        MPLOGERROR(@"pulled convo entries : FAILED");
        errorBlock(theCall);
    };

    EHRCall *theCall = [PehrSDKConfig.shared.ws.convo getConvoDetailCall:callSuccess
                                                                 onError:callError
                                                                forConvo:conversation.id
                                                                atOffset:0
                                                            withMaxItems:1
    ];
    [theCall start];
}

TRACE_ON

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        _results = [NSMutableArray array];

    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

- (void)dealloc {
    _results = nil;
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end