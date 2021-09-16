//
// Created by Yves Le Borgne on 2019-09-01.
// Copyright (c) 2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EHRNetworkableP;
@protocol EHRInstanceCounterP;
@class IBUserInfo;
@class IBPatientInfo;
@class IBPractitioner;
@class IBDispensaryInfo;

@interface IBAppointment : NSObject < EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
}

@property(nonatomic) NSString         *withPersonNamed;
@property(nonatomic) NSString         *desc; // fucking apple, this is 'description'
@property(nonatomic) NSString         *guid;
@property(nonatomic) NSString         *state;
@property(nonatomic) NSString         *location;
@property(nonatomic) IBUserInfo       *confirmedBy;
@property(nonatomic) IBUserInfo       *cancelledBy;
@property(nonatomic) NSDate           *startTime;
@property(nonatomic) NSDate           *endTime;
@property(nonatomic) NSDate           *createdOn;
@property(nonatomic) NSDate           *lastUpdated;
@property(nonatomic) NSDate           *confirmedOn;
@property(nonatomic) NSDate           *cancelledOn;
@property(nonatomic) NSString         *confirmationStatus;
@property(nonatomic) NSDate           *confirmBefore;
@property(nonatomic) NSDate           *remindOn;
@property(nonatomic) NSDate           *sendSMSon;
@property(nonatomic) NSDate           *smsSentOn;
@property(nonatomic) BOOL             cancelFeesApply;
@property(nonatomic) BOOL             patientMustConfirm;
@property(nonatomic) BOOL             patientCanCancel;
@property(nonatomic) IBPatientInfo    *patientInfo;
@property(nonatomic) IBPractitioner   *practitioner;
@property(nonatomic) IBDispensaryInfo *dispensaryInfo;

- (long)getSortOrder;
- (BOOL)isInThePast;
- (BOOL)isInPlay;
- (BOOL)isPending;
- (BOOL)isConfirmed;
- (BOOL)isCancelled;
- (BOOL)isRemindable;
- (BOOL)isResolved;
- (BOOL)areCancelFeesInPlay;
- (BOOL)isActionRequired;
- (void)updateWith:(IBAppointment *)other;

@end