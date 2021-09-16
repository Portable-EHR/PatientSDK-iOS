//
// Created by Yves Le Borgne on 2015-10-22.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "PatientInfo.h"
#import "HCIN.h"
#import "PIN.h"
#import "SIN.h"

@implementation PatientInfo

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
    PatientInfo *ad = [[PatientInfo alloc] init];
    id      val = nil;
    ad.dateOfBirth=WantDateFromDic(theDictionary,@"dateOfBirth");
    ad.dateRegistered=WantDateFromDic(theDictionary,@"dateRegistered");
    ad.gender = WantStringFromDic(theDictionary,@"gender");
    if ((val = [theDictionary objectForKey:@"HCIN"])) ad.HCIN = [HCIN objectWithContentsOfDictionary:val];
    if ((val = [theDictionary objectForKey:@"SIN"])) ad.SIN = [SIN objectWithContentsOfDictionary:val];
    if ((val = [theDictionary objectForKey:@"PIN"])) ad.PIN = [PIN objectWithContentsOfDictionary:val];
    return ad;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutDateInDic(self.dateOfBirth,dic,@"dateOfBirth");
    PutDateInDic(self.dateRegistered,dic,@"dateRegistered");
    PutStringInDic(self.gender,dic,@"gender");
    if (self.HCIN) [dic setObject:[self.HCIN asDictionary] forKey:@"HCIN"];
    if (self.SIN) [dic setObject:[self.SIN asDictionary] forKey:@"SIN"];
    if (self.PIN) [dic setObject:[self.PIN asDictionary] forKey:@"PIN"];
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