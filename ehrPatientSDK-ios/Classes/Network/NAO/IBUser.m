//
// Created by Yves Le Borgne on 2015-10-08.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "IBUser.h"
#import "IBContact.h"
#import "Patient.h"
#import "IBPractitioner.h"
#import "IBHealthCareProvider.h"
#import "IBUserService.h"
#import "IBService.h"
#import "IBUserCapability.h"

@implementation IBUser

TRACE_OFF

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        self.visits              = [NSMutableDictionary dictionary];
        self.proxies             = [NSMutableDictionary dictionary];
        self.practitioners       = [NSMutableDictionary dictionary];
        self.patients            = [NSMutableDictionary dictionary];
        self.userServiceModel    = [NSMutableArray array];
        self.userCapabilityModel = [NSMutableArray array];
        self.forcePasswordChange = NO;
        self->_isPractitioner    = NO;
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

@synthesize isPractitioner = _isPractitioner;
@dynamic isGuest;

#pragma mark - precanned users

+ (IBUser *)guest {
    IBUser *user = [[self alloc] init];
    user.contact           = [[IBContact alloc] init];
    user.contact.name      = @"Visitor";
    user.contact.firstName = @"Distinguished";
    user.apiKey            = @"K7ICfFOwS3ELdHfAzWBhPt";
    user.guid              = @"67b1c035-9d12-4bd6-9f94-df75182da183";
    user.emailVerified     = YES;
    user.deviceMobileVerified    = YES;
    user.deviceEmailVerified    = YES;
    user.role              = @"guest";
    user.status            = @"active";
    user->_isPractitioner  = NO;
    user.forcePasswordChange  = NO;

    return user;
}

+ (IBUser *)ylb {

    IBUser *user = [[self alloc] init];
    user.contact           = [[IBContact alloc] init];
    user.contact.name      = @"Le Borgne";
    user.contact.firstName = @"Yves";
    user.apiKey            = @"patientYLBapiKey";
    user.guid              = @"patientYLBuserGuid";
    user.emailVerified     = YES;
    user.identityVerified  = YES;
    user.mobileVerified    = YES;
    user.forcePasswordChange  = NO;
    user.deviceMobileVerified    = YES;
    user.deviceEmailVerified    = YES;
    user.role              = @"patient";
    user.patient           = [Patient YLB];
    user->_isPractitioner  = NO;
    user.status            = @"active";

    return user;
}

+ (IBUser *)drB {

    IBUser *user = [[self alloc] init];
    user.contact           = [[IBContact alloc] init];
    user.contact.name      = @"Bessette";
    user.contact.firstName = @"Luc";
    user.apiKey            = @"doctorLB";
    user.emailVerified     = YES;
    user.identityVerified  = YES;
    user.forcePasswordChange  = NO;
    user.mobileVerified    = YES;
    user.deviceMobileVerified    = YES;
    user.deviceEmailVerified    = YES;
    user.role              = @"practitioner";
    user->_isPractitioner  = YES;

    return user;
}

+ (IBUser *)userWithServerUserInfo:(NSDictionary *)userInfo __unused {
    return [self objectWithContentsOfDictionary:userInfo];
}

#pragma mark - helpers

- (BOOL)isGuest {
    return [self.apiKey isEqualToString:@"K7ICfFOwS3ELdHfAzWBhPt"];
}

#pragma mark - a getter

- (BOOL)hasService:(IBService *)service {
    return nil != [self userServiceOfService:service];
}

- (IBUserService *)userServiceOfService:(IBService *)service {
    for (IBUserService *userService in _userServiceModel) {
        if ([userService.serviceGuid isEqualToString:service.guid]) return userService;
    }
    return nil;
}

#pragma clang diagnostic push

#pragma ide diagnostic ignored "OCUnusedMethodInspection"

- (IBHealthCareProvider *)providerWithGuid:(NSString *)guid {
    if (self.healthCareProviders.count > 0) return self.healthCareProviders[guid];
    return nil;
}

#pragma clang diagnostic pop

