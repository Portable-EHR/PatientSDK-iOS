//
// Created by Yves Le Borgne on 2015-10-07.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "PehrSDKConfig.h"
#import "EHRLibRuntimeGlobals.h"
#import "GERuntimeConstants.h"
#import "EHRNetworkableP.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedPropertyInspection"
@class PatientNotification;
@class NotificationsModelFilter;
@class NotificationProgressChange;
@class AppState;
@class MessageDistributionProgressChange;
@class IBMessageContent;

@interface NotificationsModel : NSObject <EHRNetworkableP, EHRInstanceCounterP> {

    NSInteger           _instanceNumber;
    AppState            *_appState;
    NSMutableDictionary *_allNotifications;
    NSDate                   *_lastRefreshed,
                             *_lastPurgedExpired;
    VoidBlock                _refreshSuccessBlock,
                             _refreshFailedBlock;
    NotificationsModelFilter *_allNotificationFilter;
    NotificationsModelFilter *_patientNotificationFilter;
    NotificationsModelFilter *_infoNotificationFilter;
    NotificationsModelFilter *_alertNotificationFilter;
    NotificationsModelFilter *_practitionerNotificationFilter;
    NotificationsModelFilter *_privateMessageNotificationFilter;
    NotificationsModelFilter *_conversationNotificationFilter;
    NotificationsModelFilter *_appointmentNotificationFilter;
    VoidBlock                _stackedNotificationChangesSuccessBlock,
                             _stackedNotificationChangesErrorBlock;
    VoidBlock                _stackedMessageChangesSuccessBlock,
                             _stackedMessageChangesErrorBlock;
    BOOL                     _isSendingStackedNotificationChanges;
    BOOL                     _isSendingStackedMessageChanges;
    BOOL                     _isRefreshEnabled;
    VoidBlock                _notificationSeenSuccessBlock,
                             _notificationSeenErrorBlock;
    VoidBlock                _notificationArchivedSuccessBlock,
                             _notificationArchivedErrorBlock;
    VoidBlock                _notificationDeletedSuccessBlock,
                             _notificationDeletedErrorBlock;
    NSMutableArray           *_stackedNotificationStateChanges,             // being sent
                             *_queuedNotificationStateChanges;              // place to hold new changes during a 'send'
    NSMutableArray           *_stackedMessageStateChanges,                  // being sent
                             *_queuedMessageStateChanges;                   // place to hold new changes during a 'send'
    BOOL                     _isRefreshing;

}

@property(nonatomic) NSDate                             *lastRefreshed;
@property(nonatomic) NSDate                             *lastPurgedExpired;
@property(nonatomic, readonly) NSDictionary             *allNotifications;
@property(nonatomic, readonly) NotificationsModelFilter *allNotificationFilter;
@property(nonatomic, readonly) NotificationsModelFilter *patientNotificationFilter;
@property(nonatomic, readonly) NotificationsModelFilter *practitionerNotificationFilter;
@property(nonatomic, readonly) NotificationsModelFilter *appointmentNotificationsFilter;
@property(nonatomic, readonly) NotificationsModelFilter *privateMessageNotificationFilter;
@property(nonatomic, readonly) NotificationsModelFilter *conversationNotificationFilter;
@property(nonatomic, readonly) NotificationsModelFilter *infoNotificationFilter;
@property(nonatomic, readonly) NotificationsModelFilter *alertNotificationFilter;
@property(nonatomic, getter=isRefreshEnabled) BOOL      refreshEnabled;

- (id)init  NS_UNAVAILABLE  __attribute__((unavailable("init not available")));
+(NotificationsModel *) instance;

- (void)setRefreshEnabled:(BOOL)isit;

- (BOOL)saveOnDevice;
- (BOOL)eraseFromDevice:(BOOL)cascade;
+ (NotificationsModel *)readFromDevice;
- (void)reloadFromDevice;

- (void)refreshFilters;
- (void)refreshFromServer;
- (void)refreshFromServerWithSuccess:(VoidBlock)successBlock andError:(VoidBlock)errorBlock;

- (void)readFromServer;
- (void)readFromServerWithSuccess:(VoidBlock)successBlock andError:(VoidBlock)errorBlock;
- (void)updateWithSinglePatientNotification:(PatientNotification *)pn;

- (void)notificationWasSeen:(PatientNotification *)notification;
- (void)notificationWasSeen:(PatientNotification *)notification onSuccess:(VoidBlock)successBlock onError:(VoidBlock)errorBlock;
- (void)notificationWasDeleted:(PatientNotification *)notification onSuccess:(VoidBlock)successBlock onError:(VoidBlock)errorBlock;
- (void)notificationWasArchived:(PatientNotification *)notification onSuccess:(VoidBlock)successBlock onError:(VoidBlock)errorBlock;
- (void)notificationsWereDeleted:(NSArray *)notifications;
- (void)notificationsWereDeleted:(NSArray *)notifications onSuccess:(VoidBlock)successBlock onError:(VoidBlock)errorBlock;

- (void)sendStackedNotificationChanges;
- (void)sendStackedNotificationChangesOnSuccess:(VoidBlock)stackSuccess onError:(VoidBlock)stackError;
- (void)addNotificationChange:(NotificationProgressChange *)change;
- (BOOL)hasQueuedNotificationChanges;

- (void)addMessageChange:(MessageDistributionProgressChange *)change;
- (void)sendStackedMessageChanges;
- (void)sendStackedMessageChangesOnSuccess:(VoidBlock)stackSuccess onError:(VoidBlock)stackError;
- (BOOL)hasQueuedMessageChanges;

// display support props

@property(nonatomic, readonly) NSInteger numberOfUnseen;
@property(nonatomic, readonly) NSInteger numberOfActionRequired;

- (void)setPatientNotificationsFilter:(NotificationsModelFilter *)patientFilter;
- (void)setInfoNotificationsFilter:(NotificationsModelFilter *)infoFilter;
- (void)setAlertNotificationsFilter:(NotificationsModelFilter *)alertFilter;
- (void)setPractitionerNotificationsFilter:(NotificationsModelFilter *)practitionerFilter;
- (void)setPrivateMessageNotificationsFilter:(NotificationsModelFilter *)telexFilter;
- (void)setAppointmentFilter:(NotificationsModelFilter *)appointmentFilter;

@end

#pragma clang diagnostic pop