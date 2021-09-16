//
// Created by Yves Le Borgne on 2018-09-29.
// Copyright (c) 2019 Portable EHR inc. All rights reserved.
//

#import "EHRPersistableP.h"
#import "IBPatientContact.h"
#import "IBContact.h"

@implementation IBPatientContact

TRACE_OFF

- (instancetype)init {
    if ((self = [super init])) {GE_ALLOC();GE_ALLOC_ECHO();
    } else {
        MPLOG(@"*** super returns nil!");
    }
    return self;
}

+ (id)objectWithContentsOfDictionary:(NSDictionary *)dic {
    IBPatientContact *pc = [[IBPatientContact alloc] init];
    pc.isEmergency = WantBoolFromDic(dic, @"isEmergency");
    pc.type        = WantStringFromDic(dic, @"type");
    pc.contact     = [IBContact objectWithContentsOfDictionary:[dic objectForKey:@"contact"]];
    return pc;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.type, dic, @"type");
    PutPersistableInDic(self.contact, dic, @"contact");
    PutBoolInDic(self.isEmergency, dic, @"isEmergency");
    return dic;
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

- (void)dealloc {
    GE_DEALLOC();GE_DEALLOC_ECHO();
}

@end