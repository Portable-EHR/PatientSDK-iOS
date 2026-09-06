//
//  EntryRepliesToPayload.m
//  EHRPatientSDK
//
//  Created by Vinay on 2023-10-02.
//

#import <Foundation/Foundation.h>
#import "EntryRepliesToPayload.h"
#import "EntryAttachment.h"
#import "GERuntimeConstants.h"
#import "PayloadQuestionnaire.h"
@implementation EntryRepliesToPayload

TRACE_OFF

@synthesize text = _text;
@synthesize attachmentCount = _attachmentCount;

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        MPLOG(@"*** super returns nil!");
    }
    return self;
}




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
    EntryRepliesToPayload *cep = [[EntryRepliesToPayload alloc] init];
    cep->_text = WantStringFromDic(dic, @"text");
    cep->_attachmentCount = WantIntegerFromDic(dic, @"attachmentCount");
    NSArray        *questAsDics = WantArrayFromDic(dic, @"questionnaires");
    NSMutableArray *quest       = [NSMutableArray array];
    if (nil != questAsDics) {
        for (id element in questAsDics) {
            [quest addObject:[PayloadQuestionnaire objectWithContentsOfDictionary:element]];
        }
    }
    cep.questionnaires = [NSArray arrayWithArray:quest];
    return cep;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.text, dic, @"text");
    PutIntegerInDic(self.attachmentCount, dic, @"attachmentCount");
    NSMutableArray            *quest = [NSMutableArray array];
    for (id <EHRNetworkableP> element in self.questionnaires) {
        [quest addObject:[element asDictionary]];
    }
    dic[@"questionnaires"] = [NSArray arrayWithArray:quest];
    return dic;
}

- (void)dealloc {

    _text        = nil;

    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end
