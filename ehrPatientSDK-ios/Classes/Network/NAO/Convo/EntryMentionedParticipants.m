//
//  EntryMentionedParticipants.m
//  EHRPatientSDK
//
//  Created by Vinay on 2023-09-19.
//

#import <Foundation/Foundation.h>
#import "EntryMentionedParticipants.h"
#import "GERuntimeConstants.h"


@implementation EntryMentionedParticipants

@synthesize participantId = _participantId;

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
    EntryMentionedParticipants *emp = [[EntryMentionedParticipants alloc] init];
    emp->_participantId = WantStringFromDic(dic, @"participantId");
    return emp;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.participantId, dic, @"participantId");
    return dic;
}
- (void)dealloc {
    _participantId        = nil;

    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end
