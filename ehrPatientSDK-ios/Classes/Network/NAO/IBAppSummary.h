//
// Created by Yves Le Borgne on 2017-09-11.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GERuntimeConstants.h"
#import "EHRLibRuntimeGlobals.h"
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "Version.h"

@class FactorsRequired;

@interface IBAppSummary : NSObject <EHRPersistableP, EHRInstanceCounterP> {
    NSInteger _instanceNumber;
}

@property(nonatomic) NSString        *name;
@property(nonatomic) NSString        *guid;
@property(nonatomic) NSString        *alias;
@property(nonatomic) NSString        *target;
@property(nonatomic) FactorsRequired *factorsRequired;
@property(nonatomic) NSDate          *createdOn;
@property(nonatomic) NSDate          *lastUpdated;
@property(nonatomic) Version         *requiredVersion;
@property(nonatomic) Version         *version;
@property(nonatomic) NSString        *info;
@property(nonatomic) NSString        *agentGuid;
@property(nonatomic) NSDictionary    *jurisdictions;
@property(nonatomic) NSDictionary    *dispensaries;

// non-networked properties, must be force-persisted

@property(nonatomic) NSDate *lastRefreshed;

// method to refresh when pulling from server

- (void)refreshFrom:(IBAppSummary *)other;

@end
