//
// Created by Yves Le Borgne on 2017-08-21.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRNetworkableP.h"
#import "EHRInstanceCounterP.h"

@interface IBUserService : NSObject <EHRInstanceCounterP, EHRNetworkableP>{
    NSInteger _instanceNumber;
}
@property (nonatomic) NSString *serviceGuid;
@property (nonatomic) NSString *healthCareProviderGuid;
@property (nonatomic) NSDate *createdOn;
@property (nonatomic) NSDate *lastUpdated;
@property (nonatomic) NSDate *dateEulaAccepted;
@property (nonatomic) NSDate *dateEulaSeen;
@property (nonatomic) NSString *state;

@property (nonatomic, readonly) BOOL isEulaAccepted;
@property (nonatomic, readonly) BOOL isEulaSeen;

@end