//
// Created by Yves Le Borgne on 2017-08-11.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRNetworkableP.h"
#import "EHRInstanceCounterP.h"

@class IBContact;
@class IBService;

@interface IBHealthCareProvider :  NSObject <EHRInstanceCounterP,  EHRPersistableP> {
    NSInteger _instanceNumber;
}

@property (nonatomic) NSString *guid;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *alias;
@property (nonatomic) NSString *providerDescription;
@property (nonatomic) NSString *providerName;
@property (nonatomic) IBContact *adminContact;
@property (nonatomic) IBContact *techContact;
@property (nonatomic) BOOL active;
@property (nonatomic) NSDate *lastUpdated;
@property (nonatomic) NSDate *createdOn;
@property (nonatomic) NSArray *serviceGuids;
@property (nonatomic) NSString *infoUrl;
@property(nonatomic) NSString *logoMediaGuid;


@end
