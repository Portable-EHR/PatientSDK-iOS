//
// Created by Yves Le Borgne on 2020-03-06.
// Copyright (c) 2020 Portable EHR inc. All rights reserved.
//

#import "AccessOffer.h"
#import "IBUserInfo.h"

@implementation AccessOffer

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
    AccessOffer *ct = [[AccessOffer alloc] init];
    id          val = nil;
    ct.guid              = WantStringFromDic(theDictionary, @"guid");
    ct.requestGuid       = WantStringFromDic(theDictionary, @"requestGuid");
    ct.resourceGuid      = WantStringFromDic(theDictionary, @"resourceGuid");
    ct.resourceKind      = WantStringFromDic(theDictionary, @"resourceKind");
    ct.expiresOn         = WantDateFromDic(theDictionary, @"expiresOn");
    ct.offeredOn         = WantDateFromDic(theDictionary, @"offeredOn");
    ct.seenOn            = WantDateFromDic(theDictionary, @"seenOn");
    ct.fulfillmentMethod = WantStringFromDic(theDictionary, @"fulfillmentMethod");
    ct.fulfillmentState  = WantStringFromDic(theDictionary, @"fulfillmentState");
    ct.persist           = WantBoolFromDic(theDictionary, @"persist");
    ct.qrCode            = WantStringFromDic(theDictionary, @"qrCode");

    if ((val = theDictionary[@"offeredBy"])) {
        ct.offeredBy = [IBUserInfo objectWithContentsOfDictionary:val];
    }
    if ((val = theDictionary[@"offeredTo"])) {
        ct.offeredTo = [IBUserInfo objectWithContentsOfDictionary:val];
    }

    return ct;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.guid, dic, @"guid");
    PutStringInDic(self.resourceGuid, dic, @"resourceGuid");
    PutStringInDic(self.requestGuid, dic, @"requestGuid");
    PutStringInDic(self.resourceKind, dic, @"resourceKind");
    PutStringInDic(self.fulfillmentMethod, dic, @"fulfilmentMethod");
    PutStringInDic(self.fulfillmentState, dic, @"fulfilmentState");
    PutDateInDic(self.offeredOn, dic, @"offeredOn");
    PutDateInDic(self.expiresOn, dic, @"expiresOn");
    PutDateInDic(self.seenOn, dic, @"seenOn");
    PutBoolInDic(self.persist, dic, @"persist");
    PutStringInDic(self.qrCode, dic, @"qrCode");
    if (self.offeredTo) {
        PutPersistableInDic(self.offeredTo, dic, @"offeredTo");
    }
    if (self.offeredBy) {
        PutPersistableInDic(self.offeredBy, dic, @"offeredBy");
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