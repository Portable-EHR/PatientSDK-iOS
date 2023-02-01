//
// Created by Yves Le Borgne on 2017-09-11.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "EHRPersistableP.h"
#import "IBAppInfo.h"
#import "Version.h"
#import "IBEula.h"
#import "IBService.h"
#import "SecureCredentials.h"
#import "UserCredentials.h"
#import "IBUserEula.h"
#import "FactorsRequired.h"
#import "IBCapability.h"

@implementation IBAppInfo

TRACE_ON

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        self.lastRefreshed = [NSDate dateWithTimeIntervalSince1970:0];
        self.target        = @"ios";
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

+ (id)objectWithContentsOfDictionary:(NSDictionary *)dic {
    IBAppInfo *ai = [[self alloc] init];

    ai.guid      = WantStringFromDic(dic, @"guid");
    ai.agentGuid = WantStringFromDic(dic, @"agentGuid");
    ai.info      = WantStringFromDic(dic, @"info");
    ai.name      = WantStringFromDic(dic, @"name");
    ai.alias     = WantStringFromDic(dic, @"alias");
    ai.target    = WantStringFromDic(dic, @"target");
    id val = [dic objectForKey:@"version"];
    ai.version = val ? [Version versionWithString:val] : nil;
    val = [dic objectForKey:@"requiredVersion"];
    ai.requiredVersion = val ? [Version versionWithString:val] : nil;
    val = [dic objectForKey:@"availableVersion"];
    ai.availableVersion = val ? [Version versionWithString:val] : nil;

    val = [dic objectForKey:@"eula"];
    if (val) ai.eula = [IBEula objectWithContentsOfDictionary:val];

    val = [dic objectForKey:@"factorsRequired"];
    if (val) ai.factorsRequired = [FactorsRequired objectWithContentsOfDictionary:val];

    ai.lastUpdated   = WantDateFromDic(dic, @"lastUpdated");
    ai.createdOn     = WantDateFromDic(dic, @"createdOn");
    ai.lastRefreshed = WantDateFromDic(dic, @"lastRefreshed");
    if (!ai.lastRefreshed) ai.lastRefreshed = [NSDate dateWithTimeIntervalSince1970:0];
    ai.jurisdictions = WantDicFromDic(dic, @"jurisdictions");
    ai.dispensaries  = WantDicFromDic(dic, @"dispensaries");

    val = [dic objectForKey:@"services"];
    if (val) {
        NSMutableDictionary *dicky = [NSMutableDictionary dictionary];
        for (NSDictionary   *serviceAsDic in [val allValues]) {
            IBService *service = [IBService objectWithContentsOfDictionary:serviceAsDic];
            [dicky setObject:service forKey:service.guid];
        }
        ai->_services = dicky;
    }

    val = [dic objectForKey:@"capabilities"];
    if (val) {
        NSMutableDictionary *dicky = [NSMutableDictionary dictionary];
        for (NSDictionary   *capabilityAsDic in [val allValues]) {
            IBCapability *capability = [IBCapability objectWithContentsOfDictionary:capabilityAsDic];
            [dicky setObject:capability forKey:capability.guid];
        }
        ai->_capabilities = dicky;
    }

    // get dispensaries [{guid,name}....{guid,name}]
    val = [dic objectForKey:@"dispensaries"];
    if (val) {
        ai->_dispensaries = val;
    }

    // get juristictions
//    {
//        "healthCareJurisdiction" : [{"issuer":"name"},...,{"issuer":"name"}];
//    }

    val = [dic objectForKey:@"jurisdictions"];
    if (val) ai->_jurisdictions = val;

    return ai;
}

- (NSDictionary *)asDictionary {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    if (!self.lastRefreshed) self.lastRefreshed = [NSDate dateWithTimeIntervalSince1970:0];

    PutStringInDic(self.guid, dic, @"guid");
    PutStringInDic(self.agentGuid, dic, @"agentGuid");
    PutStringInDic(self.info, dic, @"info");
    PutStringInDic(self.name, dic, @"name");
    PutStringInDic(self.alias, dic, @"alias");
    PutStringInDic(self.target, dic, @"target");
    PutStringInDic([self.version toString], dic, @"version");
    PutStringInDic([self.availableVersion toString], dic, @"availableVersion");
    PutStringInDic([self.requiredVersion toString], dic, @"requiredVersion");

    PutDateInDic(self.createdOn, dic, @"createdOn");
    PutDateInDic(self.lastRefreshed, dic, @"lastRefreshed");
    PutDateInDic(self.lastUpdated, dic, @"lastUpdated");
    if (self.factorsRequired) [dic setObject:[self.factorsRequired asDictionary] forKey:@"factorsRequired"];
    if (self.eula) [dic setObject:[self.eula asDictionary] forKey:@"eula"];
    if (self.jurisdictions) [dic setObject:self.jurisdictions forKey:@"jurisdictions"];
    if (self.dispensaries) [dic setObject:self.dispensaries forKey:@"dispensaries"];

    if (self.services.count > 0) {
        NSMutableDictionary *dicky = [NSMutableDictionary dictionary];
        for (IBService      *service in [self.services allValues]) {
            [dicky setObject:[service asDictionary] forKey:service.guid];
        }
        [dic setObject:dicky forKey:@"services"];
    }

    if (self.capabilities.count > 0) {
        NSMutableDictionary *dicky = [NSMutableDictionary dictionary];
        for (IBCapability   *capability in [self.capabilities allValues]) {
            [dicky setObject:[capability asDictionary] forKey:capability.guid];
        }
        [dic setObject:dicky forKey:@"capabilities"];
    }

    return dic;
}

- (void)refreshFrom:(IBAppInfo *)other {

    self.guid            = other.guid;
    self.agentGuid       = other.agentGuid;
    self.info            = other.info;
    self.name            = other.name;

    if (other.eula && ![other.eula.version.description isEqualToString:[SecureCredentials sharedCredentials].current.appEula.eulaVersion.description]) {
        SecureCredentials *creds = [SecureCredentials sharedCredentials];
        // eula update from server !
        creds.current.appEula.eulaVersion   = other.eula.version;
        creds.current.appEula.eulaGuid      = other.eula.guid;
        creds.current.appEula.dateSeen      = nil;
        creds.current.appEula.dateConsented = nil;
        [creds persist];
    }
    self.eula            = other.eula;
    self.alias           = other.alias;
    self.createdOn       = other.createdOn;
    self.lastUpdated     = other.lastUpdated;
    self.version         = other.version;
    self.requiredVersion = other.requiredVersion;
    self.lastRefreshed   = [NSDate date];
    self.factorsRequired = other.factorsRequired;
    if (other.jurisdictions) self.jurisdictions = other.jurisdictions;
    if (other.dispensaries) self.dispensaries   = other.dispensaries;
    if (other.services) self.services           = other.services;
    if (other.capabilities) self.capabilities   = other.capabilities;

}

@end