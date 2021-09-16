//
// Created by Yves Le Borgne on 2017-09-28.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"

@class IBEula;

@interface IBCapability : NSObject <EHRPersistableP, EHRInstanceCounterP> {
    NSInteger _instanceNumber;
}

@property(nonatomic) NSString *serviceGuid;
@property(nonatomic) NSString *guid;
@property(nonatomic) NSString *activationMode;
@property(nonatomic) NSString *scope;
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *alias;
@property(nonatomic) NSString *capabilityDescription;
@property(nonatomic) NSDate   *createdOn;
@property(nonatomic) NSDate   *lastUpdated;
@property(nonatomic) NSString *state;
@property(nonatomic) IBEula   *eula;

@end