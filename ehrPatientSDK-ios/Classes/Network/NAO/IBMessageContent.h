//
// Created by Yves Le Borgne on 2016-03-23.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EHRPersistableP;
@protocol EHRInstanceCounterP;
@class IBMessageDistribution;
@class IBContact;
@class IBUser;
@class IBPatientInfo;

@interface IBMessageContent : NSObject <EHRInstanceCounterP, EHRPersistableP> {
    NSInteger _instanceNumber;

}

@property(nonatomic) NSString       *guid;
@property(nonatomic) NSString       *subject;
@property(nonatomic) NSString       *text;
@property(nonatomic) IBContact        *from;
@property(nonatomic) NSString       *status; // correponds to MessageDistributionProgressEnum
@property(nonatomic) BOOL           mustAck;
@property(nonatomic) BOOL           confidential;
@property(nonatomic) NSDate         *lastUpdated;
@property(nonatomic) NSDate         *createdOn;
@property(nonatomic) BOOL           hidden;
@property(nonatomic) IBPatientInfo  *patient;
@property(nonatomic) NSMutableArray *distribution;
@property(nonatomic) NSMutableArray *attachments;

// helper methods

- (IBMessageDistribution *)messageDistributionForUser:(IBUser *)user;
- (NSArray *)getTOs;
- (NSArray *)getCCs;

- (BOOL)shouldAck;
- (BOOL)shouldSee;
-(BOOL) lateSeeing;

@end