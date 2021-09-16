//
// Created by Yves Le Borgne on 2017-11-11.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"

@class IBPractitionerJurisdiction;

@interface IBPractitionerPractice : NSObject <EHRPersistableP,EHRInstanceCounterP> {
    NSInteger _instanceNumber;

}

@property (nonatomic) NSString * practiceNumber;
@property (nonatomic) IBPractitionerJurisdiction * jurisdiction;

@end