//
// Created by Yves Le Borgne on 2017-08-22.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "IBAgentInfo.h"
#import "IBAddress.h"
#import "IBContact.h"
#import "IBMediaInfo.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"
#import "GERuntimeConstants.h"

@implementation IBAgentInfo

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

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

+ (id)objectWithContentsOfDictionary:(NSDictionary *)dic {
    IBAgentInfo *ai = [[IBAgentInfo alloc] init];
    id          val;
    ai.guid             = WantStringFromDic(dic, @"guid");
    ai.agentDescription = WantStringFromDic(dic, @"agentDescription");
    ai.name             = WantStringFromDic(dic, @"name");
    ai.alias            = WantStringFromDic(dic, @"alias");
    ai.lastUpdated      = WantDateFromDic(dic, @"lastUpdated");
    ai.createdOn        = WantDateFromDic(dic, @"cretedOn");
    ai.infoUrl          = WantStringFromDic(dic, @"infoUrl");
    if ((val = [dic objectForKey:@"logo"]))
        ai.logo = [IBMediaInfo objectWithContentsOfDictionary:val];
    if ((val = [dic objectForKey:@"address"]))
        ai.address = [IBAddress objectWithContentsOfDictionary:val];
    if ((val = [dic objectForKey:@"contact"]))
        ai.contact = [IBContact objectWithContentsOfDictionary:val];

    return ai;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.guid, dic, @"guid");
    PutStringInDic(self.agentDescription, dic, @"agentDescription");
    PutStringInDic(self.name, dic, @"name");
    PutStringInDic(self.alias, dic, @"alias");
    PutStringInDic(self.infoUrl, dic, @"infoUrl");
    PutDateInDic(self.lastUpdated, dic, @"lastUpdated");
    PutDateInDic(self.createdOn, dic, @"createdOn");
    if (self.address) [dic setObject:[self.address asDictionary] forKey:@"address"];
    if (self.contact) [dic setObject:[self.contact asDictionary] forKey:@"contact"];
    if (self.logo) [dic setObject:[self.logo asDictionary] forKey:@"logo"];
    return dic;
}

@end
