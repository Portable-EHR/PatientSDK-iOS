//
// Created by Yves Le Borgne on 2022-12-28.
//

#import <AppKit/AppKit.h>
#import "ConvoWS.h"
#import "EHRRequests.h"
#import "OBEntry.h"
#import "OBNewEntry.h"
#import "Conversation.h"
#import "ConversationEntry.h"
#import "ConversationEntryPoint.h"
#import "OBNewConvo.h"
#import "IBTelex.h"
#import "OfferedPrivateMessage.h"
#import "ConversationParticipant.h"

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

- (EHRCall *)__unused  addConvoEntryCall:(SenderBlock)successBlock onError:(SenderBlock)errorBlock withSpec:(OBNewEntry *)spec {

    NSMutableDictionary *params  = [NSMutableDictionary dictionaryWithDictionary:[spec asDictionary]];
    EHRServerRequest    *request = [EHRRequests requestWithRoute:@"/app/patient/convo" command:@"addEntry" parameters:params];
    return [EHRCall callWithRequest:request onSuccess:successBlock onError:errorBlock];
}

- (EHRCall *)__unused  createConvoCall:(SenderBlock)successBlock onError:(SenderBlock)errorBlock spec:(OBNewConvo *)spec {
    NSMutableDictionary *params  = [NSMutableDictionary dictionaryWithDictionary:[spec asDictionary]];
    EHRServerRequest    *request = [EHRRequests requestWithRoute:@"/app/patient/convo" command:@"create" parameters:params];
    EHRCall             *theCall = [EHRCall callWithRequest:request onSuccess:successBlock onError:errorBlock];
    return theCall;
}

- (void)__unused createConvo:(OBNewConvo *)spec
                   onSuccess:(SenderBlock)successBlock
                     onError:(SenderBlock)errorBlock {

    SenderBlock callSuccess = ^(EHRCall *theCall) {
        NSDictionary *obConvo = theCall.serverResponse.responseContent;
        Conversation *convo   = [Conversation objectWithContentsOfDictionary:obConvo];
        successBlock(convo);
    };

    EHRCall *theCall = [self createConvoCall:callSuccess onError:errorBlock spec:spec];
    [theCall start];

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

- (EHRCall *)__unused  getMyConvoDispensariesCall:(SenderBlock)successBlock onError:(SenderBlock)errorBlock {
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    EHRServerRequest    *request = [EHRRequests requestWithRoute:@"/app/patient/convo"
                                                         command:@"listMyConvoDispensaries"
                                                      parameters:params
    ];
    return [EHRCall callWithRequest:request onSuccess:successBlock onError:errorBlock];

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

- (EHRCall *)__unused getEntryPointsCallFor:(NSString *)dispensaryGuid
                                  onSuccess:(SenderBlock)successBlock
                                    onError:(SenderBlock)errorBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"guid"] = dispensaryGuid;
    EHRServerRequest *request = [EHRRequests requestWithRoute:@"/app/patient/convo"
                                                      command:@"pullEntryPoints"
                                                   parameters:params
    ];
    return [EHRCall callWithRequest:request onSuccess:successBlock onError:errorBlock];
}

- (EHRCall *)__unused getSetEntriesStatusCall:(NSString *)convoGuid
                                  statusLines:(NSArray<EntryParticipantStatus *> *)statusLines
                                    onSuccess:(SenderBlock)successBlock
                                      onError:(SenderBlock)errorBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"convo"]  = convoGuid;
    params[@"status"] = [NSMutableArray array];
    for (int         i        = 0; i < statusLines.count; ++i) {
        EntryParticipantStatus *line = statusLines[i];
        [params[@"status"] addObject:[line asDictionary]];
    }
    EHRServerRequest *request = [EHRRequests requestWithRoute:@"/app/patient/convo"
                                                      command:@"setEntriesStatus"
                                                   parameters:params
    ];
    return [EHRCall callWithRequest:request onSuccess:successBlock onError:errorBlock];
}

- (EHRCall *)__unused  getSharedPMCall:(SenderBlock)successBlock onError:(SenderBlock)errorBlock withParameters:(NSMutableDictionary *)parameters {

    EHRServerRequest *request = [EHRRequests requestWithRoute:@"/app/privateMessage" command:@"getShared" parameters:parameters];
    return [EHRCall callWithRequest:request onSuccess:successBlock onError:errorBlock];
}

