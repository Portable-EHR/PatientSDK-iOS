//
// Created by Yves Le Borgne on 2015-11-17.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRNetworkableP.h"

@class NotificationsModelFilter;
@class PatientModel;
@class IBContact;
@class IBAddress;

@interface IBDispensaryInfo : NSObject <EHRInstanceCounterP, EHRNetworkableP, EHRPersistableP> {
    NSInteger _instanceNumber;
    NSString  *_name;
    NSString *_shortName;
    NSString  *_guid;
    IBAddress *_address;
    NSDate *_lastUpdated;
}

@property (nonatomic) IBContact *contact;
@property (nonatomic) NSString *guid;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *shortName;
@property (nonatomic) IBAddress *address;
@property (nonatomic) NSDate *lastUpdated;


@end
