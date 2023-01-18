//
// Created by yvesleborg on 2014-09-03.
//
// // Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "GEMacros.h"

@protocol EHRInstanceCounterP <NSObject>

@optional

+ (NSInteger)numberOfInstances;
- (NSInteger)instanceNumber;

@end
