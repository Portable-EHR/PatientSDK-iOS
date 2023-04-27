//
// Created by Yves Le Borgne on 2023-03-02.
//

#import <Foundation/Foundation.h>
#import "PatientNotification.h"
@class UserModel;

@protocol EHRLibStateDelegate <NSObject>

-(void) onAppBecameActive;
-(void) onAppWillResignActive;
-(void) onSDKinitialized;
-(void) onDeviceInitialized;
-(void) onDeviceDeactivated;
-(void) onAppInfoUpdate;
-(void) onUserInfoUpdate;
-(void) onNotificationsModelUpdate;
-(void) onNotificationUpdate:(PatientNotification *) notification;
-(void) onConsentsUpdate;


@end