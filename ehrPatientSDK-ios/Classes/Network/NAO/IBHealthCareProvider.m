//
// Created by Yves Le Borgne on 2017-08-11.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "IBHealthCareProvider.h"
#import "IBContact.h"
#import "IBService.h"

@implementation IBHealthCareProvider

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

#pragma mark - getters


#pragma mark - EHRPersistableP

+ (id)objectWithContentsOfDictionary:(NSDictionary *)dic {
    IBHealthCareProvider *hcp = [[IBHealthCareProvider alloc] init];
    hcp.guid                = WantStringFromDic(dic, @"guid");
    hcp.alias               = WantStringFromDic(dic, @"alias");
    hcp.providerDescription = WantStringFromDic(dic, @"providerDescription");
    hcp.providerName        = WantStringFromDic(dic, @"providerName");
    hcp.active              = WantBoolFromDic(dic, @"active");
    hcp.infoUrl             = WantStringFromDic(dic, @"infoUrl");
    hcp.logoMediaGuid       = WantStringFromDic(dic, @"logoMediaGuid");
    hcp.createdOn           = WantDateFromDic(dic, @"createdOn");
    hcp.lastUpdated         = WantDateFromDic(dic, @"lastUpdated");
    id val;
    if ((val = [dic objectForKey:@"adminContact"])) {
        hcp.adminContact = [IBContact objectWithContentsOfDictionary:val];
    }
    if ((val = [dic objectForKey:@"techContact"])) {
        hcp.techContact = [IBContact objectWithContentsOfDictionary:val];
    }
    if ((val = [dic objectForKey:@"serviceGuids"])) {
        hcp->_serviceGuids = val;
    }
    return hcp;
}

- (NSDictionary *)asDictionary {

    NSMutableDictionary *dick = [NSMutableDictionary dictionary];
    PutStringInDic(self.alias, dick, @"alias");
    PutStringInDic(self.guid, dick, @"guid");
    PutStringInDic(self.providerName, dick, @"providerName");
    PutStringInDic(self.providerDescription, dick, @"providerDescription");
    PutStringInDic(self.logoMediaGuid, dick, @"logoMediaGuid");
    PutStringInDic(self.infoUrl, dick, @"infoUrl");
    PutDateInDic(self.createdOn, dick, @"createdOn");
    PutDateInDic(self.lastUpdated, dick, @"lastUpdated");
    PutBoolInDic(self.active, dick, @"active");
    PutPersistableInDic(self.adminContact, dick, @"adminContact");
    PutPersistableInDic(self.techContact, dick, @"techContact");
    if (self.serviceGuids  ) {
        [dick setObject:self.serviceGuids forKey:@"serviceGuids"];
    }

    return dick;
}

@end