#pragma mark - EHRPersistableP

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    id     val = nil;
    IBUser *us = [[self alloc] init];
    us.apiKey           = WantStringFromDic(dic, @"apiKey");
    us.guid             = WantStringFromDic(dic, @"guid");
    us.status           = WantStringFromDic(dic, @"status");
    us.role             = WantStringFromDic(dic, @"role");
    us.createdOn        = WantDateFromDic(dic, @"createdOn");
    us.emailVerified    = WantBoolFromDic(dic, @"emailVerified");
    us.mobileVerified   = WantBoolFromDic(dic, @"mobileVerified");
    us.identityVerified = WantBoolFromDic(dic, @"identityVerified");
    us.forcePasswordChange = WantBoolFromDic(dic, @"forcePasswordChange");
    us.deviceEmailVerified   = WantBoolFromDic(dic, @"deviceEmailVerified");
    us.deviceMobileVerified   = WantBoolFromDic(dic, @"deviceMobileVerified");

    if ((val = dic[@"contact"])) us.contact = [IBContact objectWithContentsOfDictionary:val];
    if ((val = dic[@"patient"])) us.patient = [Patient objectWithContentsOfDictionary:val];
    if ((val = dic[@"proxies"])) {
        NSMutableDictionary      *s = [NSMutableDictionary dictionary];
        for (NSMutableDictionary *patientAsDic in [val allValues]) {
            Patient *p = [Patient objectWithContentsOfDictionary:patientAsDic];
            s[p.guid] = p;
        }
        us->_proxies = s;
    }

    if ((val = dic[@"visits"])) {
        NSMutableDictionary *s = [NSMutableDictionary dictionary];
        for (NSString       *guid in [val allKeys]) {
            NSDictionary *proxyAsDic = [val objectForKey:guid];
            s[guid] = [Patient objectWithContentsOfDictionary:proxyAsDic];
        }
        us->_visits = s;
    }

    if ((val = dic[@"patients"])) {
        NSMutableDictionary *s = [NSMutableDictionary dictionary];
        for (NSString       *guid in [val allKeys]) {
            NSDictionary *proxyAsDic = [val objectForKey:guid];
            s[guid] = [Patient objectWithContentsOfDictionary:proxyAsDic];
        }
        us->_patients = s;
    }

    if ((val = dic[@"practitioners"])) {
        NSDictionary        *pracs      = val;
        NSMutableDictionary *pracsAsDic = [NSMutableDictionary dictionary];
        for (NSDictionary   *pracAsDic in [pracs allValues]) {
            us->_isPractitioner = YES;
            IBPractitioner *practitioner = [IBPractitioner objectWithContentsOfDictionary:pracAsDic];
            pracsAsDic[practitioner.guid] = practitioner;
        }
        us->_practitioners = pracsAsDic;
    } else {
        us->_isPractitioner = NO;
    }

    if ((val = dic[@"healthCareProviders"])) {
        NSMutableDictionary *s = [NSMutableDictionary dictionary];
        for (NSDictionary   *hcpAsDic in  [val allValues]) {
            IBHealthCareProvider *hcp = [IBHealthCareProvider objectWithContentsOfDictionary:hcpAsDic];
            s[hcp.guid] = hcp;
        }
        us->_healthCareProviders = s;
    }

    if ((val = dic[@"userServiceModel"])) {
        for (NSDictionary *userServiceAsDic in  val) {
            IBUserService *userService = [IBUserService objectWithContentsOfDictionary:userServiceAsDic];
            [us->_userServiceModel addObject:userService];
        }
    }

    if ((val = dic[@"userCapabiityModel"])) {
        for (NSDictionary *userCapabilityAsDic in  val) {
            IBUserCapability *userCapability = [IBUserCapability objectWithContentsOfDictionary:userCapabilityAsDic];
            [us.userCapabilityModel addObject:userCapability];
        }
    }

    return us;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.apiKey) dic[@"apiKey"]   = self.apiKey;
    if (self.guid) dic[@"guid"]       = self.guid;
    if (self.status) dic[@"status"]   = self.status;
    if (self.role) dic[@"role"]       = self.role;
    if (self.contact) dic[@"contact"] = [self.contact asDictionary];
    if (self.patient) dic[@"patient"] = [self.patient asDictionary];
    if (self.proxies.count > 0) {
        NSMutableDictionary *dd = [NSMutableDictionary dictionary];
        for (NSString       *guid in self.proxies.allKeys) {
            Patient *p = self.proxies[guid];
            dd[guid]   = [p asDictionary];
        }
        dic[@"proxies"]         = dd;
    }
    if (self.visits.count > 0) {
        NSMutableDictionary *dd = [NSMutableDictionary dictionary];
        for (NSString       *guid in self.visits.allKeys) {
            Patient *p = self.visits[guid];
            dd[guid]   = [p asDictionary];
        }
        dic[@"visits"]          = dd;
    }

    if (self.patients.count > 0) {
        NSMutableDictionary *dd = [NSMutableDictionary dictionary];
        for (NSString       *guid in self.patients.allKeys) {
            Patient *p = self.patients[guid];
            dd[guid] = [p asDictionary];
        }
        dic[@"patients"]        = dd;
    }

    if (self.practitioners.count > 0) {
        // serialize the pracs of this user (could have more than one)
        NSMutableDictionary *dd = [NSMutableDictionary dictionary];
        for (NSString       *guid in self.practitioners.allKeys) {
            Patient *p = self.practitioners[guid];
            dd[guid] = [p asDictionary];
        }
        dic[@"practitioners"]   = dd;
    }

    if (self.healthCareProviders.count > 0) {
        NSMutableDictionary       *dick = [NSMutableDictionary dictionary];
        for (IBHealthCareProvider *hcp in [self.healthCareProviders allValues]) {
            PutPersistableInDic(hcp, dick, hcp.guid);
        }
        dic[@"healthCareProviders"] = dick;
    }

    if (self.userServiceModel.count > 0) {
        NSMutableArray     *dick = [NSMutableArray array];
        for (IBUserService *hcp in self.userServiceModel) {
            [dick addObject:[hcp asDictionary]];
        }
        dic[@"userServiceModel"] = dick;
    }

    if (self.userCapabilityModel.count > 0) {
        NSMutableArray        *dick = [NSMutableArray array];
        for (IBUserCapability *hcp in self.userCapabilityModel) {
            [dick addObject:[hcp asDictionary]];
        }
        dic[@"userCapabilityModel"] = dick;
    }

    PutDateInDic(self.createdOn, dic, @"createdOn");
    PutBoolInDic(self.emailVerified, dic, @"emailVerified");
    PutBoolInDic(self.mobileVerified, dic, @"mobileVerified");
    PutBoolInDic(self.deviceEmailVerified, dic, @"deviceEmailVerified");
    PutBoolInDic(self.deviceMobileVerified, dic, @"deviceMobileVerified");
    PutBoolInDic(self.identityVerified, dic, @"identityVerified");
    PutBoolInDic(self.forcePasswordChange, dic, @"forcePasswordChange");

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

- (NSString *)getPatientGuid {
    return _patient.guid;
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end
