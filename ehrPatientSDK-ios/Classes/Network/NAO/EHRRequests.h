//
// Created by Yves Le Borgne on 2022-12-29.
//

#import <Foundation/Foundation.h>
#import "EHRServerRequest.h"
#import "AppState.h"
#import "EHRLibRuntimeGlobals.h"

@class IBConsent;

@interface EHRRequests : NSObject {

}

+ (EHRServerRequest *)requestWithRoute:(NSString *)route command:(NSString *)command parameters:(NSMutableDictionary *)parameters;

//region commands

+ (EHRServerRequest *)appInfoRequest __attribute__((unused));
+ (EHRServerRequest *)appInfoRequestWith:(NSMutableDictionary *)parameters;

+ (EHRServerRequest *)pingRequest __attribute__((unused));
+ (EHRServerRequest *)pingRequestWith:(NSMutableDictionary *)parameters;
+ (EHRServerRequest *)userInfoRequestWith:(NSMutableDictionary *)parameters __attribute__((unused));
//endregion

//region consent

+ (EHRServerRequest *)getConsentsRequest __attribute__((unused));
+ (EHRServerRequest *)getConsentsRequestWith:(NSMutableDictionary *)parameters;
+ (EHRServerRequest *)getConsentConsentRequestForPatient:(NSString *)patientGuid forConsent:(IBConsent *)consent  __attribute__((unused));
+ (EHRServerRequest *)getRevokeConsentRequestForConsent:(IBConsent *)consent __attribute__((unused));
+ (EHRServerRequest *)getRevokeConsentRequestForConsentWithGuid:(NSString *)consentGuid __attribute__((unused));
+ (EHRServerRequest *)putConsentsRequestWith:(NSMutableDictionary *)parameter;
//endregion
@end