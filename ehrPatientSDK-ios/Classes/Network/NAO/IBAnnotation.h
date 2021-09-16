//
// Created by Yves Le Borgne on 2016-03-08.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"

@class IBPractitioner;
@class IBLabRequest;
@class IBLabResult;

// Inbound annotation, faces the OBAnnotation, server side

@interface IBAnnotation : NSObject <EHRInstanceCounterP,EHRPersistableP> {
    NSInteger _instanceNumber;

}

@property(nonatomic) NSString       *guid;
@property(nonatomic) NSString       *text;
@property(nonatomic) IBPractitioner *practitioner;
@property(nonatomic) NSDate         *createdOn;
@property(nonatomic) NSDate         *sentOn;
@property(nonatomic) NSDate         *seenOn;
@property(nonatomic) BOOL           private;
@property (nonatomic) IBLabRequest *labRequest;
@property (nonatomic) IBLabResult * labResult;
@end