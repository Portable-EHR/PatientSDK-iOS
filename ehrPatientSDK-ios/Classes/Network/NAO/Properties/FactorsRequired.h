//
// Created by Yves Le Borgne on 2018-08-26.
// Copyright (c) 2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"

@interface FactorsRequired : NSObject <EHRPersistableP,EHRInstanceCounterP> {

    NSInteger _instanceNumber;
}

@property (nonatomic) BOOL email;
@property (nonatomic) BOOL emailVerification;
@property (nonatomic) BOOL mobile;
@property (nonatomic) BOOL mobileVerification;
@property (nonatomic) BOOL identityVerification;
@property (nonatomic) BOOL password;
@property (nonatomic) BOOL alias;
@end