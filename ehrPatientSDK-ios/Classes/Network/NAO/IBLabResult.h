//
// Created by Yves Le Borgne on 2016-03-23.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EHRPersistableP;
@protocol EHRInstanceCounterP;
@class IBLab;
@class IBPractitioner;
@class IBLabResultTextDocument;
@class IBLabResultPDFDocument;

@interface IBLabResult : NSObject <EHRInstanceCounterP, EHRPersistableP> {
    NSInteger _instanceNumber;

}

@property(nonatomic) IBLab                   *lab;
@property(nonatomic) NSString                *guid;
@property(nonatomic) IBPractitioner          *practitioner;
@property(nonatomic) NSString                *labRequestEid;
@property(nonatomic) NSString                *labResultEid;
@property(nonatomic) NSDate                  *createdOn;
@property(nonatomic) NSDate                  *resultDate;
@property(nonatomic) NSDate                  *lastUpdated;
@property(nonatomic) NSString                *requestStatus;
@property(nonatomic) IBLabResultTextDocument *text;
@property(nonatomic) IBLabResultPDFDocument  *pdf;

@end