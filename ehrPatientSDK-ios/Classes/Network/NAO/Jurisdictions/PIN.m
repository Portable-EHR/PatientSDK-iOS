//
// Created by Yves Le Borgne on 2015-10-26.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "PIN.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

@implementation PIN

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
    PIN *ad = [[PIN alloc] init];
    ad.issuer  =  WantStringFromDic(theDictionary,@"issuer");
    ad.number=WantStringFromDic(theDictionary,@"number");
    return ad;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.issuer,dic,@"issuer");
    PutStringInDic(self.number,dic,@"number");
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