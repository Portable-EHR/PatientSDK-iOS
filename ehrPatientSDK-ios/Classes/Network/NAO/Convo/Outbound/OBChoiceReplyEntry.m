//
//  OBChoiceReplyEntry.m
//  EHRPatientSDK
//
//  Created by Vinay on 2023-09-19.
//

#import <Foundation/Foundation.h>
#import "OBChoiceReplyEntry.h"

@implementation OBChoiceReplyEntry

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    OBChoiceReplyEntry *cre = [[self alloc] init];
    cre.id     = WantStringFromDic(dic, @"id");
    return nil;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.id, dic, @"id");
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

TRACE_ON

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
@end
