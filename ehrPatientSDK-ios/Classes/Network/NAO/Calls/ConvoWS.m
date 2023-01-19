//
// Created by Yves Le Borgne on 2022-12-28.
//

#import "ConvoWS.h"
#import "EHRRequests.h"
#import "ConvoEntrySpec.h"
#import "ConvoEntryAddSpec.h"
#import "Conversation.h"
#import "ConversationEntry.h"

@interface ConvoWS () {
    NSInteger _instanceNumber;
}
@end

@implementation ConvoWS

TRACE_OFF

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

//region calls

- (EHRCall *)__unused  addConvoEntryCall:(SenderBlock)successBlock onError:(SenderBlock)errorBlock withSpec:(ConvoEntryAddSpec *)spec {

    NSMutableDictionary *params  = [NSMutableDictionary dictionaryWithDictionary:[spec asDictionary]];
    EHRServerRequest    *request = [EHRRequests requestWithRoute:@"/app/patient/convo" command:@"addEntry" parameters:params];
    return [EHRCall callWithRequest:request onSuccess:successBlock onError:errorBlock];
}

- (EHRCall *)__unused  createConvoCall:(SenderBlock)successBlock onError:(SenderBlock)errorBlock {
    return nil;
}

- (EHRCall *)__unused getConvoDetailCall:(SenderBlock)successBlock
                                 onError:(SenderBlock)errorBlock
                                forConvo:(NSString *)guid
                                atOffset:(NSInteger)offset
                            withMaxItems:(NSInteger)maxItems {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    PutStringInDic(guid, params, @"id");
    PutIntegerInDic(offset, params, @"offset");
    PutIntegerInDic(maxItems, params, @"maxItems");
    EHRServerRequest *request = [EHRRequests requestWithRoute:@"/app/patient/convo"
                                                      command:@"pullConvo"
                                                   parameters:params];
    return [EHRCall callWithRequest:request onSuccess:successBlock onError:errorBlock];
}

- (EHRCall *)__unused listConvosCall:(SenderBlock)successBlock
                             onError:(SenderBlock)errorBlock
                            atOffset:(NSInteger)offset
                        withMaxItems:(NSInteger)maxItems {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    PutIntegerInDic(offset, params, @"offset");
    PutIntegerInDic(maxItems, params, @"maxItems");
    EHRServerRequest *request = [EHRRequests requestWithRoute:@"/app/patient/convo"
                                                      command:@"listConvos"
                                                   parameters:params
    ];
    return [EHRCall callWithRequest:request onSuccess:successBlock onError:errorBlock];
}

- (EHRCall *)__unused  getConvoDispensariesCall:(SenderBlock)successBlock onError:(SenderBlock)errorBlock {
    return nil;
}

- (EHRCall *)__unused  getConvoEntriesCall:(SenderBlock)successBlock onError:(SenderBlock)errorBlock {
    return nil;
}

- (EHRCall *)__unused  getConvoEnvelopesCall:(SenderBlock)successBlock
                                     onError:(SenderBlock)errorBlock
                                    atOffset:(NSInteger)offset
                                withMaxItems:(NSInteger)maxItems {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    PutIntegerInDic(offset, params, @"offset");
    PutIntegerInDic(maxItems, params, @"maxItems");
    EHRServerRequest *request = [EHRRequests requestWithRoute:@"/app/patient/convo" command:@"listConvos" parameters:params];
    return [EHRCall callWithRequest:request onSuccess:successBlock onError:errorBlock];
}

- (EHRCall *)__unused  getEntryAttachmentCall:(SenderBlock)successBlock
                                      onError:(SenderBlock)errorBlock
                              forConversation:(Conversation *)conversation
                                        entry:(ConversationEntry *)entry
                                   attachment:(NSString *)guid {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    PutStringInDic(conversation.id, params, @"convo");
    PutStringInDic(entry.id, params, @"entry");
    PutStringInDic(guid, params, @"attachment");
    EHRServerRequest *request =
                             [EHRRequests requestWithRoute:@"/app/patient/convo"
                                                   command:@"pullAttachment" parameters:params
                             ];
    return [EHRCall callWithRequest:request onSuccess:successBlock onError:errorBlock];
}

- (EHRCall *)__unused  getEntryAttachmentCall:(SenderBlock)successBlock onError:(SenderBlock)errorBlock {
    return nil;
}

- (EHRCall *)__unused  getEntryPointsCall:(SenderBlock)successBlock onError:(SenderBlock)errorBlock {
    return nil;
}



//endregion



- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end