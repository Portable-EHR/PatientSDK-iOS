//
//  ParticipantResponders.m
//  EHRPatientSDK
//
//  Created by Vinay on 2025-03-27.
//

#import <Foundation/Foundation.h>
#import "ParticipantResponders.h"
#import "GERuntimeConstants.h"

@implementation ParticipantResponders

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
    ParticipantResponders *pr = [[ParticipantResponders alloc] init];
    pr.contact = [IBContact objectWithContentsOfDictionary:dic[@"contact"]];
    pr.guid = WantStringFromDic(dic, @"guid");
    return pr;

}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.guid) dic[@"guid"]       = self.guid;
    if (self.contact) dic[@"contact"] = [self.contact asDictionary];
    return dic;
}

@end
