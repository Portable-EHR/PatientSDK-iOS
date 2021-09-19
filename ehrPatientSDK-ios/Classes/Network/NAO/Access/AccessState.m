//
// Created by Yves Le Borgne on 2020-03-06.
// Copyright (c) 2020 Portable EHR inc. All rights reserved.
//

#import "EHRInstanceCounterP.h"
#import "EHRNetworkableP.h"
#import "AccessState.h"
#import "AccessOffer.h"
#import "AccessRequest.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

@implementation AccessState
TRACE_OFF

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        MPLOG(@"*** super returns nil!");
    }
    return self;
}

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)theDictionary {
    AccessState *ct = [[AccessState alloc] init];
    id            val = nil;

    if ((val = theDictionary[@"request"])) {
        ct.request = [AccessRequest objectWithContentsOfDictionary:val];
    }
    if ((val = theDictionary[@"offer"])) {
        ct.offer = [AccessOffer objectWithContentsOfDictionary:val];
    }

    return ct;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];


    if (self.offer) {
        PutPersistableInDic(self.offer, dic, @"offer");
    }
    if (self.request) {
        PutPersistableInDic(self.request, dic, @"request");
    }
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
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}
@end
