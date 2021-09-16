//
// Created by Yves Le Borgne on 2015-11-17.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "EHRInstanceCounterP.h"

@class NotificationsModelFilter;
@class PatientModel;
@class ServicesModelFilter;

@interface UserDeviceSettings : NSObject <EHRInstanceCounterP, EHRPersistableP> {
    NSInteger                _instanceNumber;
    NotificationsModelFilter *_patientNotificationsFilter;
    NotificationsModelFilter *_alertNotificationsFilter;
    NotificationsModelFilter *_infoNotificationsFilter;
    NotificationsModelFilter *_practitionerNotificationsFilter;
    NotificationsModelFilter *_messageNotificationsFilter;
    NotificationsModelFilter *_telexNotificationsFilter;
    NotificationsModelFilter *_appointmentNotificationsFilter;
    ServicesModelFilter      *_subscribedServicesFilter;

}

@property(nonatomic) NotificationsModelFilter *patientNotificationsFilter;
@property(nonatomic) NotificationsModelFilter *alertNotificationsFilter;
@property(nonatomic) NotificationsModelFilter *infoNotificationsFilter;
@property(nonatomic) NotificationsModelFilter *practitionerNotificationsFilter;
@property(nonatomic) NotificationsModelFilter *messageNotificationsFilter;
@property(nonatomic) NotificationsModelFilter *telexNotificationsFilter;
@property(nonatomic) NotificationsModelFilter *appointmentNotificationsFilter;
@property(nonatomic) ServicesModelFilter      *subscribedServicesFilter;
@end