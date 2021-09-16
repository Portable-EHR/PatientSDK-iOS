//
// Created by Yves Le Borgne on 2017-01-24.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRNetworkableP.h"
#import "EHRInstanceCounterP.h"

@interface MessagesModel : NSObject <EHRNetworkableP, EHRInstanceCounterP> {
    NSInteger _instanceNumber;
}
@end