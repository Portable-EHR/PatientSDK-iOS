//
// Created by Yves Le Borgne on 2022-12-29.
//

#import "ConsentWS.h"
#import "EHRRequests.h"


@interface ConsentWS () {
    NSInteger _instanceNumber;
}
@end

@implementation ConsentWS

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

- (EHRCall *)__unused  getAllConsents:(SenderBlock)successBlock
                              onError:(SenderBlock)errorBlock {

    EHRServerRequest *request = [EHRRequests getConsentsRequest];
    EHRCall          *call    = [EHRCall callWithRequest:request onSuccess:successBlock onError:errorBlock];

    return call;
}

- (EHRCall *)__unused  getAllConsentsWith:(NSMutableDictionary *)parameters
                                onSuccess:(SenderBlock)successBlock
                                  onError:(SenderBlock)errorBlock {
    EHRServerRequest *request = [EHRRequests getConsentsRequestWith:parameters];
    EHRCall          *call    = [EHRCall callWithRequest:request onSuccess:successBlock onError:errorBlock];

    return call;
}

- (EHRCall *)__unused getOneConsentWithGuid:(NSString *)guid
                                  onSuccess:(SenderBlock)successBlock
                                    onError:(SenderBlock)errorBlock {
    EHRCall *call;
    return call;
}

- (EHRCall *)revoke:(IBConsent *)consent consentGrantedGuid: (NSString *)consentGrantedGuid stackKey:(NSString *)stackKey onSuccess:(SenderBlock)successBlock onError:(SenderBlock)errorBlock {
    EHRServerRequest *request = [EHRRequests getRevokeConsentRequestForConsent:consent consentGrantedGuid:consentGrantedGuid];
    request.stackKey = stackKey;
    EHRCall          *call    = [EHRCall callWithRequest:request onSuccess:successBlock onError:errorBlock];
    return call;
}


//region workflows

/**
 *
 * @param guid the guid of the consent being pulled. Cant be nil
 * @param successBlock  will return a single IBConsent object
 * @param errorBlock  will return the failed EHRCall
 */

- (void)__unused getConsentWithGuid:(NSString *)guid
                          onSuccess:(SenderBlock)successBlock
                            onError:(SenderBlock)errorBlock {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"guid"] = guid;
    SenderBlock deserializeBlock = ^(EHRCall *theCall) {
        NSDictionary *theDic  = theCall.serverResponse.responseContent;
        IBConsent    *consent = [IBConsent objectWithContentsOfDictionary:theDic];
        successBlock(consent);
    };
    EHRCall     *consentCall     = [self getAllConsentsWith:params onSuccess:deserializeBlock onError:errorBlock];
    [consentCall start];
}

/**
 *
 * @param successBlock will return an array of IBConstnt object !
 * @param errorBlock will return the failed EHRCall
 */
- (void)__unused getConsents:(SenderBlock)successBlock
                     onError:(SenderBlock)errorBlock {
    NSMutableDictionary *params          = [NSMutableDictionary dictionary];
    SenderBlock         deserializeBlock = ^(EHRCall *theCall) {
        NSMutableArray *consents = [NSMutableArray array];
        NSDictionary   *responseDict  = theCall.serverResponse.responseContent;
        
        if (responseDict.count > 0) {
            
            for (NSDictionary *result in responseDict[@"user"]) {
                IBConsent *cep  = [IBConsent objectWithContentsOfDictionary:result];
                NSString  *idee = cep.guid;
                if (!idee) {
                    errorBlock(theCall);
                    return;
                }
                [consents addObject:cep];
            }
            
            NSDictionary *patientDict = responseDict[@"patients"];
            if ([patientDict isKindOfClass:[NSDictionary class]]) {
                NSArray *patientConsents = patientDict[@"all"];
                if ([patientConsents isKindOfClass:[NSArray class]]) {
                    IBConsent *cep  = [IBConsent objectWithContentsOfDictionary:patientConsents.firstObject];
                    NSString  *idee = cep.guid;
                    if (!idee) {
                        errorBlock(theCall);
                        return;
                    }
                    [consents addObject:cep];
                }
            }
        }

        successBlock(consents);

    };
    EHRCall             *consentCall     = [self getAllConsentsWith:params onSuccess:deserializeBlock onError:errorBlock];
    [consentCall start];
}

- (void)sharePrivateMessage:(NSString *)privateMessageGuid
                  ofPatient:(NSString *)patientGuid
             inConversation:(NSString *)conversationGuid
                   withText:(NSString *)shareMessage
                   stackKey:(NSString *)stackKey
                  onSuccess:(SenderBlock)successBlock
                    onError:(SenderBlock)errorBlock {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    NSArray<NSString *> *patientGuid =
    params[@"patients"]       = @[patientGuid];
    params[@"type"]           = @"share_private_message";
    params[@"element"]        = @"share_pm_on_conversation";
    params[@"privateMessage"] = privateMessageGuid;
    params[@"conversation"]   = conversationGuid;
    params[@"text"]           = shareMessage;
    EHRServerRequest *request = [EHRRequests putConsentsRequestWith:params];
    request.stackKey          = stackKey;
    EHRCall          *call    = [EHRCall callWithRequest:request onSuccess:successBlock onError:errorBlock];
    call.maximumAttempts = 1;
    call.timeOut         = 30.0;
    [call start];

}

/**
 *
 * @param consent  an IBConsent being granted by luser
 * @param patientGuid the specific patient this grant is for
 * @param successBlock sender block with  EHRCall
 * @param errorBlock  sender block with EHRCall
 */
- (void)__unused  consent:(IBConsent *)consent
              patientGuid:(NSArray<NSString *> *)patientGuid
                 stackKey:(NSString *) stackKey
                onSuccess:(SenderBlock)successBlock
                  onError:(SenderBlock)errorBlock {
    EHRServerRequest *request = [EHRRequests getConsentConsentRequestForPatient:patientGuid forConsent:consent];
                      request.stackKey = stackKey;
    EHRCall          *call    = [EHRCall callWithRequest:request onSuccess:successBlock onError:errorBlock];
    [call start];

}

/**
 *
 * @param guid  the id of the consent to be revoked
 * @param successBlock the caller's block that will be invoked on success
 * @param errorBlock  sender block with EHRCall
 */
- (void)__unused  revokeConsentWithGuid:(NSString *)guid
                         inConversation:(Conversation *)convo
                                stackKey:(NSString *)stackKey
                              onSuccess:(VoidBlock)successBlock
                                onError:(SenderBlock)errorBlock {

    SenderBlock consentCallSuccess = ^(EHRCall *theCall) {
        MPLOG(@"Revoke consent [%@] : SUCCESS", guid);
        successBlock();
    };

    SenderBlock consentCallError = ^(EHRCall *theCall) {
        MPLOGERROR(@"Revoke consent [%@] : FAILED", guid);
        errorBlock(theCall);
    };

    EHRServerRequest *request = [EHRRequests getRevokeConsentRequestForConsentWithGuid:guid];
    request.parameters[@"consentedItemId"] = convo.id;
    request.stackKey = stackKey;
    EHRCall *call = [EHRCall callWithRequest:request onSuccess:consentCallSuccess onError:consentCallError];
    [call start];
}


//endregion


- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end
