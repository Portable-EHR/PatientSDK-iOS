//
// Created by Yves Le Borgne on 2015-10-01.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"

@class EHRRequestStatus;

@interface EHRServerResponse : NSObject <EHRInstanceCounterP, EHRPersistableP> {
    NSInteger _instanceNumber;
}

@property EHRRequestStatus *requestStatus;
@property NSDictionary *responseContent;

@end