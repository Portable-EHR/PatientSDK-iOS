//
// Created by Yves Le Borgne on 2015-10-22.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRLibRuntimeGlobals.h"
#import "GERuntimeConstants.h"
#import "EHRNetworkableP.h"
#import "EHRInstanceCounterP.h"

@class PatientInfo;
@class IBContact;
@class IBAddress;

@interface Patient : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
}

@property(nonatomic) NSString  *guid;
@property(nonatomic) NSString  *name;
@property(nonatomic) NSString  *firstName;
@property(nonatomic) NSDate    *dateOfBirth;
@property(nonatomic) NSDate    *dateOfDeath;
@property(nonatomic) NSString  *gender;
@property(nonatomic) NSDate    *dateRegistered;
@property(nonatomic) NSDate    *lastUpdated;
@property(nonatomic) IBContact   *contact;
@property(nonatomic) IBAddress *address;

+(instancetype) YLB;

@end
