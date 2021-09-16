//
// Created by Yves Le Borgne on 2017-09-23.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"

static NSString *PATIENT_IOS_1_0_0_GUID = @"dc7507b4-53a3-4a05-bc63-4a36f90acab3";

@protocol EHRNetworkableP;

@interface IBEula : NSObject<EHRInstanceCounterP, EHRPersistableP> {
    NSInteger _instanceNumber;
}
@property (nonatomic) NSString * renderer;
@property (nonatomic) NSDate *createdOn;
@property (nonatomic) NSDate *lastUpdated;
@property (nonatomic) Version *version;
@property (nonatomic) NSString *guid;
@property (nonatomic) NSString *objectGuid;
@property (nonatomic) NSString *text;
@property (nonatomic) NSString *scope;
@property (nonatomic) NSString *type;


@end