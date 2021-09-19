//
// Created by Yves Le Borgne on 2015-11-17.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//


#import "IBDispensaryInfo.h"
#import "IBContact.h"
#import "IBAddress.h"

@implementation IBDispensaryInfo

@synthesize guid = _guid;
@synthesize name = _name;
@synthesize shortName = _shortName;
@synthesize contact = _contact;
@synthesize address = _address;
@synthesize lastUpdated = _lastUpdated;
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
    _contact     = nil;
    _name        = nil;
    _address     = nil;
    _lastUpdated = nil;
}

#pragma mark - init from device, sniff device properties !

#pragma mark - business

#pragma mark - persistence

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {

    IBDispensaryInfo *pa = [[self alloc] init];
    pa->_address     = [IBAddress objectWithContentsOfDictionary:dic[@"address"]];
    pa->_contact     = [IBContact objectWithContentsOfDictionary:dic[@"contact"]];
    pa->_name        = WantStringFromDic(dic, @"name");
    pa->_shortName   = WantStringFromDic(dic, @"shortName");
    pa->_lastUpdated = WantDateFromDic(dic, @"lastUpdated");
    return pa;
}

- (NSDictionary *)asDictionary {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.name, dic, @"name");
    PutStringInDic(self.name, dic, @"shortName");
    PutDateInDic(self.lastUpdated, dic, @"lastUpdated");
    dic[@"contact"] = [self.contact asDictionary];
    dic[@"address"] = [self.address asDictionary];
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
