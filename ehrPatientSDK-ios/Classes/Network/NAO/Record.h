//
// Created by Yves Le Borgne on 2015-10-28.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRLibRuntimeGlobals.h"
#import "GERuntimeConstants.h"
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"

@interface Record : NSObject <EHRInstanceCounterP, EHRPersistableP> {
    NSInteger _instanceNumber;
}

@property(nonatomic) NSString *guid;
@property(nonatomic) NSString *recordType;
@property(nonatomic) NSString *sourceType;
@property(nonatomic) NSString *sourceGuid;
@property(nonatomic) NSDate   *createdOn;
@property(nonatomic) NSDate   *lastUpdated;
@property(nonatomic) BOOL     private;

@end