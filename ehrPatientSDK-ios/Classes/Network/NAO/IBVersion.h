//
// Created by Yves Le Borgne on 2017-04-12.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRNetworkableP.h"
#import "EHRInstanceCounterP.h"

@interface IBVersion : NSObject  <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
}

+(instancetype) versionWithString:(NSString *) versionAsString;
@property (nonatomic) NSInteger major;
@property (nonatomic) NSInteger minor;
@property (nonatomic) NSInteger build;

@end