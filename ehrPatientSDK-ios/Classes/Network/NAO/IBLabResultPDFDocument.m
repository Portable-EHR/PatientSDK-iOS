//
// Created by Yves Le Borgne on 2016-03-23.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "IBLabResultPDFDocument.h"
#import "IBMedia.h"
#import "GERuntimeConstants.h"

@implementation IBLabResultPDFDocument

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
    IBLabResultPDFDocument *ad = [[IBLabResultPDFDocument alloc] init];
    ad.documentDate   = WantDateFromDic(theDictionary, @"documentDate");
    ad.seq=WantIntegerFromDic(theDictionary,@"seq");
    id val;
    if ((val = [theDictionary objectForKey:@"media"])){
        ad.media=[IBMedia objectWithContentsOfDictionary:val];
    }
    return ad;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    PutDateInDic(self.documentDate,dic,@"documentDate");
    PutIntegerInDic(self.seq,dic,@"seq");
    if (self.media) {
        [dic setObject:[self.media asDictionary] forKey:@"media"];
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