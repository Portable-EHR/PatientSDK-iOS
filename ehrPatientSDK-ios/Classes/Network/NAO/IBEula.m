//
// Created by Yves Le Borgne on 2017-09-23.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "EHRNetworkableP.h"
#import "IBEula.h"
#import "Version.h"

@implementation IBEula

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
    IBEula *eula = [[self alloc] init];
    eula.guid        = WantStringFromDic(dic, @"guid");
    eula.objectGuid  = WantStringFromDic(dic, @"objectGuid");
    eula.scope       = WantStringFromDic(dic, @"scope");
    eula.type        = WantStringFromDic(dic, @"type");
    eula.text        = WantStringFromDic(dic, @"text");
    eula.renderer    = WantStringFromDic(dic, @"renderer");
    eula.createdOn   = WantDateFromDic(dic, @"createdOn");
    eula.lastUpdated = WantDateFromDic(dic, @"lastUpdated");

    if ([dic objectForKey:@"version"]) {
        eula.version = [Version versionWithString:[dic objectForKey:@"version"]];
    }

    return eula;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    PutStringInDic(self.guid, dic, @"guid");
    PutStringInDic(self.objectGuid, dic, @"objectGuid");
    PutStringInDic(self.scope, dic, @"scope");
    PutStringInDic(self.text, dic, @"text");
    PutStringInDic(self.renderer, dic, @"renderer");
    PutDateInDic(self.createdOn, dic, @"createdOn");
    PutDateInDic(self.lastUpdated, dic, @"lastUpdated");
    if (self.version) PutStringInDic([self.version toString], dic, @"version");
    return dic;

}

@end