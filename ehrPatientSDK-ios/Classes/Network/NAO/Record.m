//
// Created by Yves Le Borgne on 2015-10-28.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "Record.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

@implementation Record

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
    Record *ad = [[Record alloc] init];
    ad.guid = WantStringFromDic(theDictionary,@"guid");
    return ad;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.guid,dic,@"guid");
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