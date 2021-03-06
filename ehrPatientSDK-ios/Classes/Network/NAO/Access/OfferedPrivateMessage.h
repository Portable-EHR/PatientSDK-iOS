//
// Created by Yves Le Borgne on 2020-03-06.
// Copyright (c) 2020 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRNetworkableP.h"
#import "EHRInstanceCounterP.h"

@class IBTelexInfo;
@class IBTelex;

@interface OfferedPrivateMessage : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
}
@property (nonatomic) IBTelexInfo *privateMessageInfo;
@property (nonatomic) IBTelex *privateMessage;
@end