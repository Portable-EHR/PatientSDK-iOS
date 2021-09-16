//
// Created by Yves Le Borgne on 2018-09-29.
// Copyright (c) 2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"

@class IBContact;

@interface IBPatientContact : NSObject <EHRInstanceCounterP, EHRPersistableP> {
    NSInteger _instanceNumber;

}

@property(nonatomic) NSString  *type;
@property(nonatomic) BOOL      isEmergency;
@property(nonatomic) IBContact *contact;

@end