//
// Created by Yves Le Borgne on 2020-03-06.
// Copyright (c) 2020 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRNetworkableP.h"

@class IBUserInfo;

@interface AccessOffer  : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
}
@property (nonatomic) NSString *guid;
@property(nonatomic) NSString *requestGuid;
@property (nonatomic) IBUserInfo *offeredBy;
@property (nonatomic) IBUserInfo *offeredTo;
@property (nonatomic) NSString *fulfillmentMethod;
@property (nonatomic) NSString *fulfillmentState;
@property (nonatomic) NSDate *offeredOn;
@property (nonatomic) NSDate *seenOn;
@property (nonatomic) NSDate *expiresOn;
@property (nonatomic) NSDate *until;
@property (nonatomic) BOOL persist;
@property (nonatomic) NSString *resourceGuid;
@property (nonatomic) NSString *resourceKind;
@property (nonatomic) NSString *qrCode;

@end
