//
// Created by Yves Le Borgne on 2019-09-01.
// Copyright (c) 2019 Portable EHR inc. All rights reserved.
//

#import "EHRNetworkableP.h"
#import "EHRInstanceCounterP.h"
#import "IBAppointment.h"
#import "IBPatientInfo.h"
#import "IBUserInfo.h"
#import "IBDispensaryInfo.h"
#import "IBPractitioner.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

@implementation IBAppointment
TRACE_OFF

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        MPLOG(@"*** super returns nil!");
    }
    return self;
}

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)theDictionary {
    IBAppointment *ct = [[IBAppointment alloc] init];
    id            val = nil;

    ct.withPersonNamed    = WantStringFromDic(theDictionary, @"withPersonNamed");
    ct.desc               = WantStringFromDic(theDictionary, @"desc");
    ct.guid               = WantStringFromDic(theDictionary, @"guid");
    ct.state              = WantStringFromDic(theDictionary, @"state");
    ct.location           = WantStringFromDic(theDictionary, @"location");
    ct.createdOn          = WantDateFromDic(theDictionary, @"createdOn");
    ct.lastUpdated        = WantDateFromDic(theDictionary, @"lastUpdated");
    ct.startTime          = WantDateFromDic(theDictionary, @"startTime");
    ct.endTime            = WantDateFromDic(theDictionary, @"endTime");
    ct.confirmedOn        = WantDateFromDic(theDictionary, @"confirmedOn");
    ct.cancelledOn        = WantDateFromDic(theDictionary, @"cancelledOn");
    ct.confirmationStatus = WantStringFromDic(theDictionary, @"confirmationStatus");
    ct.confirmBefore      = WantDateFromDic(theDictionary, @"confirmBefore");
    ct.remindOn           = WantDateFromDic(theDictionary, @"remindOn");
    ct.sendSMSon          = WantDateFromDic(theDictionary, @"sendSMSon");
    ct.smsSentOn          = WantDateFromDic(theDictionary, @"smsSentOn");
    ct.patientCanCancel   = WantBoolFromDic(theDictionary, @"patientCanCancel");
    ct.patientMustConfirm = WantBoolFromDic(theDictionary, @"patientMustConfirm");
    ct.cancelFeesApply    = WantBoolFromDic(theDictionary, @"cancelFeesApply");

    if ((val = theDictionary[@"patientInfo"])) ct.patientInfo = [IBPatientInfo objectWithContentsOfDictionary:val];
    if ((val = theDictionary[@"confirmedBy"])) ct.confirmedBy = [IBUserInfo objectWithContentsOfDictionary:val];
    if ((val = theDictionary[@"cancelledBy"])) ct.cancelledBy = [IBUserInfo objectWithContentsOfDictionary:val];
    if ((val = theDictionary[@"practitioner"])) ct.practitioner = [IBPractitioner objectWithContentsOfDictionary:val];
    if ((val = theDictionary[@"dispensaryInfo"])) ct.dispensaryInfo = [IBDispensaryInfo objectWithContentsOfDictionary:val];

    return ct;
}

/*
 * @property (nonatomic) NSString * confirmationStatus;
 @property (nonatomic) NSDate *confirmBerore;
 @property (nonatomic) NSDate *remindOn;
 @property (nonatomic) NSDate *sendSMSon;
 @property (nonatomic) NSDate *smsSentOn;
 @property (nonatomic) BOOL cancelFeesApply;
 @property (nonatomic) BOOL patientMustConfirm;
 @property (nonatomic) BOOL patientCanCancel;
 */

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.withPersonNamed, dic, @"withPersonNamed");
    PutStringInDic(self.desc, dic, @"desc");
    PutStringInDic(self.guid, dic, @"guid");
    PutStringInDic(self.state, dic, @"state");
    PutStringInDic(self.location, dic, @"location");
    PutDateInDic(self.createdOn, dic, @"createdOn");
    PutDateInDic(self.lastUpdated, dic, @"lastUpdated");
    PutDateInDic(self.startTime, dic, @"startTime");
    PutDateInDic(self.endTime, dic, @"endTime");
    PutDateInDic(self.confirmedOn, dic, @"confirmedOn");
    PutDateInDic(self.cancelledOn, dic, @"cancelledOn");
    PutStringInDic(self.confirmationStatus, dic, @"confirmationStatus");
    PutDateInDic(self.confirmBefore, dic, @"confirmBefore");
    PutDateInDic(self.remindOn, dic, @"remindOn");
    PutDateInDic(self.sendSMSon, dic, @"sendSMSon");
    PutDateInDic(self.smsSentOn, dic, @"smsSentOn");
    PutBoolInDic(self.cancelFeesApply, dic, @"cancelFeesApply");
    PutBoolInDic(self.patientMustConfirm, dic, @"patientMustConfirm");
    PutBoolInDic(self.patientCanCancel, dic, @"patientCanCancel");

    if (self.patientInfo) dic[@"patientInfo"]       = [self.patientInfo asDictionary];
    if (self.confirmedBy) dic[@"confirmedBy"]       = [self.confirmedBy asDictionary];
    if (self.cancelledBy) dic[@"cancelledBy"]       = [self.cancelledBy asDictionary];
    if (self.practitioner) dic[@"practitioner"]     = [self.practitioner asDictionary];
    if (self.dispensaryInfo) dic[@"dispensaryInfo"] = [self.dispensaryInfo asDictionary];

    return dic;
}

//region Business

- (long)getSortOrder {
    return [self calculateSortOrder];
}

