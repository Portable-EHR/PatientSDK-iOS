//
// Created by Yves Le Borgne on 2016-03-24.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "EHRInstanceCounterP.h"

@interface IBTelexInfo : NSObject <EHRInstanceCounterP,EHRPersistableP> {
    NSInteger _instanceNumber;
}

@property (nonatomic) NSString *guid;
@property (nonatomic) NSString *source;
@property (nonatomic) NSDate *createdOn;
@property (nonatomic) NSDate *seenOn;
@property (nonatomic) NSString *author;
@property (nonatomic) NSDate *acknowledgedOn;

@property (readonly) BOOL isAcknowledged;

@property (readonly) NSString* getAuthor;


@end
