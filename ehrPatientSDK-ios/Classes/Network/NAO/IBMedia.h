//
// Created by Yves Le Borgne on 2016-03-24.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "EHRInstanceCounterP.h"

@interface IBMedia : NSObject <EHRInstanceCounterP,EHRPersistableP> {
    NSInteger _instanceNumber;
    NSString *_text;

}

@property (nonatomic) NSString *guid;
@property (nonatomic) NSString *fileName;
@property (nonatomic) NSString *mediaType;
@property (nonatomic) NSString *mediaLocation;
@property (nonatomic) NSString *content;
@property (nonatomic, readonly) NSString *text;

@end