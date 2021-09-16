//
// Created by Yves Le Borgne on 2020-03-06.
// Copyright (c) 2020 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EHRNetworkableP;
@protocol EHRInstanceCounterP;
@class AccessOffer;
@class AccessRequest;

@interface AccessState : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
}
@property (nonatomic) AccessOffer *offer;
@property(nonatomic) AccessRequest *request;

@end