//
//  Study.m
//  EHRPatientSDK
//
//  Created by Vinay on 2025-01-06.
//

#import <Foundation/Foundation.h>
#import "Study.h"

@implementation Study

@synthesize IBStudy = _study;
@synthesize consentable = _consentable;
@synthesize dispensaryInf = _dispensaryInf;

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    
    Study *study = [[self alloc] init];
    
    if (dic[@"study"]) study->_study = [IBStudy objectWithContentsOfDictionary:dic[@"study"]];
    if (dic[@"consentable"]) study->_consentable = [IBConsentable objectWithContentsOfDictionary:dic[@"consentable"]];
    if (dic[@"dispensaryInfo"]) study->_dispensaryInf = [IBDispensaryInf objectWithContentsOfDictionary:dic[@"dispensaryInfo"]];
    
    return study;
}

- (NSDictionary *)asDictionary {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
   
    if (self.IBStudy) dic[@"study"] = [self.IBStudy asDictionary];
    if (self.consentable) dic[@"consentable"] = [self.consentable asDictionary];
    if (self.dispensaryInf) dic[@"dispensaryInfo"] = [self.dispensaryInf asDictionary];
    
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
