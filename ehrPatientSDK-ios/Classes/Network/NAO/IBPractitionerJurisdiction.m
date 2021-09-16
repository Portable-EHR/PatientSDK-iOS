//
// Created by Yves Le Borgne on 2016-03-08.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "IBPractitionerJurisdiction.h"

@implementation IBPractitionerJurisdiction
TRACE_OFF

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        MPLOG(@"*** super returns nil!");
    }
    return self;
}

#pragma mark - EHRPersistableP

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)theDictionary {
    IBPractitionerJurisdiction *ad = [[IBPractitionerJurisdiction alloc] init];

    ad.issuer           = WantStringFromDic(theDictionary, @"issuer");
    ad.desc             = WantStringFromDic(theDictionary, @"description");
    ad.practitionerType = WantStringFromDic(theDictionary, @"practitionerType");
    return ad;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.issuer, dic, @"issuer");
    PutStringInDic(self.desc, dic, @"description");
    PutStringInDic(self.practitionerType, dic, @"practitionerType");
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