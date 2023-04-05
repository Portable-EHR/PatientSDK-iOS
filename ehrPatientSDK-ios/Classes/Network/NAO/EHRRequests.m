//
// Created by Yves Le Borgne on 2022-12-29.
//

#import "EHRRequests.h"
#import "EHRApiServer.h"
#import "SecureCredentials.h"
#import "UserCredentials.h"
#import "IBUser.h"
#import "UserModel.h"
#import "EHRCall.h"
#import "EHRGuid.h"
#import "IBConsent.h"
#import "PehrSDKConfig.h"

@implementation EHRRequests

//region app calls

+ (EHRApiServer *)getServer {
   return [EHRApiServer serverForStackKey:[PehrSDKConfig  shared].getAppStackKey];
}

+ (UserCredentials *)getCurrentUserCredentials {
    return [SecureCredentials sharedCredentials].current;
}

+ (EHRServerRequest *)requestWithRoute:(NSString *)route command:(NSString *)command parameters:(NSMutableDictionary *)parameters {
    EHRServerRequest *request = [[EHRServerRequest alloc] init];
    request.language   = PehrSDKConfig .shared.deviceLanguage;
    request.trackingId = [EHRGuid guid];
    request.server     = self.getServer;
    request.appAlias   = PehrSDKConfig.shared.getAppAlias;
    request.appGuid    = PehrSDKConfig.shared.getAppGuid;
    request.appVersion = PehrSDKConfig.shared.getAppVersion;
    request.route      = route;
    request.command    = command;
    request.deviceGuid = self.getCurrentUserCredentials.deviceGuid;
    request.apiKey     = self.getCurrentUserCredentials.userApiKey;
    if (nil != parameters && parameters.count > 0) {
        for (NSString *key in parameters) {
            id value = parameters[key];
            request.parameters[key] = (NSString *) value;
        }
    } else {
        request.parameters = [NSMutableDictionary dictionary];
    }

    return request;
}

//region commands

+ (EHRServerRequest *)appInfoRequest __attribute__((unused)) {
    return [self appInfoRequestWith:nil];
}

+ (EHRServerRequest *)appInfoRequestWith:(NSMutableDictionary *)parameters {

    return [self requestWithRoute:@"/app/commands" command:@"appinfo" parameters:parameters];
}

+ (EHRServerRequest *)pingRequest __attribute__((unused)) {
    return [self pingRequestWith:nil];
}

+ (EHRServerRequest *)pingRequestWith:(NSMutableDictionary *)parameters {
    return [self requestWithRoute:@"/app/commands" command:@"pingServer" parameters:parameters];
}

+ (EHRServerRequest *)userInfoRequestWith:(NSMutableDictionary *)parameters __attribute__((unused)) {
    return [self requestWithRoute:@"/app/commands" command:@"userinfo" parameters:parameters];
}


//endregion

//region consent

+ (EHRServerRequest *)getConsentsRequest __attribute__((unused)) {
    return [self getConsentsRequestWith:nil];
}

+ (EHRServerRequest *)getConsentsRequestWith:(NSMutableDictionary *)parameters {
    return [self requestWithRoute:@"/app/consent" command:@"get" parameters:parameters];
}

+ (EHRServerRequest *)putConsentsRequestWith:(NSMutableDictionary *)parameters {
    return [self requestWithRoute:@"/app/consent" command:@"consent" parameters:parameters];
}

+ (EHRServerRequest *)getConsentConsentRequestForPatient:(NSString *)patientGuid forConsent:(IBConsent *)consent  __attribute__((unused)) {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"guid"]    = patientGuid;
    params[@"type"]    = consent.consentableElementType;
    params[@"element"] = consent.guid;
    EHRServerRequest *req = [self requestWithRoute:@"/app/consent" command:@"consent" parameters:params];
    return req;
}

+ (EHRServerRequest *)getRevokeConsentRequestForConsent:(IBConsent *)consent __attribute__((unused)) {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"guid"] = consent.getGrantedConsent.guid;
    EHRServerRequest *request = [EHRRequests requestWithRoute:@"/app/consent" command:@"revoke" parameters:params];
    return request;
}



//endregion

@end