//
// Created by Yves Le Borgne on 2016-03-23.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "IBLabRequestPDFDocument.h"
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "IBLabRequest.h"
#import "IBLab.h"
#import "IBPractitioner.h"
#import "IBLabRequestTextDocument.h"
#import "GERuntimeConstants.h"

@implementation IBLabRequest

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
    IBLabRequest *ad = [[IBLabRequest alloc] init];
    ad.guid           = WantStringFromDic(theDictionary,@"guid");
    ad.instructions   = WantStringFromDic(theDictionary, @"instructions");
    ad.prescriberNote = WantStringFromDic(theDictionary, @"prescriberNote");
    ad.requestEid     = WantStringFromDic(theDictionary, @"labRequestEid");
    ad.status         = WantStringFromDic(theDictionary, @"status");
    ad.createdOn      = WantDateFromDic(theDictionary, @"createdOn");
    ad.requestDate    = WantDateFromDic(theDictionary, @"requestDate");
    ad.lastUpdated    = WantDateFromDic(theDictionary, @"lastUpdated");
    id val = [theDictionary objectForKey:@"practitioner"];
    if (val) ad.practitioner = [IBPractitioner objectWithContentsOfDictionary:val];
    val = [theDictionary objectForKey:@"lab"];
    if (val) ad.lab = [IBLab objectWithContentsOfDictionary:val];
    val = [theDictionary objectForKey:@"text"];
    if (val) {
        ad.text = [IBLabRequestTextDocument objectWithContentsOfDictionary:val];
    }
    val = [theDictionary objectForKey:@"pdf"];
    if (val) {
        ad.pdf = [IBLabRequestPDFDocument objectWithContentsOfDictionary:val];
    }
    return ad;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    PutStringInDic(self.guid, dic,@"guid");
    PutStringInDic(self.instructions, dic, @"instructions");
    PutStringInDic(self.prescriberNote, dic, @"prescriberNote");
    PutStringInDic(self.requestEid, dic, @"labRequestEid");
    PutStringInDic(self.status, dic, @"status");
    PutDateInDic(self.createdOn, dic, @"createdOn");
    PutDateInDic(self.requestDate, dic, @"requestDate");
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