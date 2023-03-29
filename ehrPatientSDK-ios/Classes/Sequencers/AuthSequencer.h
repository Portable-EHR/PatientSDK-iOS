//
// Created by Yves Le Borgne on 2016-12-20.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRLibRuntimeGlobals.h"

@class AppState;
@class EHRApiServer;
@class IBDeviceInfo;
@class LAContext;

@interface AuthSequencer : NSObject <EHRInstanceCounterP> {
    NSInteger _instanceNumber;

    EHRApiServer *_apiServer;
    IBDeviceInfo *_deviceInfo;
    LAContext    *_ctx;
    VoidBlock    _authenticationSuccess;
    VoidBlock    _authenticationFailure;

}

@property (nonatomic, readonly) IBDeviceInfo * deviceInfo;

-(void)testLocalAuthentication;
- (void)authenticateWithReason:(NSString *)reason onSuccess:(VoidBlock)successBlock onError:(VoidBlock)errorBlock;

@end
