//
// Created by Yves Le Borgne on 2015-10-07.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRNetworkableP.h"

@interface IBAddress : NSObject<EHRInstanceCounterP,EHRNetworkableP> {
    NSInteger _instanceNumber;
}

@property (nonatomic) NSString* street1;
@property (nonatomic) NSString* street2;
@property (nonatomic) NSString* city;
@property (nonatomic) NSString* state;
@property (nonatomic) NSString* zip;
@property (nonatomic) NSString* country;



@end