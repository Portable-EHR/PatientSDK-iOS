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

@interface PatientInfo : NSObject <EHRInstanceCounterP, EHRPersistableP> {
    NSInteger _instanceNumber;
}

@property(nonatomic) NSDate   *dateOfBirth;
@property(nonatomic) NSDate   *dateRegistered;
@property(nonatomic) NSString *gender;
@property(nonatomic) HCIN     *HCIN;
@property(nonatomic) PIN      *PIN;
@property(nonatomic) SIN      *SIN;

@end