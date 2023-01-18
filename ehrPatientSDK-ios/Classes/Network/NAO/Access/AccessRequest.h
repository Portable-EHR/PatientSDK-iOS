//
// Created by Yves Le Borgne on 2020-03-06.
// Copyright (c) 2020 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRNetworkableP.h"
#import "IBUserInfo.h"


@interface AccessRequest : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
}
@property(nonatomic) NSString   *guid;
@property(nonatomic) IBUserInfo *requester;
@property(nonatomic) IBUserInfo *requestee;
@property(nonatomic) NSDate     *expiresOn;
@property(nonatomic) NSDate     *fulfilledOn;
@property(nonatomic) NSDate     *requestedOn;
@property(nonatomic) NSDate     *seenOn;
@property(nonatomic) NSString   *fulfillmentMethod;
@property(nonatomic) NSString   *fulfillmentState;

@end
