//
// Created by Yves Le Borgne on 2015-11-17.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//


#import "IBDeviceInfo.h"
#import "GEDeviceHardware.h"
#import "IBAppSummary.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@implementation IBDeviceInfo

@synthesize deviceGuid = _deviceGuid;
@synthesize manufacturer = _manufacturer;
@synthesize modelCode = _modelCode;
@synthesize osType = _osType;
@synthesize osVersion = _osVersion;
@synthesize createdOn = _createdOn;
@synthesize isPhone = _isPhone;
@synthesize hasBiometricDevice = _hasBiometricDevice;
@synthesize hasEnrolledFingerprints = _hasEnrolledFingerprints;
@synthesize localAuthenticationTested = _localAuthenticationTested;
@synthesize canAuthenticate = _canAuthenticate;
@synthesize canAuthenticateWithPIN = _canAuthenticateWithPIN;
@synthesize canAuthenticateWithBiometrics = _canAuthenticateWithBiometrics;
@synthesize appSummary = _appSummary;
@synthesize lastSeen = _lastSeen;
TRACE_OFF

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();

    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
    _deviceGuid   = nil;
    _createdOn    = nil;
    _manufacturer = nil;
    _modelCode    = nil;
    _osType       = nil;
    _osVersion    = nil;
    _appSummary   = nil;

}

#pragma mark - init from device, sniff device properties !

+ (instancetype)initFromDevice {
    IBDeviceInfo *di = [[IBDeviceInfo alloc] init];
    di.createdOn    = [NSDate date];
    di.manufacturer = @"Apple";
    di.modelCode    = [GEDeviceHardware platform];
    di.osVersion    = [[UIDevice currentDevice] systemVersion];
    di.osType       = [[UIDevice currentDevice] systemName];
    di.createdOn    = [NSDate date];
    di.isPhone      = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
    di.appSummary   = nil;
    [di testLocalAuthentication];
    return di;
}

#pragma mark - business

- (BOOL)useFingerprint __unused {
    if (!self.localAuthenticationTested) {
        [self testLocalAuthentication];
    }
    return self.hasBiometricDevice && self.hasEnrolledFingerprints;
}

#pragma mark - persistence

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {

    IBDeviceInfo *pa = [[self alloc] init];
    pa->_deviceGuid                                       = WantStringFromDic(dic, @"deviceGuid");
    pa->_manufacturer                                     = WantStringFromDic(dic, @"manufacturer");
    pa->_modelCode                                        = WantStringFromDic(dic, @"modelCode");
    pa->_osType                                           = WantStringFromDic(dic, @"osType");
    pa->_osVersion                                        = WantStringFromDic(dic, @"osVersion");
    pa->_createdOn                                        = WantDateFromDic(dic, @"createdOn");
    pa->_lastSeen                                         = WantDateFromDic(dic, @"lastSeen");
    pa->_isPhone                                          = WantBoolFromDic(dic, @"isPhone");
    pa->_localAuthenticationTested                        = WantBoolFromDic(dic, @"localAuthenticationTested");
    pa->_hasBiometricDevice                               = WantBoolFromDic(dic, @"hasBiometricDevice");
    pa->_hasEnrolledFingerprints                          = WantBoolFromDic(dic, @"hasEnrolledFingerprints");
    if ([dic objectForKey:@"appSummary"]) pa->_appSummary = [IBAppSummary objectWithContentsOfDictionary:[dic objectForKey:@"appSummary"]];
    [pa testLocalAuthentication];

    return pa;
}

- (NSDictionary *)asDictionary {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.deviceGuid, dic, @"deviceGuid");
    PutStringInDic(self.osType, dic, @"osType");
    PutStringInDic(self.osVersion, dic, @"osVersion");
    PutStringInDic(self.manufacturer, dic, @"manufacturer");
    PutStringInDic(self.modelCode, dic, @"modelCode");
    PutDateInDic(self.createdOn, dic, @"createdOn");
    PutBoolInDic(self.isPhone, dic, @"isPhone");
    PutBoolInDic(self.hasBiometricDevice, dic, @"hasBiometricDevice");
    PutBoolInDic(self.hasEnrolledFingerprints, dic, @"hasEnrolledFingerprints");
    PutBoolInDic(self.localAuthenticationTested, dic, @"localAuthenticationTested");
    if (self.appSummary) [dic setObject:[self.appSummary asDictionary] forKey:@"appSummary"];
    return dic;

}

