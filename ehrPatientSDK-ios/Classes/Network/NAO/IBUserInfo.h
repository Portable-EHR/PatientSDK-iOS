//
// Created by Yves Le Borgne on 2015-10-08.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRNetworkableP.h"
#import "EHRInstanceCounterP.h"

@class IBContact;

@interface IBUserInfo : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
}

@property(nonatomic) NSString *guid;
@property(nonatomic) IBContact  *contact;
@property(nonatomic) NSString *language;
@property(nonatomic) NSString *username;

@end