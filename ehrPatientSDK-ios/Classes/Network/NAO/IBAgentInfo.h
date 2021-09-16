//
// Created by Yves Le Borgne on 2017-08-22.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRNetworkableP.h"
#import "EHRInstanceCounterP.h"

@class IBAddress;
@class IBContact;
@class IBMediaInfo;

@interface IBAgentInfo : NSObject <EHRInstanceCounterP, EHRPersistableP>{
    NSInteger _instanceNumber;
}

@property (nonatomic) IBAddress *address;
@property (nonatomic) IBContact *contact;
@property (nonatomic) NSString *guid;
@property (nonatomic) NSString *alias;
@property (nonatomic) NSDate *lastUpdated;
@property (nonatomic) NSDate *createdOn;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *agentDescription;
@property (nonatomic) BOOL active;
@property (nonatomic) NSString *infoUrl;
@property (nonatomic) IBMediaInfo *logo;


@end