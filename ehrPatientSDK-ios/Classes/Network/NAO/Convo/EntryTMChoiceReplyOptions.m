//
//  EntryTMChoiceReplyOptions.m
//  EHRPatientSDK
//
//  Created by Vinay on 2023-09-19.
//

#import <Foundation/Foundation.h>
#import "EntryTMChoiceReplyOptions.h"
#import "GERuntimeConstants.h"

@implementation EntryTMChoiceReplyOptions

@synthesize id = _id;

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
    EntryTMChoiceReplyOptions *ecro = [[EntryTMChoiceReplyOptions alloc] init];
    ecro->_id = WantStringFromDic(dic, @"id");
    return ecro;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.id, dic, @"id");
    return dic;
}
- (void)dealloc {
    _id        = nil;

    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end
