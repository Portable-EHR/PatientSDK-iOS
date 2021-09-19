//
// Created by Yves Le Borgne on 2016-03-08.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "IBAnnotation.h"
#import "IBPractitioner.h"
#import "IBLabRequest.h"
#import "IBLabResult.h"
#import "GEMacros.h"

@implementation IBAnnotation

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
    IBAnnotation *ad = [[IBAnnotation alloc] init];
    ad.guid      = WantStringFromDic(theDictionary,@"guid");
    ad.text      = WantStringFromDic(theDictionary, @"text");
    ad.private   = WantBoolFromDic(theDictionary, @"confidential");
    ad.seenOn    = WantDateFromDic(theDictionary, @"seenOn");
    ad.sentOn    = WantDateFromDic(theDictionary, @"sentOn");
    ad.createdOn = WantDateFromDic(theDictionary, @"createdOn");
    id val = [theDictionary objectForKey:@"practitioner"];
    if (val) ad.practitioner = [IBPractitioner objectWithContentsOfDictionary:val];
    val = [theDictionary objectForKey:@"labRequest"];
    if (val) {
        ad.labRequest = [IBLabRequest objectWithContentsOfDictionary:val];
    }
    val = [theDictionary objectForKey:@"labResult"];
    if (val) ad.labResult = [IBLabResult objectWithContentsOfDictionary:val];

    return ad;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    PutStringInDic(self.guid, dic,@"guid");
    PutStringInDic(self.text, dic, @"text");
    PutBoolInDic(self.private, dic, @"confidential");
    PutDateInDic(self.createdOn, dic, @"createdOn");
    PutDateInDic(self.sentOn, dic, @"sentOn");
    PutDateInDic(self.seenOn, dic, @"seenOn");
    if (self.practitioner) [dic setObject:[self.practitioner asDictionary] forKey:@"practitioner"];
    if (self.labRequest) [dic setObject:[self.labRequest asDictionary] forKey:@"labRequest"];
    if (self.labResult) [dic setObject:[self.labRequest asDictionary] forKey:@"labResult"];
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
