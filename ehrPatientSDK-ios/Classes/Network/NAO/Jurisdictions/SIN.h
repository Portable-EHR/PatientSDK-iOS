//
// Created by Yves Le Borgne on 2015-10-26.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "InsuranceNumber.h"

@interface SIN : InsuranceNumber <EHRInstanceCounterP, EHRPersistableP> {
    NSInteger _instanceNumber;
}

@end