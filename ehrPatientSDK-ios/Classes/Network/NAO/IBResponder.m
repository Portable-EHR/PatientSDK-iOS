//
//  IBResponder.m
//  EHRPatientSDK
//
//  Created by Vinay on 2025-02-18.
//

#import <Foundation/Foundation.h>
#import "GERuntimeConstants.h"
#import "IBResponder.h"

@implementation IBResponder


+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    
    IBResponder *res = [[self alloc] init];
    res.relationship        = WantStringFromDic(dic, @"relationship");
    res.patientGuid         = WantStringFromDic(dic, @"patientGuid");
   
    return res;
}

- (NSDictionary *)asDictionary { 
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.relationship) dic[@"relationship"]     = self.relationship;
    if (self.patientGuid) dic[@"patientGuid"]       = self.patientGuid;
    
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
