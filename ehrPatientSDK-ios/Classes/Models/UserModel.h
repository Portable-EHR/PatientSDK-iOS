//
// Created by Yves Le Borgne on 2015-10-24.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRLibRuntimeGlobals.h"
#import "GERuntimeConstants.h"
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "EHRModelSequencerP.h"
#import "IBUser.h"
#import "NotificationsModel.h"
#import "ServicesModel.h"
#import "UserDeviceSettings.h"

@interface UserModel : NSObject <EHRInstanceCounterP, EHRPersistableP, EHRModelSequencerP> {
    NSInteger           _instanceNumber;
    NSDate              *_lastRefreshed;
    IBUser                *_user;
    NotificationsModel  *_notificationsModel;
    ServicesModel       *_servicesModel;
    NSMutableDictionary *_patientModels;
    UserDeviceSettings  *_deviceSettings;
}

@property(nonatomic, readonly) IBUser *user;

+ (UserModel *)guest;
+ (UserModel *)userModelFor:(IBUser *)user;

@property(nonatomic, readonly) NotificationsModel *notificationsModel;
@property(nonatomic, readonly) ServicesModel      *servicesModel;
@property(nonatomic, readonly) NSDictionary       *patientModels;
@property(nonatomic, readonly) BOOL               isGuest;
@property(nonatomic) UserDeviceSettings           *deviceSettings;

- (void)updateUserInfo:(IBUser *)newInfo;
-(void) updateUserInfo:(IBUser *) newInfo save:(BOOL) saveIt;

- (BOOL)isResponderForPatientWithGuid:(NSString *)guid;
- (BOOL)hasPatientWithGuid:(NSString *)guid;
- (BOOL)isProxyResponderForPatientWithGuid:(NSString *)guid;
- (BOOL)hasVisitWithGuid:(NSString *)guid;
- (BOOL)isUserForPatientWithGuid:(NSString *)guid;

- (BOOL)saveOnDevice;
- (BOOL)saveOnDevice:(BOOL)cascade;
- (BOOL)eraseFromDevice:(BOOL)cascade;
+ (UserModel *)readFromDevice:(NSString *)guid cascade:(BOOL)doCascade;

- (void)readNotificationsModelFromDevice;

@end