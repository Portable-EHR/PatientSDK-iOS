//
//  QuestionnaireParticipants.m
//  EHRPatientSDK
//
//  Created by Vinay on 2024-09-17.
//

#import <Foundation/Foundation.h>
#import "QuestionnaireParticipants.h"
#import "GERuntimeConstants.h"

@implementation QuestionnaireParticipants

@synthesize participantUUID = _participantUUID;
@synthesize token = _token;
@synthesize status = _status;

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
    QuestionnaireParticipants *qp= [[QuestionnaireParticipants alloc] init];
    qp->_participantUUID = WantStringFromDic(dic, @"participantUUID");
    qp->_token = WantStringFromDic(dic, @"token");
    qp->_status = WantStringFromDic(dic, @"status");
    return qp;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.participantUUID, dic, @"participantUUID");
    PutStringInDic(self.token, dic, @"token");
    PutStringInDic(self.status, dic, @"status");
    return dic;
}
- (void)dealloc {
    
    _participantUUID        = nil;
    _token                  = nil;
    _status                 = nil;
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end
