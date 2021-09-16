//
// Created by Yves Le Borgne on 2015-10-01.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"

@interface EHRRequestStatus : NSObject <EHRInstanceCounterP, EHRPersistableP> {

    NSInteger _instanceNumber;

}

@property NSString *route;
@property NSString *command;
@property NSString *apiVersion;
@property NSString *status;
@property NSString *message;

@end