//
// Created by Yves Le Borgne on 2015-10-04.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GERuntimeConstants.h"
#import "EHRInstanceCounterP.h"

@class EHRServerRequest;
@class EHRServerResponse;

@interface EHRCall : NSObject <EHRInstanceCounterP, NSURLConnectionDataDelegate, NSURLConnectionDelegate> {
    NSInteger           _instanceNumber;
    NSInteger           _maximumAttempts;
    NSInteger           _attemptNumber;
    SenderBlock         _onSuccess,
                        _onError;
    EHRServerRequest    *_serverRequest;
    EHRServerResponse   *_serverResponse;
    float               _timeOut;
    NSURLConnection     *_urlConnection;
    NSMutableURLRequest *_urlRequest;
    NSURL               *_url;
    NSMutableData       *_responseData;
    BOOL                _verbose,
                        _isCallInProgress,
                        _isCallingServer,
                        _wasResponseReceived;
    VoidBlock           _onStart;
    VoidBlock           _onEnd;

}

@property(nonatomic) float                       timeOut;
@property(nonatomic) EHRServerRequest            *serverRequest;
@property(nonatomic, readonly) EHRServerResponse *serverResponse;
@property(nonatomic) NSInteger                   maximumAttempts;
@property(nonatomic, readonly) BOOL              isCallInProgress;
@property(nonatomic) BOOL                        verbose;

+ (id)callWithRequest:(EHRServerRequest *)request onSuccess:(SenderBlock)success onError:(SenderBlock)error;
- (BOOL)startAsGuest __attribute__((unused));
- (BOOL)start;
- (void)cancel;
- (void)setOnStart:(VoidBlock)onStart;
- (void)setOnEnd:(VoidBlock)onEnd;

@end