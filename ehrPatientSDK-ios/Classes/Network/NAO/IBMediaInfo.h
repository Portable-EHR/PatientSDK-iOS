//
// Created by Yves Le Borgne on 2017-08-22.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"

@interface IBMediaInfo : NSObject <EHRInstanceCounterP, EHRPersistableP> {
    NSInteger _instanceNumber;
}
@property (nonatomic) NSString *guid;
@end