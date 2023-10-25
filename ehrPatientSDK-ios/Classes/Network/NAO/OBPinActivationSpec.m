//
//  OBPinActivationSpec.m
//  EHRPatientSDK
//
//  Created by Vinay on 2023-10-25.
//

#import <Foundation/Foundation.h>
#import "OBPinActivationSpec.h"


@implementation OBPinActivationSpec

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

+ (id)objectWithContentsOfDictionary:(NSDictionary *)dic {
    OBPinActivationSpec *spec = [[self alloc] init];
    spec.mobilePhone = WantStringFromDic(dic, @"mobilePhone");
    spec.activationPin = WantStringFromDic(dic, @"PIN");
    return nil;
}

- (NSDictionary *)asDictionary {
    return [self asMutableDictionary];
}

-(NSMutableDictionary*) asMutableDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    PutStringInDic(self.mobilePhone, dictionary, @"mobilePhone");
    PutStringInDic(self.activationPin, dictionary, @"PIN");
    return dictionary;
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
