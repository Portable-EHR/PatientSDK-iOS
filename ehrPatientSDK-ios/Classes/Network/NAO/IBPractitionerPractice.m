//
// Created by Yves Le Borgne on 2017-11-11.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "EHRPersistableP.h"
#import "IBPractitionerPractice.h"
#import "IBPractitionerJurisdiction.h"
#import "GERuntimeConstants.h"
@implementation IBPractitionerPractice

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
    IBPractitionerPractice *pa = [[self alloc] init];
    pa.practiceNumber = WantStringFromDic(dic, @"practiceNumber");
    id val = WantDicFromDic(dic, @"jurisdiction");
    if (val) pa.jurisdiction = [IBPractitionerJurisdiction objectWithContentsOfDictionary:val];
    return pa;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.practiceNumber, dic, @"practiceNumber");
    PutPersistableInDic(self.jurisdiction, dic, @"jurisdiction");
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