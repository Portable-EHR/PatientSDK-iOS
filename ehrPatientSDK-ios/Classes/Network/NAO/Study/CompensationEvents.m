//
//  CompensationEvents.m
//  EHRPatientSDK
//
//  Created by Vinay on 2025-01-09.
//


#import "CompensationEvents.h"
#import "GERuntimeConstants.h"

@implementation CompensationEvents


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

+ (id)objectWithContentsOfDictionary:(NSDictionary *)dic {
    CompensationEvents *ce= [[CompensationEvents alloc] init];
//    ce.amount = WantIntegerFromDic(dic, @"amount");
    id val = dic[@"amount"];
    ce.amount = [val floatValue];
    ce.guid = WantStringFromDic(dic, @"guid");
    ce.eventDescription = WantDicFromDic(dic, @"description");
    return ce;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutIntegerInDic(self.amount, dic, @"amount");
    PutStringInDic(self.guid, dic, @"guid");
    PutDicInDic(self.eventDescription, dic, @"description");
    return dic;
}
- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end
