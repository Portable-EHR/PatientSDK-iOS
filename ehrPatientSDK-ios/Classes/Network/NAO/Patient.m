//
// Created by Yves Le Borgne on 2015-10-22.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "Patient.h"
#import "IBContact.h"
#import "IBAddress.h"

@implementation Patient

TRACE_OFF

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

+(instancetype) YLB{
    Patient *ylb = [[self alloc] init];
    ylb.firstName=@"Yves";
    ylb.name=@"CTO";
    ylb.guid=@"patientYLBpatientGuid";
    ylb.gender=@"M";
    return ylb;
}


+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    id      val = nil;
    Patient *pa = [[self alloc] init];
    pa.name      = WantStringFromDic(dic, @"name");
    pa.firstName = WantStringFromDic(dic, @"firstName");
    pa.gender = WantStringFromDic(dic, @"gender");
    pa.guid   = WantStringFromDic(dic, @"guid");
    pa.dateOfBirth= WantDateFromDic(dic, @"dateOfBirth");
    pa.dateOfDeath= WantDateFromDic(dic, @"dateOfDeath");
    if ((val = [dic objectForKey:@"contact"])) pa.contact = [IBContact objectWithContentsOfDictionary:val];
    if ((val = [dic objectForKey:@"address"])) pa.address = [IBAddress objectWithContentsOfDictionary:val];
    pa.dateRegistered = WantDateFromDic(dic, @"dateRegistered");
    pa.lastUpdated    = WantDateFromDic(dic, @"lastUpdated");
    return pa;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.guid, dic, @"guid");
    PutStringInDic(self.name, dic, @"name");
    PutStringInDic(self.firstName, dic, @"firstName");
    PutStringInDic(self.gender, dic, @"gender");
    if (self.contact) [dic setObject:[self.contact asDictionary] forKey:@"contact"];
    if (self.address) [dic setObject:[self.address asDictionary] forKey:@"address"];
    PutDateInDic(self.dateOfDeath, dic, @"dateOfDeath");
    PutDateInDic(self.dateOfBirth, dic, @"dateOfBirth");
    PutDateInDic(self.dateRegistered, dic, @"dateRegistered");
    PutDateInDic(self.lastUpdated, dic, @"lastUpdated");
    return dic;
}

- (NSString *)asJSON {
    return [[self asDictionary] asJSON];
}

- (NSData *)asJSONdata {
    return [[self asDictionary] asJSONdata];
}

+ (instancetype)objectWithJSONdata:(NSData *)jsonData {
    NSDictionary *dic = [NSDictionary dictionaryWithJSONdata:jsonData];
    return [self objectWithContentsOfDictionary:dic];
}

+ (instancetype)objectWithJSON:(NSString *)jsonString {
    NSDictionary *dic = [NSDictionary dictionaryWithJSON:jsonString];
    return [self objectWithContentsOfDictionary:dic];
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end
