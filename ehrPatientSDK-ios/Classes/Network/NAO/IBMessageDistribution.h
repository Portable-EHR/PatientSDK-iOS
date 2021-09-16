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
@class IBContact;
@class IBUserInfo;

@interface IBMessageDistribution : NSObject <EHRInstanceCounterP, EHRPersistableP> {
    NSInteger _instanceNumber;

}

@property(nonatomic) NSString   *role;
@property(nonatomic) IBUserInfo *to;
@property(nonatomic) NSString   *guid;
@property(nonatomic) NSString   *progress;
@property(nonatomic) NSString   *status; // correponds to MessageDistributionProgressEnum
@property(nonatomic) BOOL       mustAck;
@property(nonatomic) BOOL       confidential;
@property(nonatomic) NSDate     *seeBefore;
@property(nonatomic) NSDate     *seenOn;
@property(nonatomic) NSDate     *ackedOn;
@property(nonatomic) NSDate     *archivedOn;
@property(nonatomic) NSDate     *lastUpdated;

// helper not-persisted props

@property(nonatomic) BOOL isSeen;
@property(nonatomic) BOOL isLateSeing;
@property(nonatomic) BOOL isAcked;
@property(nonatomic) BOOL isArchived;
@property(nonatomic) BOOL shouldAck;
@property(nonatomic) BOOL hasDeadline;

@end