//
// Created by Yves Le Borgne on 2015-11-16.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "EHRInstanceCounterP.h"
#import "UserModel.h"
#import "PatientNotification.h"
#import "IBUser.h"

@class IBUser;
@class IBMessageContent;
@class IBMessageDistribution;

typedef NS_ENUM(NSInteger, NotificationFilterType) {
    NotificationFilterTypePatient        = 1,
    NotificationFilterTypeSponsor        = 2,
    NotificationFilterTypeInfo           = 3,
    NotificationFilterTypeAll            = 4,
    NotificationFilterTypePractitioner   = 5,
    NotificationFilterTypeMessage        = 6,
    NotificationFilterTypePrivateMessage = 7,
    NotificationFilterTypeAlert          = 8,
    NotificationFilterTypeAppointment    = 9,
    NotificationFilterTypeConvoList      = 10

};

@interface NotificationsModelFilter : NSObject <EHRInstanceCounterP, EHRPersistableP> {

    NSUInteger             _cursorIndex;
    NSInteger              _instanceNumber;
    BOOL                   _showSponsorNotifications,
                           _showPatientNotifications,
                           _showInfoNotifications,
                           _showAlertNotifications,
                           _showPractitionerNotifications,
                           _showMessageNotifications,
                           _showPrivateMessageNotifications,
                           _showAppointmentNotifications,
                           _showConvoListNotifications,
                           _showUnreadOnly,
                           _showArchived;
    NSInteger              _notificationsPerPage;
    NotificationFilterType _filterType;
    NSMutableArray         *_sortedKeys;
    NSMutableArray *_patientSelector;

}

@property(nonatomic) BOOL                   showPatientNotifications;
@property(nonatomic) BOOL                   showSponsorNotifications;
@property(nonatomic) BOOL                   showInfoNotifications;
@property(nonatomic) BOOL                   showAlertNotifications;
@property(nonatomic) BOOL                   showPractitionerNotifications;
@property(nonatomic) BOOL                   showPrivateMessageNotifications;
@property(nonatomic) BOOL                   showConvoListNotifications;
@property(nonatomic) BOOL                   showAppointmentNotifications;
@property(nonatomic) BOOL                   showMessageNotifications;
@property(nonatomic) BOOL                   showUnreadOnly;
@property(nonatomic) BOOL                   showArchived;
@property(nonatomic) NSInteger              notificationsPerPage;
@property(nonatomic) NotificationFilterType filterType;
@property(nonatomic, readonly) NSArray      *sortedKeys;
@property(nonatomic, readonly) NSInteger    numberOfUnseen;
@property(nonatomic, readonly) NSInteger    numberOfArchived;
@property(nonatomic, readonly) NSInteger    numberOfPrivateMessages;
@property(nonatomic, readonly) NSInteger    numberOfActionRequired;
@property(nonatomic, readonly) NSInteger    count;

@property(nonatomic, readonly) PatientNotification *cursor;
@property(nonatomic, readonly) PatientNotification *next;
@property(nonatomic, readonly) PatientNotification *previous;

- (BOOL)isAtTop;
- (BOOL)isAtBottom;
- (void)setCursorAtTop;
- (void)setCursorAtBottom;
- (void)setCursorAtNotification:(PatientNotification *)notification;
- (void)moveToPrevious;
- (void)moveToNext;
- (BOOL)isEmpty;

+ (NotificationsModelFilter *)patientFilter;
+ (NotificationsModelFilter *)sponsorFilter;
+ (NotificationsModelFilter *)infoFilter;
+ (NotificationsModelFilter *)alertFilter;
+ (NotificationsModelFilter *)allFilter;
+ (NotificationsModelFilter *)practitionerFilter;
+ (NotificationsModelFilter *)messageFilter;
+ (NotificationsModelFilter *)telexFilter;
+ (NotificationsModelFilter *)appointmentFilter;
+ (NotificationsModelFilter *)convoListFilter;

- (void)refreshFilter;
- (void)resetFilter;

- (IBMessageContent *)messageAtCursor:(PatientNotification *)cursor;

@end