//
// Created by Yves Le Borgne on 2015-10-22.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "IBPatientInfo.h"
#import "IBContact.h"
#import "IBAddress.h"
#import "GERuntimeConstants.h"

@implementation IBPatientInfo

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

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)theDictionary {
    IBPatientInfo *ad = [[IBPatientInfo alloc] init];
    id            val = nil;
    ad.reachable        = WantBoolFromDic(theDictionary, @"reachable");
    ad.dateOfBirth      = WantDateFromDic(theDictionary, @"dateOfBirth");
    ad.dateOfDeath      = WantDateFromDic(theDictionary, @"dateOfDeath");
    ad.name             = WantStringFromDic(theDictionary, @"name");
    ad.firstName        = WantStringFromDic(theDictionary, @"firstName");
    ad.middleName       = WantStringFromDic(theDictionary, @"middleName");
    ad.gender           = WantStringFromDic(theDictionary, @"gender");
    ad.discoveryEnabled = WantBoolFromDic(theDictionary, @"discoveryEnabled");
    if ((val = theDictionary[@"contact"])) ad.contact = [IBContact objectWithContentsOfDictionary:val];
    if ((val = theDictionary[@"address"])) ad.address = [IBAddress objectWithContentsOfDictionary:val];
    return ad;
}

- (NSDictionary *)asDictionary {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutBoolInDic(self.reachable, dic, @"reachable");
    PutDateInDic(self.dateOfBirth, dic, @"dateOfBirth");
    PutDateInDic(self.dateOfDeath, dic, @"dateOfDeath");
    PutStringInDic(self.name, dic, @"name");
    PutStringInDic(self.firstName, dic, @"firstName");
    PutStringInDic(self.middleName, dic, @"middleName");
    PutStringInDic(self.gender, dic, @"gender");
    PutBoolInDic(self.discoveryEnabled, dic, @"discoveryEnabled");
    if (self.contact) dic[@"contact"] = [self.contact asDictionary];
    if (self.address) dic[@"address"] = [self.address asDictionary];

    return dic;
}

+ (instancetype)objectWithJSON:(NSString *)jsonString {
    NSDictionary *dic = [NSDictionary dictionaryWithJSON:jsonString];
    return [self objectWithContentsOfDictionary:dic];
}

+ (instancetype)objectWithJSONdata:(NSData *)jsonData {
    NSDictionary *dic = [NSDictionary dictionaryWithJSONdata:jsonData];
    return [self objectWithContentsOfDictionary:dic];
}

- (NSString *)asJSON {
    return [[self asDictionary] asJSON];
}

- (NSData *)asJSONdata {
    return [[self asDictionary] asJSONdata];
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}
@end