- (NSString *)asJSON {
    return [[self asDictionary] asJSON];
}

- (NSData *)asJSONdata {
    return [[self asDictionary] asJSONdata];
}

+ (instancetype)objectWithJSONdata:(NSData *)jsonData {
    NSDictionary *dic = [NSDictionary dictionaryWithJSONdata:jsonData];
    return [self objectWithContentsOfDictionary:dic];
}

+ (instancetype)objectWithJSON:(NSString *)jsonString {
    NSDictionary *dic = [NSDictionary dictionaryWithJSON:jsonString];
    return [self objectWithContentsOfDictionary:dic];
}

- (void)testLocalAuthentication {

    self.canAuthenticateWithBiometrics = [self testDeviceOwnerlAuthenticationWithBiometrics];
    self.canAuthenticateWithPIN        = [self testDeviceOwnerAuthentication];
    self.canAuthenticate               = self.canAuthenticateWithBiometrics || self.canAuthenticateWithPIN;

}

- (BOOL)testDeviceOwnerlAuthenticationWithBiometrics {
    @try {

        LAContext *laContext = [[LAContext alloc] init];
        NSError   *error     = nil;
        BOOL      hasTouchID = [laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
        if (hasTouchID) {
            self.hasBiometricDevice      = YES;
            self.hasEnrolledFingerprints = YES;
            return YES;
        } else {
            if (error) {
                if (error.code == LAErrorTouchIDNotEnrolled) {
                    self.hasBiometricDevice      = YES;
                    self.hasEnrolledFingerprints = NO;
                } else if (error.code == LAErrorTouchIDNotAvailable) {
                    self.hasBiometricDevice      = NO;
                    self.hasEnrolledFingerprints = NO;
                } else {
                    TRACE(@"dafuk, unknownd LAContext error");
                }
                return NO;
            } else {
                TRACE(@"No biometrics at all");
                self.hasBiometricDevice      = NO;
                self.hasEnrolledFingerprints = NO;
                return YES;
            }
        }
    } @catch (NSException *e) {
        self.localAuthenticationTested = NO;
        self.hasBiometricDevice        = NO;
        self.hasEnrolledFingerprints   = NO;

        MPLOG(@"*** an exception [%@] occured while testing local authentication on device.\n%@\n\n%@",
                e.debugDescription,
                e.callStackSymbols,
                e.callStackReturnAddresses);
    }
    return NO;

}

- (BOOL)testDeviceOwnerAuthentication {

    @try {
        LAContext *laContext = [[LAContext alloc] init];

        NSError *error     = nil;
        BOOL    hasPINauth = [laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error];
        if (hasPINauth) {
            self.hasBiometricDevice      = YES;
            self.hasEnrolledFingerprints = YES;
            return YES;
        } else {
            if (error) {
                if (error.code == LAErrorTouchIDNotEnrolled) {
                    self.hasBiometricDevice      = YES;
                    self.hasEnrolledFingerprints = NO;
                } else if (error.code == LAErrorTouchIDNotAvailable) {
                    self.hasBiometricDevice      = NO;
                    self.hasEnrolledFingerprints = NO;
                } else if (error.code == kLAErrorPasscodeNotSet) {
                    self.hasBiometricDevice      = NO;
                    self.hasEnrolledFingerprints = NO;
                } else {
                    TRACE(@"dafuk, unknownd LAContext error");
                }
            } else {
                TRACE(@"dafuk, no error yet no auth mechanism at all");
            }
        }

    } @catch (NSException *e) {

        self.localAuthenticationTested = NO;
        self.hasBiometricDevice        = NO;
        self.hasEnrolledFingerprints   = NO;

        MPLOG(@"*** an exception [%@] occured while testing local authentication on device.\n%@\n\n%@",
                e.debugDescription,
                e.callStackSymbols,
                e.callStackReturnAddresses);
    }
    return NO;
}

@end
#pragma clang diagnostic pop