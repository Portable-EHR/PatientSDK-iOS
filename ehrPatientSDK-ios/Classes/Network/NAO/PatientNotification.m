//
// Created by Yves Le Borgne on 2015-10-01.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "EHRPersistableP.h"
#import "PatientNotification.h"
#import "IBAnnotation.h"
#import "IBLabRequest.h"
#import "IBLabResult.h"
#import "IBMessageContent.h"
#import "IBTelexInfo.h"
#import "IBAppointment.h"
#import "ConversationEnvelope.h"
#import "NSDate+Compare.h"

@implementation PatientNotification

@dynamic isExpired, isPatient, isSponsor, isMessage, isPrivateMessage, isAppointment, isConvoList, isInfo, isAlert, isSeen, isArchived, isDeleted, isAcknowledged, isActionRequired, isPractitioner, hasUnseenContent;

TRACE_OFF

- (id)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();

        self.textRenderer = @"text";
        self.summary      = @"";
        self.aboutType    = @"none";

    } else {
        MPLOG(@"*** super returned nil!");
    }
    return self;
}

#pragma mark - business methods

- (BOOL)hasUnseenContent {
    if (nil == _lastSeen) return ![self isSeen];
    if (nil == _seenOn) return YES;
    if (nil == _lastUpdated) {
        MPLOG(@"*** Notification has no lastUpdated : %@", [self seq]);
        return NO;
    }
    return [_lastSeen timeIntervalSince1970] < [_lastUpdated timeIntervalSince1970];
}

- (BOOL)isActionRequired {

    if (self.message) {

        IBMessageContent *messageContent = self.message;
        if ([messageContent shouldAck]) return YES;
        if ([messageContent shouldSee]) return YES;
        if ([messageContent lateSeeing]) return YES;

        return NO;

    } else {

        if (self.isExpired) return NO;
        if (self.isSeen) {
            if (self.isInfo) {
                if ([_notificationLevel isEqualToString:@"authorization"]) {
                    return !self.ackedOn;
                } else {
                    return NO;              // any info can be archived unless it has a required 'ack' action
                }
            } else if (self.isPrivateMessage) {
                if (self.isArchived) return NO;
                return self.telexInfo.acknowledgedOn == nil;
            } else if (self.isConvoList) {
                if (self.isArchived) return NO;
            } else {
                // sponsor and medical notifications , once seen have no further
                // action required from l'user
                return NO;
            }
        }

    }
    return YES;
}

- (BOOL)isSeen {
    if (!self.seenOn) return NO;
    return YES;
}

- (BOOL)isAcknowledged {
    if (self.ackedOn) return YES;
    if ([self.progress isEqualToString:@"acknowledged"]) return YES;
    if (nil != self.telexInfo) {
        return self.telexInfo.isAcknowledged;
    }
    return NO;
}

- (BOOL)isArchived {
    if (nil != self.archivedOn) return YES;
    if ([self.progress isEqualToString:@"archived"]) return YES;
    return NO;
}

- (BOOL)isDeleted {
    if ([self.progress isEqualToString:@"deleted"]) return YES;
    return NO;
}

- (BOOL)isExpired {
    if (!self.expiresOn) return NO;
    NSDate *now = [NSDate date];
    if (self.expiresOn.timeIntervalSince1970 > [now timeIntervalSince1970]) return NO;
    return YES;
}

- (BOOL)isPatient {
    if (!_notificationLevel) return NO;
    if ([_notificationLevel isEqualToString:@"patient"]) return YES;
    return NO;

}

- (BOOL)isPractitioner  __unused {
    if (self.practitionerGuid) return YES;
    return NO;
}

- (BOOL)isInfo {
    if (self.isConvoList) return NO;
    if (self.isPrivateMessage) return NO;
    if (self.isAppointment) return NO;
    if (!_notificationLevel) return NO;
    if ([self isSponsor]) return NO;
    if ([_notificationLevel isEqualToString:@"authorization"]) return YES;
    if ([_notificationLevel isEqualToString:@"service"]) return NO;
    if ([_notificationLevel isEqualToString:@"news"]) return YES;
    if ([_notificationLevel isEqualToString:@"info"]) return YES;
    return NO;
}

- (BOOL)isAlert {
    if (!_notificationLevel) return NO;
    if ([self isSponsor]) return NO;
    if ([_notificationLevel isEqualToString:@"alert"]) return YES;
    if ([_notificationLevel isEqualToString:@"service"]) return YES;
    if ([_notificationLevel isEqualToString:@"news"]) return NO;
    if ([_notificationLevel isEqualToString:@"info"]) return NO;
    return NO;
}

- (BOOL)isSponsor {
    if (!_notificationLevel) return NO;
    if ([_notificationLevel isEqualToString:@"sponsor"]) return YES;
    if ([_notificationLevel isEqualToString:@"offer"]) return YES;
    return NO;
}

- (BOOL)isMessage {
    if (!_notificationLevel) return NO;
    if ([_notificationLevel isEqualToString:@"message"]) return YES;
    return NO;
}

