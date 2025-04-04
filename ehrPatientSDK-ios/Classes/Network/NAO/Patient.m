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
        self.responders          = [NSMutableArray array];
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

+ (instancetype)patientOne {
    Patient *patient = [[self alloc] init];
    patient.firstName = @"Test";
    patient.name = @"Johnson";
    patient.guid = @"12345678-e89b-12d3-a456-426614174001";
    patient.gender = @"F";
    patient.dateOfBirth = [NSDate dateWithTimeIntervalSince1970:315532800]; // 1980-01-01
    patient.lastUpdated = [NSDate date]; // Current date
    
    IBContact *contact = [[IBContact alloc] init];
    contact.firstName = @"Test";
    contact.name = @"Johnson";
    contact.guid = @"130d4920-b582-4573-9077-d4355f15980f";
    contact.email = @"alice.johnson@mailinator.com";
    contact.mobilePhone = @"+1 514-219-1111";
    patient.contact = contact;
    
    return patient;
}

+ (instancetype)patientTwo {
    Patient *patient = [[self alloc] init];
    patient.firstName = @"Bob";
    patient.name = @"Smith";
    patient.guid = @"123e4567-e89b-12d3-a456-426614174002";
    patient.gender = @"M";
    patient.dateOfBirth = [NSDate dateWithTimeIntervalSince1970:631152000]; // 1990-01-01
    patient.lastUpdated = [NSDate date]; // Current date
    
    IBContact *contact = [[IBContact alloc] init];
    contact.firstName = @"Bob";
    contact.name = @"Smith";
    contact.guid = @"230d4920-b582-4573-9077-d4355f15980f";
    contact.email = @"bob.smith@mailinator.com";
    contact.mobilePhone = @"+1 514-219-2222";
    patient.contact = contact;
    
    return patient;
}

+ (instancetype)patientThree {
    Patient *patient = [[self alloc] init];
    patient.firstName = @"Charlie";
    patient.name = @"Davis";
    patient.guid = @"123e4567-e89b-12d3-a456-426614174003";
    patient.gender = @"M";
    patient.dateOfBirth = [NSDate dateWithTimeIntervalSince1970:946684800]; // 2000-01-01
    patient.lastUpdated = [NSDate date]; // Current date
    
    IBContact *contact = [[IBContact alloc] init];
    contact.firstName = @"Charlie";
    contact.name = @"Davis";
    contact.guid = @"330d4920-b582-4573-9077-d4355f15980f";
    contact.email = @"charlie.davis@mailinator.com";
    contact.mobilePhone = @"+1 514-219-3333";
    patient.contact = contact;
    
    
    return patient;
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
    pa.unreadNotifications = WantIntegerFromDic(dic, @"unreadNotifications");
    
    if ((val = dic[@"responders"])) {
        for (NSDictionary *resAsdIC in val) {
            IBResponder *res = [IBResponder objectWithContentsOfDictionary:resAsdIC];
            [pa.responders addObject:res];
        }
    }
    
//    if ((val = [dic objectForKey:@"responders"])) pa.responder = [IBResponder objectWithContentsOfDictionary:val];
    
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
    PutIntegerInDic(self.unreadNotifications, dic, @"unreadNotifications");
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
