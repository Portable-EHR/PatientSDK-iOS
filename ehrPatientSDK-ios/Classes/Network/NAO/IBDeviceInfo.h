//
// Created by Yves Le Borgne on 2015-11-17.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRNetworkableP.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"
#import "IBAppSummary.h"

@interface IBDeviceInfo : NSObject <EHRInstanceCounterP, EHRNetworkableP, EHRPersistableP> {
    NSInteger    _instanceNumber;
    NSString     *_deviceGuid;
    NSString     *_osType;
    NSString     *_osVersion;
    NSString     *_manufacturer;
    NSString     *_modelCode;
    NSDate       *_createdOn;
    NSDate       *_lastSeen;
    IBAppSummary *_appSummary;
    BOOL         _isPhone;
    BOOL         _localAuthenticationTested;
    BOOL         _hasBiometricDevice;
    BOOL         _hasEnrolledFingerprints;
    BOOL         _canAuthenticate;
    BOOL         _canAuthenticateWithBiometrics;
    BOOL         _canAuthenticateWithPIN;
//    LAPolicy     _policyInPlace;
}

@property(nonatomic) NSString     *deviceGuid;
@property(nonatomic) NSString     *osType;
@property(nonatomic) NSString     *osVersion;
@property(nonatomic) NSString     *manufacturer;
@property(nonatomic) NSString     *modelCode;
@property(nonatomic) IBAppSummary *appSummary;
@property(nonatomic) NSDate       *createdOn;
@property(nonatomic) NSDate       *lastSeen;
@property(nonatomic) BOOL         isPhone;
@property(nonatomic) BOOL         hasBiometricDevice;
@property(nonatomic) BOOL         hasEnrolledFingerprints;
@property(nonatomic) BOOL         localAuthenticationTested;
@property(nonatomic) BOOL         canAuthenticate;
@property(nonatomic) BOOL         canAuthenticateWithBiometrics;
@property(nonatomic) BOOL         canAuthenticateWithPIN;

+ (instancetype)initFromDevice;
- (BOOL)useFingerprint;
- (void)testLocalAuthentication;

@end
