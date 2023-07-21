//
// Created by Yves Le Borgne on 2023-04-10.
//

#import "ConvoEntryBundle.h"
#import "PehrSDKConfig.h"
#import "WebServices.h"

@interface ConvoEntryBundle () {
    NSInteger                            _instanceNumber;
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
          onError:(SenderBlock)errorBlock __unused {

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
    theCall.maximumAttempts = 2;
    [theCall start];
}

+ (void)pullMoreEntries:(Conversation *)conversation
               atOffset:(NSInteger)offset
               maxItems:(NSInteger)maxItems
              onSuccess:(SenderBlock)successBlock
                onError:(SenderBlock)errorBlock __unused {

    ConvoEntryBundle *bundle = [[self alloc] init];
    bundle.offset   = offset;
    bundle.maxItems = maxItems;

    SenderBlock callSuccess = ^(EHRCall *theCall) {
        EHRServerResponse *resp   = theCall.serverResponse;
        Conversation      *_convo = [Conversation objectWithContentsOfDictionary:resp.responseContent];
        bundle.hasMore        = _convo.entries.count >= maxItems ? YES : NO;
        _convo.hasMoreEntries = bundle.hasMore;
        [conversation updateWithConversation:_convo];
        successBlock(_convo);
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
    theCall.maximumAttempts = 2;
    [theCall start];
}



TRACE_OFF

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