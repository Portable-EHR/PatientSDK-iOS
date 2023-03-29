//
// Created by Yves Le Borgne on 2016-03-23.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "IBMessageDistribution.h"
#import "IBUserInfo.h"
#import "GERuntimeConstants.h"

@implementation IBMessageDistribution

TRACE_OFF

// helpers , not persisted

@dynamic isSeen, isLateSeing, isAcked, isArchived, shouldAck, hasDeadline;

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        MPLOG(@"*** super returns nil!");
    }
    return self;
}

#pragma mark - helpers

- (BOOL)isSeen {
    return (nil != self.seenOn);
}

- (BOOL)isAcked {
    return (nil != self.ackedOn);
}

- (BOOL)isArchived {
    return (nil != self.archivedOn);
}

- (BOOL)isLateSeing {
    if (!self.hasDeadline) return NO;
    NSDate *now = [NSDate date];
    return ([now timeIntervalSince1970] > [self.seeBefore timeIntervalSince1970]);
}

- (BOOL)hasDeadline {
    return (nil != self.seeBefore);
}

- (BOOL)shouldAck {
    if (!self.mustAck) return NO;
    if (self.ackedOn) return NO;
    return YES;
}

#pragma mark - EHRPersistableP

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)theDictionary {
    IBMessageDistribution *ad = [[IBMessageDistribution alloc] init];

    ad.guid        = WantStringFromDic(theDictionary, @"guid");
    ad.status      = WantStringFromDic(theDictionary, @"status");
    ad.progress    = WantStringFromDic(theDictionary, @"progress");
    ad.role        = WantStringFromDic(theDictionary, @"role");
    ad.seeBefore   = WantDateFromDic(theDictionary, @"seeBefore");
    ad.seenOn      = WantDateFromDic(theDictionary, @"seenOn");
    ad.ackedOn     = WantDateFromDic(theDictionary, @"ackedOn");
    ad.archivedOn  = WantDateFromDic(theDictionary, @"archivedOn");
    ad.lastUpdated = WantDateFromDic(theDictionary, @"lastUpdated");
    ad.mustAck     = WantBoolFromDic(theDictionary, @"mustAck");
    ad.confidential     = WantBoolFromDic(theDictionary, @"confidential");
    id val;
    if ((val = [theDictionary objectForKey:@"to"])) ad.to = [IBUserInfo objectWithContentsOfDictionary:val];

    return ad;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    PutStringInDic(self.guid, dic, @"guid");
    PutStringInDic(self.status, dic, @"status");
    PutStringInDic(self.progress, dic, @"progress");
    PutStringInDic(self.role, dic, @"role");
    PutDateInDic(self.ackedOn, dic, @"ackedOn");
    PutDateInDic(self.archivedOn, dic, @"archivedOn");
    PutDateInDic(self.lastUpdated, dic, @"lastUpdated");
    PutDateInDic(self.seenOn, dic, @"seenOn");
    PutDateInDic(self.seeBefore, dic, @"seeBefore");
    PutBoolInDic(self.mustAck, dic, @"mustAck");
    PutBoolInDic(self.confidential, dic, @"confidential");
    if (self.to) {
        [dic setObject:[self.to asDictionary] forKey:@"to"];
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