- (BOOL)isPrivateMessage {
    return [_payloadType isEqualToString:@"privateMessage"];
}

- (BOOL)isAppointment {
    return [_payloadType isEqualToString:@"appointment"];
}

- (BOOL)isConvoList {
    return [_payloadType isEqualToString:@"conversation"];
}

/*
 * @property NSString         *guid;
 @property NSString         *capabilityGuid;
 @property NSString         *capabilityAlias;
 @property NSString         *text;
 @property NSString         *textRenderer;
 @property NSString         *subject;
 @property NSString         *summary;
 @property BOOL             confidential;
 @property NSString         *payloadType;
 @property NSString         *notificationLevel;
 @property NSString         *aboutType;
 @property NSString         *aboutGuid;
 @property NSURL            *url;
 @property NSString         *thumb;
 @property NSString         *progress;
 @property NSDate           *createdOn;
 @property NSDate           *seenOn;
 @property NSDate           *ackedOn;
 @property NSDate           *archivedOn;
 @property NSDate           *deletedOn;
 @property NSDate           *expiresOn;
 @property NSDate           *lastUpdated;
 @property NSDate           *lastSeen;
 @property NSString         *patientGuid;
 @property NSString         *practitionerGuid;
 @property NSString         *senderName;
 @property IBAppointment    *appointment;
 @property IBAnnotation     *annotation;
 @property IBLabRequest     *labRequest;
 @property IBLabResult      *labResult;
 @property IBTelexInfo      *telexInfo;
 @property IBDeviceInfo     *deviceInfo;
 @property IBMessageContent *message;
 @property NSString         *seq;
 */
- (void)updateWith:(PatientNotification *)other {

    self.guid              = other.guid;
    self.appointment       = other.appointment;
    self.convo             = other.convo;
    self.telexInfo         = other.telexInfo;
    self.capabilityAlias   = other.capabilityAlias;
    self.capabilityGuid    = other.capabilityGuid;
    self.text              = other.text;
    self.textRenderer      = other.textRenderer;
    self.subject           = other.subject;
    self.summary           = other.summary;
    self.confidential      = other.confidential;
    self.payloadType       = other.payloadType;
    self.notificationLevel = other.notificationLevel;
    self.aboutGuid         = other.aboutGuid;
    self.aboutType         = other.aboutType;
    self.url               = other.url;
    self.thumb             = other.thumb;
    self.progress          = other.progress;
    self.createdOn         = other.createdOn;
    self.seenOn            = other.seenOn;
    self.ackedOn           = other.ackedOn;
    self.archivedOn        = other.archivedOn;
    self.deletedOn         = other.deletedOn;
    self.expiresOn         = other.expiresOn;
    self.lastSeen          = other.lastSeen;
    self.lastUpdated       = other.lastUpdated;
    self.patientGuid       = other.patientGuid;
    self.practitionerGuid  = other.practitionerGuid;
    self.senderName        = other.senderName;
    self.deviceInfo        = other.deviceInfo;
    self.seq               = other.seq;
    [self.appointment updateWith:other.appointment];

}

#pragma mark - EHRNetworkableP

+ (PatientNotification *)objectWithContentsOfDictionary:(NSDictionary *)dic {
    PatientNotification *pn = [[PatientNotification alloc] init];

    @try {

        pn.guid              = WantStringFromDic(dic, @"guid");
        pn.capabilityGuid    = WantStringFromDic(dic, @"capabilityGuid");
        pn.capabilityAlias   = WantStringFromDic(dic, @"capabilityAlias");
        pn.payloadType       = WantStringFromDic(dic, @"payloadType");
        pn.notificationLevel = WantStringFromDic(dic, @"notificationLevel");
        pn.payloadType       = WantStringFromDic(dic, @"payloadType");
        pn.aboutType         = WantStringFromDic(dic, @"aboutType");
        pn.aboutGuid         = WantStringFromDic(dic, @"aboutGuid");
        pn.text              = WantStringFromDic(dic, @"text");
        pn.textRenderer      = WantStringFromDic(dic, @"textRenderer");
        pn.subject           = WantStringFromDic(dic, @"subject");
        pn.summary           = WantStringFromDic(dic, @"summary");
        pn.thumb             = WantStringFromDic(dic, @"thumb");
        pn.progress          = WantStringFromDic(dic, @"progress");
        pn.patientGuid       = WantStringFromDic(dic, @"patientGuid");
        pn.confidential      = WantBoolFromDic(dic, @"confidential");
        pn.url               = WantUrlFromDic(dic, @"url");
        pn.createdOn         = WantDateFromDic(dic, @"createdOn");
        pn.seenOn            = WantDateFromDic(dic, @"seenOn");
        pn.ackedOn           = WantDateFromDic(dic, @"ackedOn");
        pn.archivedOn        = WantDateFromDic(dic, @"archivedOn");
        pn.deletedOn         = WantDateFromDic(dic, @"deletedOn");
        pn.expiresOn         = WantDateFromDic(dic, @"expiresOn");
        pn.lastUpdated       = WantDateFromDic(dic, @"lastUpdated");
        pn.lastSeen          = WantDateFromDic(dic, @"lastSeen");
        pn.senderName        = WantStringFromDic(dic, @"senderName");
        pn.practitionerGuid  = WantStringFromDic(dic, @"practitionerGuid");
        pn.seq               = WantStringFromDic(dic, @"seq");

        id val;

        if ((val = dic[@"telexInfo"])) {
            pn.telexInfo = [IBTelexInfo objectWithContentsOfDictionary:val];
        }
        if ((val = dic[@"message"])) {
            pn.message = [IBMessageContent objectWithContentsOfDictionary:val];
        }

        if ((val = dic[@"annotation"])) {
            pn.annotation = [IBAnnotation objectWithContentsOfDictionary:val];
        }

        if ((val = dic[@"labRequest"])) {
            pn.labRequest = [IBLabRequest objectWithContentsOfDictionary:val];
        }

        if ((val = dic[@"labResult"])) {
            pn.labResult = [IBLabResult objectWithContentsOfDictionary:val];
        }

        if ((val = dic[@"appointment"])) {
            pn.appointment = [IBAppointment objectWithContentsOfDictionary:val];
        }

        if ((val = dic[@"convo"])) {
            pn.convo = [ConversationEnvelope objectWithContentsOfDictionary:val];
        }

    } @catch (NSException *e) {
        MPLOG(@"Cautht exceltion %@", e.description);
    }

    return pn;
}

