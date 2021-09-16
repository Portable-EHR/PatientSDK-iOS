//
// Created by Yves Le Borgne on 2015-10-08.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRNetworkableP.h"
#import "EHRInstanceCounterP.h"

@class IBAddress;
@class IBContact;
@class Patient;
@class UserDeviceSettings;
@class IBHealthCareProvider;
@class IBUserService;
@class IBService;

@interface IBUser : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
    BOOL      _isPractitioner;
}

+ (IBUser *)guest;
+ (IBUser *)ylb;
+ (IBUser *)drB;
+ (IBUser *)userWithServerUserInfo:(NSDictionary *)userInfo;

@property(nonatomic) NSString       *guid;
@property(nonatomic) NSString       *apiKey;
@property(nonatomic) NSString       *status; // todo, these are server side enums
@property(nonatomic) NSString       *role;   // todo, these are server side enums
@property(nonatomic) BOOL           emailVerified;
@property(nonatomic) BOOL           mobileVerified;
@property(nonatomic) BOOL           identityVerified;
@property(nonatomic) IBContact      *contact;
@property(nonatomic) NSDate         *createdOn;
@property(nonatomic) NSDictionary   *visits;
@property(nonatomic) NSDictionary   *proxies;
@property(nonatomic) NSDictionary   *patients;    // only for roles 'practitioner' and 'group'
@property(nonatomic) NSDictionary   *practitioners;
@property(nonatomic) Patient        *patient;
@property(nonatomic) NSDictionary   *healthCareProviders;
@property(nonatomic) NSMutableArray *userServiceModel;
@property(nonatomic) NSMutableArray *userCapabilityModel;
@property(nonatomic) NSMutableArray *userEulaModel;
@property(nonatomic) BOOL           isPractitioner;
@property(nonatomic) BOOL           isGuest;

- (BOOL)hasService:(IBService *)service;
- (IBUserService *)userServiceOfService:(IBService *)service;

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
- (IBHealthCareProvider *)providerWithGuid:(NSString *)guid;
#pragma clang diagnostic pop

@end