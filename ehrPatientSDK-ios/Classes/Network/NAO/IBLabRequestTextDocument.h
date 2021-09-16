//
// Created by Yves Le Borgne on 2016-03-23.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EHRPersistableP;
@protocol EHRInstanceCounterP;
@class IBMedia;

@interface IBLabRequestTextDocument : NSObject <EHRInstanceCounterP,EHRPersistableP> {
    NSInteger _instanceNumber;

}

@property (nonatomic) NSDate *documentDate;
@property (nonatomic) NSInteger seq;
@property (nonatomic) IBMedia *media;

@end