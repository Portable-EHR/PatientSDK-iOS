//
// Created by Yves Le Borgne on 2015-10-22.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "EHRInstanceCounterP.h"

@class HCIN;
@class PIN;
@class SIN;
@class IBContact;
@class IBAddress;

@interface IBPatientInfo : NSObject <EHRInstanceCounterP, EHRPersistableP> {
    NSInteger _instanceNumber;
}

@property(nonatomic) NSString  *guid;
@property(nonatomic) NSString  *name;
@property(nonatomic) NSString  *gender;
@property(nonatomic) NSString  *firstName;
@property(nonatomic) NSString  *middleName;
@property(nonatomic) NSDate    *dateOfBirth;
@property(nonatomic) NSDate    *dateOfDeath;
@property(nonatomic) IBContact   *contact;
@property(nonatomic) IBAddress *address;
@property(nonatomic) BOOL      reachable;
@property(nonatomic) BOOL      discoveryEnabled;

@end