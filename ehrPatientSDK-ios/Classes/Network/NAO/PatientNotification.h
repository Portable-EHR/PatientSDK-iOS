//
// Created by Yves Le Borgne on 2015-10-01.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRNetworkableP.h"
#import "EHRInstanceCounterP.h"

@class EHRCall;
@class EHRServerRequest;
@class EHRServerResponse;
@class IBAnnotation;
@class IBLabRequest;
@class IBLabResult;
@class IBMessageContent;
@class IBTelexInfo;
@class IBDeviceInfo;
@class IBAppointment;
@class ConversationEnvelope;

@interface PatientNotification : NSObject <EHRInstanceCounterP, EHRNetworkableP> {

    NSInteger _instanceNumber;

}

@property NSString             *guid;
@property NSString             *capabilityGuid;
@property NSString             *capabilityAlias;
@property NSString             *text;
@property NSString             *textRenderer;
@property NSString             *subject;
@property NSString             *summary;
@property BOOL                 confidential;
@property NSString             *payloadType;
@property NSString             *notificationLevel;
@property NSString             *aboutType;
@property NSString             *aboutGuid;
@property NSURL                *url;
@property NSString             *thumb;
@property NSString             *progress;
@property NSDate               *createdOn;
@property NSDate               *seenOn;
@property NSDate               *ackedOn;
@property NSDate               *archivedOn;
@property NSDate               *deletedOn;
@property NSDate               *expiresOn;
@property NSDate               *lastUpdated;
@property NSDate               *lastSeen;
@property NSString             *patientGuid;
@property NSString             *practitionerGuid;
@property NSString             *senderName;
@property IBAppointment        *appointment;
@property ConversationEnvelope *convo;
@property IBAnnotation         *annotation;
@property IBLabRequest         *labRequest;
@property IBLabResult          *labResult;
@property IBTelexInfo          *telexInfo;
@property IBDeviceInfo         *deviceInfo;
@property IBMessageContent     *message;
@property NSString             *seq;

@property(nonatomic, readonly) BOOL isDeleted;
@property(nonatomic, readonly) BOOL isExpired;
@property(nonatomic, readonly) BOOL isSeen;
@property(nonatomic, readonly) BOOL isAcknowledged;
@property(nonatomic, readonly) BOOL isArchived;
@property(nonatomic, readonly) BOOL isPatient;
@property(nonatomic, readonly) BOOL isSponsor;
@property(nonatomic, readonly) BOOL isMessage;
@property(nonatomic, readonly) BOOL isPrivateMessage;
@property(nonatomic, readonly) BOOL isAppointment;
@property(nonatomic, readonly) BOOL isConvoList;
@property(nonatomic, readonly) BOOL isPractitioner;
@property(nonatomic, readonly) BOOL isInfo;
@property(nonatomic, readonly) BOOL isAlert;
@property(nonatomic, readonly) BOOL isActionRequired;
@property(nonatomic, readonly) BOOL hasUnseenContent;

- (void)updateWith:(PatientNotification *)other;

@end