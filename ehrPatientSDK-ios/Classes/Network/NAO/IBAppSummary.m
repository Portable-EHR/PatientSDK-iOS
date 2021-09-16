//
// Created by Yves Le Borgne on 2017-09-11.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "EHRPersistableP.h"
#import "IBAppSummary.h"
#import "Version.h"
#import "FactorsRequired.h"

@implementation IBAppSummary

TRACE_OFF

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
    IBAppSummary *ai = [[self alloc] init];

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

    val = [dic objectForKey:@"factorsRequired"];
    if (val) ai.factorsRequired = [FactorsRequired objectWithContentsOfDictionary:val];

    ai.lastUpdated   = WantDateFromDic(dic, @"lastUpdated");
    ai.createdOn     = WantDateFromDic(dic, @"createdOn");
    ai.lastRefreshed = WantDateFromDic(dic, @"lastRefreshed");
    if (!ai.lastRefreshed) ai.lastRefreshed = [NSDate dateWithTimeIntervalSince1970:0];
    ai.jurisdictions = WantDicFromDic(dic, @"jurisdictions");
    ai.dispensaries  = WantDicFromDic(dic, @"dispensaries");

    // get dispensaries [{guid,name}....{guid,name}]
    val = [dic objectForKey:@"dispensaries"];
    if (val) {
        ai->_dispensaries = val;
    }

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
    PutStringInDic([self.requiredVersion toString], dic, @"requiredVersion");

    PutDateInDic(self.createdOn, dic, @"createdOn");
    PutDateInDic(self.lastRefreshed, dic, @"lastRefreshed");
    PutDateInDic(self.lastUpdated, dic, @"lastUpdated");
    if (self.factorsRequired) [dic setObject:[self.factorsRequired asDictionary] forKey:@"factorsRequired"];
    if (self.jurisdictions) [dic setObject:self.jurisdictions forKey:@"jurisdictions"];
    if (self.dispensaries) [dic setObject:self.dispensaries forKey:@"dispensaries"];

    return dic;
}

- (void)refreshFrom:(IBAppSummary *)other {

    self.guid            = other.guid;
    self.agentGuid       = other.agentGuid;
    self.info            = other.info;
    self.name            = other.name;
    self.alias           = other.alias;
    self.createdOn       = other.createdOn;
    self.lastUpdated     = other.lastUpdated;
    self.version         = other.version;
    self.requiredVersion = other.requiredVersion;
    self.lastRefreshed   = [NSDate date];
    self.factorsRequired = other.factorsRequired;
    if (other.jurisdictions) self.jurisdictions = other.jurisdictions;
    if (other.dispensaries) self.dispensaries   = other.dispensaries;

}

@end