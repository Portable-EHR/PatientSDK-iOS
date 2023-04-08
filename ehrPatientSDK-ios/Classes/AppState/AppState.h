//
// Created by Yves Le Borgne on 2015-10-02.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EHRPersistableP.h"
#import "GERuntimeConstants.h"
#import "EHRLibStateDelegate.h"
#import "IBConsent.h"
#import "UserModel.h"
#import "IBUser.h"
#import "Patient.h"
#import "Models.h"

@class EHRApiServer;
@class IBDeviceInfo;
@class UserDeviceSettings;
@class PatientModel;
@class AuthSequencer;
@class ServicesModel;
@class IBAppInfo;
@class EulaModel;
@class IBUserEula;
@class IBConsent;

@interface AppState : NSObject <EHRPersistableP, EHRLibStateDelegate> {

    NSInteger          _instanceNumber;
    NSInteger          _appBadgeNumber;
    NSInteger          _appBadgeNumberAtStart;
    UserModel          *_userModel;
    NotificationsModel *_notificationsModel;
    ServicesModel      *_servicesModel;
    PatientModel       *_patientModel;
    EulaModel          *_eulaModel;
    Patient            *_patient;
    NSString           *_deviceLanguage;
    SenderBlock        _resetDeviceSuccess,
                       _resetDeviceError,
                       _initializeUserSuccessBlock,
                       _initializeUserErrorBlock;
    VoidBlock          _setUserSuccess,
                       _setUserError;
    EHRApiServer       *_server;
    BOOL               _isForegroundRefreshActivated, _isBackgroundRefreshActivated, _isInBackground, _isDoingOneRefresh;
    NSTimer            *_autoRefreshTimer;
    VoidBlock          _refreshCompletionBlock;
    BOOL               _isServerReachable;
    BOOL               _isPrivacyCompromised;
    AuthSequencer      *_authSequencer;

}

+ (AppState *)sharedAppState;

@property(nonatomic) NSInteger                  appBadgeNumber;
@property(nonatomic) NSInteger                  appBadgeNumberAtStart;
@property(nonatomic, readonly) UserModel        *userModel;
@property(nonatomic) NotificationsModel         *notificationsModel;
@property(nonatomic, readonly) ServicesModel    *servicesModel;
@property(nonatomic, readonly) EulaModel        *eulaModel;
@property(nonatomic, readonly) IBUser           *user;
@property(nonatomic) EHRApiServer               *server;
@property(nonatomic) IBAppInfo                  *appInfo;
@property(nonatomic, readonly) UIViewController *rootViewController;
@property IBDeviceInfo                          *deviceInfo;
@property(nonatomic) Patient                    *patient;
@property(nonatomic) PatientModel               *patientModel;
@property NSDate                                *timeOfLastSync;
@property(nonatomic, readonly) BOOL             isAppUsable;
@property(nonatomic, readonly) BOOL             isServerReachable;
@property(nonatomic, readonly) BOOL             isForegroundRefreshActivated;
@property(nonatomic, readonly) BOOL             isInBackground;
@property(nonatomic) NSString                   *deviceLanguage;
@property(nonatomic) BOOL                       isPrivacyCompromised;
@property(nonatomic, readonly) AuthSequencer    *authSequencer;
@property(nonatomic) BOOL                       isLaunching;
@property(nonatomic, readonly) NSInteger        maximumNumberOfDevices;
@property NSArray<IBConsent *>                  *consents;
@property IBConsent                             *selectedConsent;

- (void)signPreferences;
- (void)unsignPreferences;

// initialization

- (void)initializeAtStartup:(VoidBlock)onSuccess error:(VoidBlock)onError;
- (void)initializeFromSecureCredentialsUser:(VoidBlock)onSuccess error:(VoidBlock)onError;

- (IBUserEula *)getAppUserEula;

// handle this getter-setter manually

- (void)isDoingOneRefresh:(BOOL)isit;
- (BOOL)isDoingOneRefresh;

// device state handling

- (void)activateForegroundRefresh;
- (void)deactivateForegroundRefresh;
- (void)enterBackground;
- (void)resumeForeground;
- (void)resumePolling;
- (void)stopPolling;

- (void)refreshWithCompletion:(VoidBlock)block;

- (void)resetDeviceWithSuccess:(SenderBlock)onSuccess andError:(SenderBlock)onError;
- (BOOL)resetDevice;

- (void)setNewUser:(IBUser *)newUser onSuccess:(VoidBlock)successBlock onError:(VoidBlock)errorBlock;

// some dohickies we will need everywhere in the app

- (void)setApplicationIconBadgeNumber:(NSInteger)number;
- (void)resetApplicationBadgeNumber;

@end
