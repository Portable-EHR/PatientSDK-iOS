//
// Created by Yves Le Borgne on 2016-03-23.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "IBMessageContent.h"
#import "IBMessageDistribution.h"
#import "IBUser.h"
#import "IBUserInfo.h"
#import "AppState.h"
#import "IBPatientInfo.h"

@implementation IBMessageContent

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

#pragma mark - EHRPersistableP

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)theDictionary {
    IBMessageContent *ad = [[IBMessageContent alloc] init];
    ad.guid         = WantStringFromDic(theDictionary, @"guid");
    ad.subject      = WantStringFromDic(theDictionary, @"subject");
    ad.text         = WantStringFromDic(theDictionary, @"text");
    ad.mustAck      = WantBoolFromDic(theDictionary, @"mustAck");
    ad.confidential      = WantBoolFromDic(theDictionary, @"confidential");
    ad.hidden       = WantBoolFromDic(theDictionary, @"hidden");
    ad.lastUpdated  = WantDateFromDic(theDictionary, @"lastUpdated");
    ad.createdOn    = WantDateFromDic(theDictionary, @"createdOn");
    ad.distribution = [NSMutableArray array];
    id val = [theDictionary objectForKey:@"distribution"];
    if (val) {
        for (NSDictionary *dic in val) {
            [ad.distribution addObject:[IBMessageDistribution objectWithContentsOfDictionary:dic]];
        }
    }

    if ((val = [theDictionary objectForKey:@"patient"])) {
        ad.patient = [IBPatientInfo objectWithContentsOfDictionary:val];
    }

    ad.attachments = [NSMutableArray array];

    return ad;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    PutStringInDic(self.guid, dic, @"guid");
    PutStringInDic(self.subject, dic, @"subject");
    PutStringInDic(self.text, dic, @"text");
    PutBoolInDic(self.mustAck, dic, @"mustAck");
    PutBoolInDic(self.confidential, dic, @"confidential");
    PutBoolInDic(self.hidden, dic, @"hidden");
    PutDateInDic(self.lastUpdated, dic, @"lastUpdated");
    PutDateInDic(self.createdOn, dic, @"createdOn");

    if (self.patient) {
        [dic setObject:[self.patient asDictionary] forKey:@"patient"];
    }

    NSMutableArray             *dist = [NSMutableArray array];
    for (IBMessageDistribution *theDist in self.distribution) {
        [dist addObject:[theDist asDictionary]];
    }

    [dic setObject:dist forKey:@"distribution"];

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

/** helper methods **/

- (NSArray *)getTOs {
    NSMutableArray             *tos = [NSMutableArray array];
    for (IBMessageDistribution *dist in self.distribution) {
        if ([dist.role isEqualToString:@"to"]) {
            [tos addObject:dist];
        }
    }
    return tos;
}

- (NSArray *)getCCs {
    NSMutableArray             *array = [NSMutableArray array];
    for (IBMessageDistribution *dist in self.distribution) {
        if ([dist.role isEqualToString:@"cc"]) [array addObject:dist];
    }
    return array;
}

- (IBMessageDistribution *)messageDistributionForUser:(IBUser *)user {
    for (IBMessageDistribution *dist in self.distribution) {
        if (dist.to) {
            IBUserInfo *to = dist.to;
            if ([to.guid isEqualToString:user.guid]) return dist;
        }
    }
    return nil;
}

- (BOOL)shouldAck {
    IBMessageDistribution *md = [self messageDistributionForUser:[AppState sharedAppState].user];
    if ([md.role isEqualToString:@"to"]) {
        if (md.mustAck && !md.ackedOn) return YES;
    }
    return NO;
}

-(BOOL) lateSeeing{
    IBMessageDistribution *md = [self messageDistributionForUser:[AppState sharedAppState].user];
    if ([md.role isEqualToString:@"to"]) {
        if (md.seeBefore && !md.seenOn) {
            NSDate *now = [NSDate date];
            if ([md.seeBefore timeIntervalSince1970] < [now timeIntervalSince1970]) return YES;
        }
    }
    return NO;
}

- (BOOL)shouldSee {
    IBMessageDistribution *md = [self messageDistributionForUser:[AppState sharedAppState].user];
    if ([md.role isEqualToString:@"to"]) {
        if(!md.seenOn) return YES;

        if (md.seeBefore && !md.seenOn) {
            NSDate *now = [NSDate date];
            if ([md.seeBefore timeIntervalSince1970] < [now timeIntervalSince1970]) return YES;
        }
    }
    return NO;
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}
@end