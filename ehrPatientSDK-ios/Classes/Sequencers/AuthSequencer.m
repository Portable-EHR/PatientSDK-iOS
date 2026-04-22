//
// Created by Yves Le Borgne on 2016-12-20.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <LocalAuthentication/LocalAuthentication.h>
#import "AuthSequencer.h"
#import "AppState.h"
#import "IBDeviceInfo.h"

@implementation AuthSequencer

TRACE_OFF

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
    _deviceInfo = nil;

}

- (id)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        _deviceInfo = [IBDeviceInfo initFromDevice];

    } else {
        MPLOG(@"*** Yelp : super returned nil !!!");
    }
    return self;
}

- (IBDeviceInfo *)deviceInfo {
    return _deviceInfo;
}

- (void)testLocalAuthentication __unused {
    [_deviceInfo testLocalAuthentication];
}

- (void)authenticateWithReason:(NSString *)reason onSuccess:(VoidBlock)successBlock onError:(VoidBlock)errorBlock  __unused {
    TRACE_KILLROY

    [self testLocalAuthentication];

    if (!_deviceInfo.canAuthenticate) {
        MPLOG(@"Invoked with no authentication machenism, signaling success.");
        successBlock();
        return;
    }

    _authenticationFailure = [errorBlock copy];
    _authenticationSuccess = [successBlock copy];

    if (_deviceInfo.canAuthenticateWithBiometrics) {
//        [self authenticateWithBiometrics:reason];
        [self authenticateWithPIN:reason];
    } else if (_deviceInfo.canAuthenticate) {
        [self authenticateWithPIN:reason];
    }

}

- (void)executeAuthenticationSuccessBlock {
    TRACE_KILLROY
    [AppState sharedAppState].isPrivacyCompromised = NO;
    if (_authenticationSuccess) {
        _authenticationSuccess();
    }
    _authenticationSuccess = nil;
    _authenticationFailure = nil;
    _ctx                   = nil;
}

- (void)executeAuthenticationFailureBlock {
    TRACE_KILLROY
    [AppState sharedAppState].isPrivacyCompromised = YES;
    if (_authenticationFailure) {
        _authenticationFailure();
    }
    _authenticationSuccess = nil;
    _authenticationFailure = nil;
    _ctx                   = nil;
}

- (void)authenticateWithBiometrics:(NSString *)reason {

    TRACE_KILLROY

    _ctx = [[LAContext alloc] init];
    __weak  AuthSequencer *__selfie = self;
    _ctx.localizedFallbackTitle = NSLocalizedString(@"phrase.EnterPIN", nil);

    [_ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:reason reply:^(BOOL success, NSError *error) {
        TRACE(@"Got reply from LA thread.");
        if (success) {
            [__selfie performSelectorOnMainThread:@selector(executeAuthenticationSuccessBlock) withObject:nil waitUntilDone:NO];
        } else {
            [__selfie performSelectorOnMainThread:@selector(executeAuthenticationFailureBlock) withObject:nil waitUntilDone:NO];
        }
    }];

}

- (void)authenticateWithPIN:(NSString *)reason {

    TRACE_KILLROY

    _ctx = [[LAContext alloc] init];
    __weak  AuthSequencer *__selfie = self;
    _ctx.localizedFallbackTitle = NSLocalizedString(@"phrase.EnterPIN", nil);

    [_ctx evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:reason reply:^(BOOL success, NSError *error) {
        TRACE(@"Got reply from LA thread.");
        if (success) {
            [__selfie performSelectorOnMainThread:@selector(executeAuthenticationSuccessBlock) withObject:nil waitUntilDone:NO];
        } else {
            [__selfie performSelectorOnMainThread:@selector(executeAuthenticationFailureBlock) withObject:nil waitUntilDone:NO];
        }
    }];
}

@end
