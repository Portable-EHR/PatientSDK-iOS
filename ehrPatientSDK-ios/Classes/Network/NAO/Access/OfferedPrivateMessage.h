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
#import "IBPrivateMessageInfo.h"
#import "IBPrivateMessage.h"

@class IBTelexInfo;
@class IBTelex;
@class IBConsent;

@interface OfferedPrivateMessage : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
}
@property (nonatomic) IBPrivateMessageInfo *privateMessageInfo;
@property (nonatomic) IBPrivateMessage *privateMessage;
    @property (nonatomic) IBConsent *consent;
@end
