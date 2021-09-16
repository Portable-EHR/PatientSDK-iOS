//
// Created by Yves Le Borgne on 2017-09-28.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "EHRPersistableP.h"
#import "IBCapability.h"
#import "IBEula.h"

@implementation IBCapability

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

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    IBCapability *capability = [[self alloc] init];
    capability.name                  = WantStringFromDic(dic, @"name");
    capability.alias                 = WantStringFromDic(dic, @"alias");
    capability.capabilityDescription = WantStringFromDic(dic, @"capabilityDescription");
    capability.guid                  = WantStringFromDic(dic, @"guid");
    capability.serviceGuid           = WantStringFromDic(dic, @"serviceGuid");
    capability.activationMode        = WantStringFromDic(dic, @"activationMode");
    capability.scope                 = WantStringFromDic(dic, @"scope");
    capability.state                 = WantStringFromDic(dic, @"state");
    capability.createdOn             = WantDateFromDic(dic, @"createdOn");
    capability.lastUpdated           = WantDateFromDic(dic, @"lastUpdated");
    id val;
    if ((val = [dic objectForKey:@"eula"])) {
        capability.eula = [IBEula objectWithContentsOfDictionary:val];
    }
    return capability;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.name, dic, @"name");
    PutStringInDic(self.alias, dic, @"alias");
    PutStringInDic(self.capabilityDescription, dic, @"capabilityDescription");
    PutStringInDic(self.guid, dic, @"guid");
    PutStringInDic(self.serviceGuid, dic, @"serviceGuid");
    PutStringInDic(self.activationMode, dic, @"activationMode");
    PutStringInDic(self.scope, dic, @"scope");
    PutStringInDic(self.state, dic, @"state");
    PutDateInDic(self.createdOn, dic, @"createdOn");
    PutDateInDic(self.lastUpdated, dic, @"lastUpdated");
    PutPersistableInDic(self.eula, dic, @"eula");
    return dic;
}

- (NSString *)asJSON {
    return [[self asDictionary] asJSON];
}

- (NSData *)asJSONdata {
    return [[self asDictionary] asJSONdata];
}

+ (instancetype)objectWithJSONdata:(NSData *)jsonData {
    NSDictionary *dic = [NSDictionary dictionaryWithJSONdata:jsonData];
    return [self objectWithContentsOfDictionary:dic];
}

+ (instancetype)objectWithJSON:(NSString *)jsonString {
    NSDictionary *dic = [NSDictionary dictionaryWithJSON:jsonString];
    return [self objectWithContentsOfDictionary:dic];
}

@end