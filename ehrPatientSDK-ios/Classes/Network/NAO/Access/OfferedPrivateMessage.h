//
// Created by Yves Le Borgne on 2020-03-06.
// Copyright (c) 2020 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRLibRuntimeGlobals.h"
#import "GERuntimeConstants.h"
#import "EHRNetworkableP.h"
#import "EHRInstanceCounterP.h"
#import "IBConsent.h"

@class IBTelexInfo;
@class IBTelex;
@class IBConsent;

@interface OfferedPrivateMessage : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
}
@property (nonatomic) IBTelexInfo *privateMessageInfo;
@property (nonatomic) IBTelex *privateMessage;
    @property (nonatomic) IBConsent *consent;
@end