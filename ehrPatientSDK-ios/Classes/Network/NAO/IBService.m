//
// Created by Yves Le Borgne on 2017-03-17.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "IBService.h"
#import "IBVersion.h"
#import "IBAgentInfo.h"
#import "IBCapability.h"

@implementation IBService

TRACE_OFF

- (id)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        MPLOGERROR(@"*** Yelp ! super returned nil!");
    }
    return self;

}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

//**************************************************************************************//
//  EHRPersistableP                                                                     //
//**************************************************************************************//

+ (id)objectWithContentsOfDictionary:(NSDictionary *)dic {
    IBService *ib = [[IBService alloc] init];
    ib.guid                       = WantStringFromDic(dic, @"guid");
    ib.name                       = WantStringFromDic(dic, @"name");
    ib.parentServiceGuid          = WantStringFromDic(dic, @"parentServiceGuid");
    ib.serviceDescription         = WantStringFromDic(dic, @"serviceDescription");
    ib.serviceDescriptionRenderer = WantStringFromDic(dic, @"serviceDescriptionRenderer");
    ib.summary                    = WantStringFromDic(dic, @"summary");
    ib.alias                      = WantStringFromDic(dic, @"alias");
    ib.infoUrl                    = WantStringFromDic(dic, @"infoUrl");
    ib.iconMediaGuid              = WantStringFromDic(dic, @"iconMediaGuid");
    ib.eula                       = WantStringFromDic(dic, @"eula");
    ib.eulaRenderer               = WantStringFromDic(dic, @"eulaRenderer");
    ib.active                     = WantBoolFromDic(dic, @"active");
    ib.createdOn                  = WantDateFromDic(dic, @"createdOn");
    ib.lastUpdated                = WantDateFromDic(dic, @"lastUpdated");
    ib.subscriptionRequired       = WantBoolFromDic(dic, @"subscriptionRequired");
    ib.version                    = [IBVersion versionWithString:WantStringFromDic(dic, @"version")];
    ib.seq                        = WantIntegerFromDic(dic, @"seq");
    ib.creationOrder              = WantStringFromDic(dic, @"creationOrder");
    ib.wasSeen                    = WantBoolFromDic(dic, @"wasSeen");

    NSMutableDictionary *capabilities = [NSMutableDictionary dictionary];

    id val;
    if ((val = [dic objectForKey:@"agentInfo"])) ib.agentInfo = [IBAgentInfo objectWithContentsOfDictionary:val];
    if ((val = [dic objectForKey:@"capabilities"])) {
        for (NSString *key in [val allKeys]) {
            NSDictionary *capAsDictionary = [val objectForKey:key];
            [capabilities setObject:[IBCapability objectWithContentsOfDictionary:capAsDictionary] forKey:key];
        }
    }
    ib.capabilities = capabilities;

    return ib;
}

- (NSDictionary *)asDictionary {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.guid, dic, @"guid");
    PutStringInDic(self.name, dic, @"name");
    PutStringInDic(self.parentServiceGuid, dic, @"parentServiceGuid");
    PutStringInDic(self.serviceDescription, dic, @"serviceDescription");
    PutStringInDic(self.serviceDescriptionRenderer, dic, @"serviceDescriptionRenderer");
    PutStringInDic(self.summary, dic, @"summary");
    PutStringInDic(self.alias, dic, @"alias");
    PutStringInDic(self.infoUrl, dic, @"infoUrl");
    PutStringInDic(self.iconMediaGuid, dic, @"iconMediaGuid");
    PutStringInDic(self.eula, dic, @"eula");
    PutStringInDic(self.eulaRenderer, dic, @"eulaRenderer");
    PutBoolInDic(self.active, dic, @"active");
    PutBoolInDic(self.subscriptionRequired, dic, @"subscriptionRequired");
    PutDateInDic(self.createdOn, dic, @"createdOn");
    PutDateInDic(self.lastUpdated, dic, @"lastUpdated");
    PutIntegerInDic(self.seq, dic, @"seq");
    PutStringInDic(self.creationOrder, dic, @"creationOrder");
    PutStringInDic(self.version.description, dic, @"version");
    PutBoolInDic(self.wasSeen, dic, @"wasSeen");
    if (self.agentInfo) [dic setObject:[self.agentInfo asDictionary] forKey:@"agentInfo"];
    if (self.capabilities.count > 0) {
        NSMutableDictionary *dicky = [NSMutableDictionary dictionary];
        for (IBCapability   *capability in [self.capabilities allValues]) {
            [dicky setObject:[capability asDictionary] forKey:capability.guid];
        }
        [dic setObject:dicky forKey:@"capabilities"];
    }
    return dic;
}

@end