//
//  EntryAnnouncementPayload.m
//  EHRPatientSDK
//
//  Created by Vinay on 2024-05-27.
//

#import <Foundation/Foundation.h>
#import "EntryAnnouncementPayload.h"
#import "GERuntimeConstants.h"

@implementation EntryAnnouncementPayload

@synthesize text = _text;

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
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

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    EntryAnnouncementPayload *eap = [[EntryAnnouncementPayload alloc] init];
    eap->_text = WantStringFromDic(dic, @"text");
    
    return eap;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.text, dic, @"text");
    return dic;
}

@end

