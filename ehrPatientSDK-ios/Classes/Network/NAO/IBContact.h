//
// Created by Yves Le Borgne on 2015-10-07.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRNetworkableP.h"

@interface IBContact : NSObject <EHRInstanceCounterP, EHRNetworkableP> {

    NSInteger _instanceNumber;
}

@property(nonatomic) NSString *name;
@property(nonatomic) NSString *firstName;
@property(nonatomic) NSString *middleName;
@property(nonatomic) NSString *email;
@property (nonatomic) NSString *alternateEmail;
@property(nonatomic) NSString *dayPhone;
@property(nonatomic) NSString *mobilePhone;
@property (nonatomic) NSString *salutation;
@property (nonatomic) NSString *professionalSalutations;
@property (nonatomic) NSString *professionalDesignation;
@property (nonatomic) NSString *titles;
@property (nonatomic) NSString *guid;
@property (nonatomic) NSDate *lastUpdated;


@property (nonatomic, readonly) NSString* fullName;

@end