//
// Created by Yves Le Borgne on 2016-03-23.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EHRPersistableP;
@protocol EHRInstanceCounterP;
@class IBLab;
@class IBPractitioner;
@class IBMedia;
@class IBLabRequestTextDocument;
@class IBLabRequestPDFDocument;

@interface IBLabRequest : NSObject <EHRInstanceCounterP, EHRPersistableP> {
    NSInteger _instanceNumber;

}
@property(nonatomic) IBLab                    *lab;
@property(nonatomic) NSString                 *guid;
@property(nonatomic) IBPractitioner           *practitioner;
@property(nonatomic) NSString                 *instructions;
@property(nonatomic) NSString                 *prescriberNote;
@property(nonatomic) NSDate                   *createdOn;
@property(nonatomic) NSDate                   *requestDate;
@property(nonatomic) NSString                 *status;
@property(nonatomic) NSString                 *requestEid;
@property(nonatomic) NSDate                   *lastUpdated;
@property(nonatomic) IBLabRequestTextDocument *text;
@property(nonatomic) IBLabRequestPDFDocument  *pdf;

@end