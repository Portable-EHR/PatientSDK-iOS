//
// Created by Yves Le Borgne on 2016-03-23.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "EHRInstanceCounterP.h"

@class IBAddress;

@interface IBLab : NSObject  <EHRInstanceCounterP,EHRPersistableP> {
    NSInteger _instanceNumber;

}
@property (nonatomic) IBAddress *address;
@property (nonatomic) NSString *guid;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *dayPhone;
@end