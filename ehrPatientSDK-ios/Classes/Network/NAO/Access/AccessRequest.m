//
// Created by Yves Le Borgne on 2020-03-06.
// Copyright (c) 2020 Portable EHR inc. All rights reserved.
//

#import "EHRInstanceCounterP.h"
#import "EHRNetworkableP.h"
#import "AccessRequest.h"
#import "IBUserInfo.h"
#import "GEMacros.h"

@implementation AccessRequest
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
    AccessRequest *ct = [[AccessRequest alloc] init];
    id            val = nil;
    ct.guid              = WantStringFromDic(theDictionary, @"guid");
    ct.expiresOn         = WantDateFromDic(theDictionary, @"expiresOn");
    ct.seenOn            = WantDateFromDic(theDictionary, @"expiresOn");
    ct.requestedOn       = WantDateFromDic(theDictionary, @"requestedOn");
    ct.fulfilledOn       = WantDateFromDic(theDictionary, @"fulfilledOn");
    ct.fulfillmentMethod = WantStringFromDic(theDictionary, @"fulfillmentMethod");
    ct.fulfillmentState  = WantStringFromDic(theDictionary, @"fulfillmentState");
    if ((val = theDictionary[@"requester"])) {
        ct.requester = [IBUserInfo objectWithContentsOfDictionary:val];
    }
    if ((val = theDictionary[@"requestee"])) {
        ct.requestee = [IBUserInfo objectWithContentsOfDictionary:val];
    }

    return ct;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.guid, dic, @"guid");
    PutStringInDic(self.fulfillmentMethod, dic, @"fulfilmentMethod");
    PutStringInDic(self.fulfillmentState, dic, @"fulfilmentState");
    PutDateInDic(self.requestedOn, dic, @"requestedOn");
    PutDateInDic(self.expiresOn, dic, @"expiresOn");
    PutDateInDic(self.fulfilledOn, dic, @"fulfilledOn");
    PutDateInDic(self.seenOn, dic, @"seenOn");

    if (self.requester) {
        PutPersistableInDic(self.requester, dic, @"requester");
    }
    if (self.requestee) {
        PutPersistableInDic(self.requestee, dic, @"requestee");
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
