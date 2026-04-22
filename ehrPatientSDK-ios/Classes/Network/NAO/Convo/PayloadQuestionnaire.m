//
//  PayloadQuestionnaire.m
//  EHRPatientSDK
//
//  Created by Vinay on 2024-09-16.
//

#import <Foundation/Foundation.h>
#import "PayloadQuestionnaire.h"
#import "QuestionnaireParticipants.h"
#import "GERuntimeConstants.h"

@implementation PayloadQuestionnaire

@synthesize surveyId = _surveyId;
@synthesize title = _title;

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
    PayloadQuestionnaire *pq = [[PayloadQuestionnaire alloc] init];
    pq->_surveyId = WantStringFromDic(dic, @"surveyId");
    pq->_title = WantStringFromDic(dic, @"title");
    
    NSArray        *questAsDics = WantArrayFromDic(dic, @"participants");
    NSMutableArray *quest       = [NSMutableArray array];
    if (nil != questAsDics) {
        for (id element in questAsDics) {
            [quest addObject:[QuestionnaireParticipants objectWithContentsOfDictionary:element]];
        }
    }
    pq.participants = [NSArray arrayWithArray:quest];
    
    return pq;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.surveyId, dic, @"surveyId");
    PutStringInDic(self.title, dic, @"title");
    
    NSMutableArray            *quest = [NSMutableArray array];
    for (id <EHRNetworkableP> element in self.participants) {
        [quest addObject:[element asDictionary]];
    }
    dic[@"participants"] = [NSArray arrayWithArray:quest];
    
    return dic;
}
- (void)dealloc {
    
    _surveyId        = nil;
    _title           = nil;
    
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end
