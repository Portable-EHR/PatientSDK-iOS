//
// Created by Yves Le Borgne on 2015-10-07.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "EHRPersistableP.h"
#import "IBContact.h"

@implementation IBContact

@dynamic fullName;TRACE_OFF

- (instancetype)init {
    if ((self = [super init])) {GE_ALLOC();GE_ALLOC_ECHO();
    } else {
        MPLOG(@"*** super returns nil!");
    }
    return self;
}

#pragma mark - business nethods

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.name];
}

#pragma mark - EHRPersistableP

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)theDictionary {
    IBContact *ad = [[IBContact alloc] init];
    ad.professionalDesignation = WantStringFromDic(theDictionary, @"professionalDesignation");
    ad.professionalSalutations = WantStringFromDic(theDictionary, @"professionalSalutations");
    ad.guid                    = WantStringFromDic(theDictionary, @"guid");
    ad.titles                  = WantStringFromDic(theDictionary, @"titles");
    ad.name                    = WantStringFromDic(theDictionary, @"name");
    ad.firstName               = WantStringFromDic(theDictionary, @"firstName");
    ad.middleName              = WantStringFromDic(theDictionary, @"middleName");
    ad.email                   = WantStringFromDic(theDictionary, @"email");
    ad.alternateEmail          = WantStringFromDic(theDictionary, @"alternateEmail");
    ad.dayPhone                = WantStringFromDic(theDictionary, @"dayPhone");
    ad.mobilePhone             = WantStringFromDic(theDictionary, @"mobilePhone");
    ad.salutation              = WantStringFromDic(theDictionary, @"salutation");

    // added after 1.1.031
    ad.lastUpdated = WantDateFromDic(theDictionary, @"lastUpdated");
    if (nil == ad.lastUpdated) ad.lastUpdated = forever();

    return ad;
}

- (NSDictionary *)asDictionary {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    if (nil == self.lastUpdated) self.lastUpdated = forever(); // forever added in 1.1.031


    PutStringInDic(self.guid, dic, @"guid");
    PutStringInDic(self.name, dic, @"name");
    PutStringInDic(self.firstName, dic, @"firstName");
    PutStringInDic(self.middleName, dic, @"middleName");
    PutStringInDic(self.salutation, dic, @"salutation");
    PutStringInDic(self.professionalSalutations, dic, @"professionalSalutations");
    PutStringInDic(self.titles, dic, @"titles");
    PutStringInDic(self.professionalDesignation, dic, @"professionalDesignation");
    PutStringInDic(self.email, dic, @"email");
    PutStringInDic(self.alternateEmail, dic, @"alternateEmail");
    PutStringInDic(self.dayPhone, dic, @"dayPhone");
    PutStringInDic(self.mobilePhone, dic, @"mobilePhone");
    PutDateInDic(self.lastUpdated, dic, @"lastUpdated");

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
    GE_DEALLOC();GE_DEALLOC_ECHO();
}

@end