- (long)calculateSortOrder {
    // the normal sort oreder will be
    //    isInPlay first , followed by
    //    ! isInPlay
    // isInplayAppointments will be nearest first (between now and start date)
    // !isInPlay will be also in nearest to now to furthest

    long sortOrder = 0;

    if (!self.startTime) {
        MPLOGERROR(@"Appointment with guid[%@] has no startDate", self.guid);
    } else {
//        NSDate *eternity = [NSDate dateWithTimeIntervalSince1970:LONG_MAX];
        NSDate *now = [NSDate date];

        /*
        0                             now                Eternity
        +------------------------------+=================+
            notInPlay                        isInPlay
               - in the past or
               - future cancelled
        *.
         */

//        NSTimeInterval nowToEternity = LONG_MAX - now.timeIntervalSince1970;
        NSTimeInterval nowToDarkAges = now.timeIntervalSince1970;
        if (self.isInPlay) {
            NSTimeInterval startTimeToEternity = LONG_MAX - [self.startTime timeIntervalSince1970];
            sortOrder = (long) ([now timeIntervalSince1970] + startTimeToEternity); // this is wront !!! as well in Java
        } else {
            if (self.isInThePast) {
                sortOrder = (long) [self.startTime timeIntervalSince1970];
            } else {
                NSTimeInterval delta = ABS([now timeIntervalSince1970] - [self.startTime timeIntervalSince1970]);
                sortOrder = (long) (nowToDarkAges - delta);
            }
        }
    }

    return sortOrder;

}

- (void)updateWith:(IBAppointment *)other {
    if (!other) {
        MPLOGERROR(@"Cant update appointment [%@] with nil other.", self.guid);
        return;
    }

    self.guid        = other.guid;
    self.lastUpdated = other.lastUpdated;
    [self setPractitioner:other.practitioner];
    [self setWithPersonNamed:other.withPersonNamed];
    [self setLocation:other.location];
    [self setDesc:other.desc];
    [self setStartTime:other.startTime];
    [self setEndTime:other.endTime];
    [self setConfirmedBy:other.confirmedBy];
    [self setCancelledBy:other.cancelledBy];
    [self setConfirmedOn:other.confirmedOn];
    [self setCancelledOn:other.cancelledOn];
    [self setCreatedOn:other.createdOn];
    [self setState:other.state];
    [self setDispensaryInfo:other.dispensaryInfo];
    [self setPatientInfo:other.patientInfo];
    [self setPatientCanCancel:other.patientCanCancel];
    [self setPatientMustConfirm:other.patientMustConfirm];
    [self setConfirmBefore:other.confirmBefore];
    [self setConfirmationStatus:other.confirmationStatus];
    [self setCancelFeesApply:other.cancelFeesApply];
    [self setSendSMSon:other.sendSMSon];
    [self setSmsSentOn:other.smsSentOn];
    [self setRemindOn:other.remindOn];

}

- (BOOL)isInThePast {
    NSDate *now = [NSDate date];
    return now.timeIntervalSince1970 > self.startTime.timeIntervalSince1970;
}

- (BOOL)areCancelFeesInPlay {
    if (!self.isPending) return NO;
    if (!self.cancelFeesApply) return NO;
    if (self.isInThePast) return NO;
    if (!self.isInPlay) return NO;
    if (!self.confirmBefore) return NO;
    NSDate *now = [NSDate date];
    if (now.timeIntervalSince1970 < self.confirmBefore.timeIntervalSince1970) return NO;
    if (now.timeIntervalSince1970 < self.startTime.timeIntervalSince1970) return YES;
    return NO;

}

- (BOOL)isActionRequired {
    if (!self.isInPlay) return NO;
    if (!self.confirmBefore) return NO;
    if (!self.startTime) return NO;
    if (!self.isResolved) {
        return self.isRemindable;
    }
    return NO;
}

- (BOOL)isResolved {
    return self.isConfirmed || self.isCancelled;
}

- (BOOL)isRemindable {
    //|now     |remindOn        |startTime
    //+--------+----------------+----------->
    //  false  +     true       +   false
    if (self.isResolved) return NO;
    if (!self.remindOn) return NO; // should whine here, should never happen
    if (!self.startTime) return NO; // should whine here, should never happen
    if (self.isCancelled) return NO;
    if (self.isConfirmed) return NO;

    // neither cancelled nor confirmed

    NSDate *now = [NSDate date];
    if (now.timeIntervalSince1970 < self.remindOn.timeIntervalSince1970) return NO;
    if (now.timeIntervalSince1970 < self.startTime.timeIntervalSince1970) return YES;
    return NO;
}

- (BOOL)isInPlay {
    if (self.isInThePast) return NO;
    if (self.isCancelled) return NO;
    return YES;
}

- (BOOL)isCancelled {
    if (!self.state) return NO;
    return [self.state isEqualToString:@"cancelled"];
}

- (BOOL)isConfirmed {
    if (!self.state) return NO;
    return [self.state isEqualToString:@"confirmed"];
}

- (BOOL)isPending {
    if (!self.state) return NO;
    return [self.state isEqualToString:@"pending"];
}


//endregion


+ (instancetype)objectWithJSON:(NSString *)jsonString {
    NSDictionary *dic = [NSDictionary dictionaryWithJSON:jsonString];
    return [self objectWithContentsOfDictionary:dic];
}

+ (instancetype)objectWithJSONdata:(NSData *)jsonData {
    NSDictionary *dic = [NSDictionary dictionaryWithJSONdata:jsonData];
    return [self objectWithContentsOfDictionary:dic];
}

- (NSString *)asJSON {
    return [[self asDictionary] asJSON];
}

- (NSData *)asJSONdata {
    return [[self asDictionary] asJSONdata];
}

@end
