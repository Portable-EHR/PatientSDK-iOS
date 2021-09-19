//
// Created by Yves Le Borgne on 2016-03-23.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "EHRPersistableP.h"
#import "EHRInstanceCounterP.h"
#import "IBLabResult.h"
#import "IBLab.h"
#import "IBPractitioner.h"
#import "IBLabResultTextDocument.h"
#import "IBLabResultPDFDocument.h"
#import "GEMacros.h"

@implementation IBLabResult

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
    IBLabResult *ad = [[IBLabResult alloc] init];
    ad.guid          = WantStringFromDic(theDictionary,@"guid");
    ad.requestStatus = WantStringFromDic(theDictionary, @"requestStatus");
    ad.createdOn     = WantDateFromDic(theDictionary, @"createdOn");
    ad.resultDate     = WantDateFromDic(theDictionary, @"resultDate");
    ad.lastUpdated   = WantDateFromDic(theDictionary, @"resultDate");
    ad.labRequestEid = WantStringFromDic(theDictionary, @"labRequestEid");
    ad.labResultEid = WantStringFromDic(theDictionary, @"labResultEid");
    id val = [theDictionary objectForKey:@"practitioner"];
    if (val) ad.practitioner = [IBPractitioner objectWithContentsOfDictionary:val];
    val = [theDictionary objectForKey:@"lab"];
    if (val) ad.lab = [IBLab objectWithContentsOfDictionary:val];
    val = [theDictionary objectForKey:@"text"];
    if (val) {
        ad->_text = [IBLabResultTextDocument objectWithContentsOfDictionary:val];
    }

    val = [theDictionary objectForKey:@"pdf"];
       if (val) {
           ad->_pdf = [IBLabResultPDFDocument objectWithContentsOfDictionary:val];
       }

    return ad;
}

- (NSDictionary *)asDictionary {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    PutStringInDic(self.guid, dic,@"guid");
    PutStringInDic(self.labRequestEid, dic, @"labRequestEid");
    PutStringInDic(self.labResultEid, dic, @"labResultEid");
    PutStringInDic(self.requestStatus, dic, @"requestStatus");
    PutDateInDic(self.createdOn, dic, @"createdOn");
    PutDateInDic(self.resultDate, dic, @"resultDate");
    PutDateInDic(self.lastUpdated, dic, @"lastUpdated");
    if (self.practitioner) [dic setObject:[self.practitioner asDictionary] forKey:@"practitioner"];
    if (self.lab) [dic setObject:[self.lab asDictionary] forKey:@"lab"];
    if (self.text) [dic setObject:[self.text asDictionary] forKey:@"text"];
    if (self.pdf) [dic setObject:[self.pdf asDictionary] forKey:@"pdf"];

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