- (void)__unused listMyConvoDispensaries:(SenderBlock)successBlock
                                 onError:(SenderBlock)errorBlock {
    SenderBlock goodCall = ^(EHRCall *theCall) {
        id                  rc     = theCall.serverResponse.responseContent;
        NSArray             *array = rc;
        NSMutableDictionary *list  = [NSMutableDictionary dictionary];
        for (NSDictionary   *dic in array) {
            list[dic[@"guid"]] = [ConvoDispensary objectWithContentsOfDictionary:dic];
        }
        successBlock(list);
    };

    EHRCall *listCall = [self getMyConvoDispensariesCall:goodCall onError:errorBlock];
    [listCall start];

}

//endregion

//region WorkFlows

- (void)    sendEntriesStatus:(NSArray<EntryParticipantStatus *> *)
        bundle ofConversation:(Conversation *)convo
                    onSuccess:(VoidBlock)successBlock
                      onError:(SenderBlock)errorBlock __attribute__((unused)) {
    EHRCall             *setStatusCall;
    NSMutableDictionary *entryPoints = [NSMutableDictionary dictionary];
    SenderBlock         entrySuccess = ^(id someCall) {
        EHRCall      *theCall = someCall;
        NSDictionary *results = theCall.serverResponse.responseContent;

        for (NSDictionary *result in results) {
            ConversationEntryPoint *cep  = [ConversationEntryPoint objectWithContentsOfDictionary:result];
            NSString               *idee = cep.id;
            if (!idee) {
                errorBlock(theCall);
                return;
            }
            entryPoints[idee] = cep;
        }
        successBlock();
    };

    SenderBlock entryError = ^(id someCall) {
        errorBlock(someCall);
    };

    setStatusCall = [self getSetEntriesStatusCall:convo.id statusLines:bundle onSuccess:entrySuccess onError:entryError];
    [setStatusCall start];
}

- (void)__unused getEntryPointsFor:(NSString *)dispensaryGuid onSuccess:(SenderBlock)successBlock onError:(SenderBlock)errorBlock {

    EHRCall             *entryPointsCalls;
    NSMutableDictionary *entryPoints = [NSMutableDictionary dictionary];
    SenderBlock         entrySuccess = ^(id someCall) {
        EHRCall      *theCall = someCall;
        NSDictionary *results = theCall.serverResponse.responseContent;

        for (NSDictionary *result in results) {
            ConversationEntryPoint *cep  = [ConversationEntryPoint objectWithContentsOfDictionary:result];
            NSString               *idee = cep.id;
            if (!idee) {
                errorBlock(theCall);
                return;
            }
            entryPoints[idee] = cep;
        }
        successBlock(entryPoints);
    };

    SenderBlock dispError = ^(id someCall) {
        errorBlock(someCall);
    };

    entryPointsCalls = [self getEntryPointsCallFor:dispensaryGuid onSuccess:entrySuccess onError:dispError];
    [entryPointsCalls start];

}

- (void)createEntry:(OBNewEntry *)entry onSuccess:(SenderBlock)successBlock onError:(SenderBlock)errorBlock {

    EHRCall *theCall = [self addConvoEntryCall:successBlock onError:errorBlock withSpec:entry];
    theCall.timeOut         = 15;
    theCall.maximumAttempts = 1;
    [theCall start];;

}

- (void)getSharedPrivateMessageWithConsent:(NSString *)consentGuid
                                       for:(NSString *)participantGuid
                                   inConvo:(NSString *)conversationGuid
                                 onSuccess:(SenderBlock)successBlock
                                   onError:(SenderBlock)errorBlock __attribute__((unused)) {
    EHRCall             *sharedPMcall;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"consentGuid"]      = consentGuid;
    parameters[@"participantGuid"]  = participantGuid;
    parameters[@"conversationGuid"] = conversationGuid;

    SenderBlock callSuccess = ^(id someCall) {
        EHRCall               *theCall = someCall;
        OfferedPrivateMessage *opm     = [OfferedPrivateMessage objectWithContentsOfDictionary:theCall.serverResponse.responseContent];
        successBlock(opm);
    };

    sharedPMcall = [self getSharedPMCall:callSuccess onError:errorBlock withParameters:parameters];
    sharedPMcall.timeOut = 30;
    [sharedPMcall start];
}

- (void)getAccessOffer:(NSString *)offerGuid
             onSuccess:(SenderBlock)successBlock
               onErrof:(SenderBlock)errorBlock __attribute__((unused)) {

}

- (void)setOfferStatus:(NSString *)offerGuid
                status:(NSString *)newStatus
             onSuccess:(SenderBlock)successBlock
               onError:(SenderBlock)errorBlock  __attribute__((unused)) {

}


//endregion




- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end