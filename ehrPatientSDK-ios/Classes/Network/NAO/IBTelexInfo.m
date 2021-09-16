//
// Created by Yves Le Borgne on 2016-03-24.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "IBTelexInfo.h"

@implementation IBTelexInfo
TRACE_OFF

@dynamic isAcknowledged;

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
    IBTelexInfo *ad = [[IBTelexInfo alloc] init];
    ad.guid           = WantStringFromDic(theDictionary, @"guid");
    ad.source         = WantStringFromDic(theDictionary, @"source");
    ad.createdOn      = WantDateFromDic(theDictionary, @"createdOn");
    ad.seenOn         = WantDateFromDic(theDictionary, @"seenOn");
    ad.acknowledgedOn = WantDateFromDic(theDictionary, @"acknowledgedOn");

    return ad;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    PutStringInDic(self.guid, dic, @"guid");
    PutStringInDic(self.source, dic, @"source");
    PutDateInDic(self.createdOn, dic, @"createdOn");
    PutDateInDic(self.acknowledgedOn, dic, @"acknowledgedOn");
    PutDateInDic(self.seenOn, dic, @"seenOn");

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

#pragma mark getters

#pragma mark private methods

-(BOOL)isAcknowledged {
    return nil != self.acknowledgedOn;
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}
@end