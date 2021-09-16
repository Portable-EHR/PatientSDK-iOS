//
// Created by Yves Le Borgne on 2016-03-24.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "EHRInstanceCounterP.h"

@interface IBTelex : NSObject <EHRInstanceCounterP,EHRPersistableP> {
    NSInteger _instanceNumber;
}

@property (nonatomic) NSString *subject;
@property (nonatomic) NSString *from;
@property (nonatomic) NSString *patient;
@property (nonatomic) NSString *to;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSString *message;
@property (nonatomic) NSString *source;
@property (nonatomic) NSData *pdf;
@property (nonatomic) NSString *documentType;
@property (nonatomic) NSString *documentName;


@end