- (NSDictionary *)asDictionary {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    PutStringInDic(self.seq, dic, @"seq");
    PutStringInDic(self.guid, dic, @"guid");
    PutStringInDic(self.capabilityGuid, dic, @"capabilityGuid");
    PutStringInDic(self.capabilityAlias, dic, @"capabilityAlias");
    PutBoolInDic(self.confidential, dic, @"confidential");
    PutStringInDic(self.payloadType, dic, @"payloadType");
    PutStringInDic(self.notificationLevel, dic, @"notificationLevel");
    PutStringInDic(self.payloadType, dic, @"payloadType");
    PutStringInDic(self.aboutType, dic, @"aboutType");
    PutStringInDic(self.aboutGuid, dic, @"aboutGuid");
    PutStringInDic(self.text, dic, @"text");
    PutStringInDic(self.textRenderer, dic, @"textRenderer");
    PutStringInDic(self.summary, dic, @"summary");
    PutStringInDic(self.subject, dic, @"subject");
    PutStringInDic(self.thumb, dic, @"thumb");
    PutStringInDic(self.progress, dic, @"progress");
    PutStringInDic(self.patientGuid, dic, @"patientGuid");
    PutUrlInDic(self.url, dic, @"url");
    PutDateInDic(self.createdOn, dic, @"createdOn");
    PutDateInDic(self.seenOn, dic, @"seenOn");
    PutDateInDic(self.ackedOn, dic, @"ackedOn");
    PutDateInDic(self.archivedOn, dic, @"archivedOn");
    PutDateInDic(self.deletedOn, dic, @"deletedOn");
    PutDateInDic(self.expiresOn, dic, @"expiresOn");
    PutDateInDic(self.lastUpdated, dic, @"lastUpdated");
    PutDateInDic(self.lastSeen, dic, @"lastSeen");
    PutStringInDic(self.senderName, dic, @"senderName");
    PutStringInDic(self.practitionerGuid, dic, @"practitionerGuid");

    if (self.telexInfo) {
        dic[@"telexInfo"] = [self.telexInfo asDictionary];
    }

    if (self.message) {
        dic[@"message"] = [self.message asDictionary];
    }

    if (self.annotation) {
        dic[@"annotation"] = [self.annotation asDictionary];
    }

    if (self.labRequest) {
        dic[@"labRequest"] = [self.labRequest asDictionary];
    }

    if (self.labResult) {
        dic[@"labResult"] = [self.labResult asDictionary];
    }
    if (self.appointment) {
        dic[@"appointment"] = [self.appointment asDictionary];
    }

    if (self.convo) {
        dic[@"convo"] = [self.convo asDictionary];
    }

    return dic;
}

+ (PatientNotification *)objectWithJSON:(NSString *)jsonString {
    NSDictionary *dic = [NSDictionary dictionaryWithJSON:jsonString];
    return [PatientNotification objectWithContentsOfDictionary:dic];
}

+ (PatientNotification *)objectWithJSONdata:(NSData *)jsonData {
    NSDictionary *dic = [NSDictionary dictionaryWithJSONdata:jsonData];
    return [PatientNotification objectWithContentsOfDictionary:dic];
}

- (NSData *)asJSONdata {
    NSDictionary *dic = [self asDictionary];
    return [dic asJSONdata];
}

- (NSString *)asJSON {
    NSDictionary *dic = [self asDictionary];
    return [dic asJSON];
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end