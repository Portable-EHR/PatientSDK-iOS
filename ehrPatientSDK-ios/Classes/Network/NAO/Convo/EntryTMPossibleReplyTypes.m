//
//  EntryTMPossibleReplyTypes.m
//  EHRPatientSDK
//
//  Created by Vinay on 2023-09-19.
//

#import <Foundation/Foundation.h>
#import "EntryTMPossibleReplyTypes.h"
#import "GERuntimeConstants.h"

@implementation EntryTMPossibleReplyTypes

@synthesize possibleRepliesTypes = _possibleRepliesTypes;

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
    EntryTMPossibleReplyTypes *eprt = [[EntryTMPossibleReplyTypes alloc] init];
    eprt->_possibleRepliesTypes = WantStringFromDic(dic, @"possibleRepliesTypes");
    return eprt;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.possibleRepliesTypes, dic, @"possibleRepliesTypes");
    return dic;
}
- (void)dealloc {
    _possibleRepliesTypes = nil;

    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end
