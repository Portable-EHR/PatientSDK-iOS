//
// Created by Yves Le Borgne on 2022-12-29.
//

#import "ConsentWS.h"
#import "EHRCall.h"
#import "EHRRequests.h"
#import "IBConsent.h"

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

- (EHRCall *)revoke:(IBConsent *)consent onSuccess:(SenderBlock)successBlock onError:(SenderBlock)errorBlock {
    EHRServerRequest *request = [EHRRequests getRevokeConsentRequestForConsent:consent];
    EHRCall          *call    = [EHRCall callWithRequest:request onSuccess:successBlock onError:errorBlock];
    return call;
}

- (EHRCall *)__unused  consent:(IBConsent *)consent
                   patientGuid:(NSString *)patientGuid
                     onSuccess:(SenderBlock)successBlock
                       onError:(SenderBlock)errorBlock {
    EHRServerRequest *request = [EHRRequests getConsentConsentRequestForPatient:patientGuid forConsent:consent];
    EHRCall          *call    = [EHRCall callWithRequest:request onSuccess:successBlock onError:errorBlock];
    return call;
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end