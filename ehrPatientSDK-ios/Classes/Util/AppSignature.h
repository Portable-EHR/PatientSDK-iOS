//
// Created by Yves Le Borgne on 2019-06-18.
// Copyright (c) 2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRNetworkableP.h"

@interface AppSignature : NSObject<EHRInstanceCounterP,EHRPersistableP> {
    NSInteger _instanceNumber;
}

@property (nonatomic) NSDate* installedOn;
@property (nonatomic) NSInteger buildNumber;



@end