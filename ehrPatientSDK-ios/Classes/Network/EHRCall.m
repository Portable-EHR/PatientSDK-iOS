//
// Created by Yves Le Borgne on 2015-10-04.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "EHRCall.h"
#import "EHRServerRequest.h"
#import "EHRServerResponse.h"
#import "EHRApiServer.h"
#import "EHRRequestStatus.h"
#import "AppState.h"
#import "SecureCredentials.h"
#import "UserCredentials.h"
#import "IBUser.h"
#import <TrustKit/TrustKit.h>

@implementation EHRCall
TRACE_OFF

static CFArrayRef certs;

@synthesize timeOut = _timeOut;
@synthesize serverRequest = _serverRequest;
@synthesize serverResponse = _serverResponse;
@synthesize maximumAttempts = _maximumAttempts;
@synthesize verbose = _verbose;
@dynamic isCallInProgress;

+ (void)initialize {
}

- (id)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        self.timeOut         = kNetworkTimeOut;
        self.maximumAttempts = kNetworkRetries;
        self->_attemptNumber = 0;
        self->_verbose       = NO;
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

+ (EHRCall *)callWithRequest:(EHRServerRequest *)request onSuccess:(SenderBlock)success onError:(SenderBlock)error {
    EHRCall *call = [[EHRCall alloc] init];
    call.serverRequest = request;
    call->_onSuccess = [success copy];
    call->_onError   = [error copy];
    return call;
}

- (void)on401Barf {

    NSDictionary *req = [self.serverRequest asDictionary];
    MPLOGERROR(@"The sent request which may get a AUTH_FAILED\n%@", req);

    NSDictionary *serv = [self.serverRequest.server asDictionary];
    MPLOGERROR(@"The server which may get a AUTH_FAILED\n%@", serv);

    MPLOGERROR(@"The creds : \n%@", [[[SecureCredentials sharedCredentials] asDictionary] asJSON]);
}

-(void)startAsGuest {
    self.serverRequest.apiKey=[IBUser guest].apiKey;
    [self start];
}

- (void)start {

    if (_isCallingServer) {
        MPLOG(@"*** Attempt to call while a call is already in progress.");
        return;
    }

    if (nil == self.serverRequest
            || nil == self.serverRequest.server
            || nil == self.serverRequest.server.host
            || ![self.serverRequest.server.host isEqualToString:[SecureCredentials sharedCredentials].current.server.host]
            ) {
        MPLOGERROR(@"start : invalid server damit !");
        [self on401Barf];

        // note to self :::: some requests are for manual activations, eg guest, with an oamp host ... they
        // must be allowed to pass.

        // we are logging cuz tracking a rambling zombie elsewhere

    }

    if (_onStart) _onStart();

    [self cleanupForNextCall];

    [self makeFreshURLconnection];
    [self performSelector:@selector(fireUrlConnection) withObject:nil afterDelay:.001f];
    TRACE(@"just performed selector fireUrlConnection");

    _isCallingServer     = YES;
    _wasResponseReceived = NO;
    [[AppState sharedAppState] setNetworkActivityIndicatorVisible:YES];
}

- (BOOL)isCallInProgress {
    return _isCallInProgress;
}

- (void)cancel {

    if (_isCallingServer) {
        [_urlConnection cancel];
        [self cleanupWithError:@"CANCEL" message:@"The request to the server was cancelled."];
    } else {
        MPLOG(@"*** Got cancel request while idle.");
    }

}

#pragma mark - getters and setters

- (void)setTimeOut:(float)timeOut {
    _timeOut = timeOut;
}

- (void)setMaximumAttempts:(NSInteger)maximumAttempts {
    _maximumAttempts = maximumAttempts;
    // todo : remove this shit

    _maximumAttempts = 1;
}

#pragma mark - Handle success and error properly

- (void)cleanupWithError:(NSString *)status message:(NSString *)message {

    MPLOGERROR(@"*** Cleaning up , status   [%@], message[%@]", status, message);
    MPLOGERROR(@"*** Cleaning up , route    %@[%@]", self.serverRequest.route, self.serverRequest.command);
    MPLOGERROR(@"*** Cleaning up , api key  [%@]", self.serverRequest.apiKey);
    MPLOGERROR(@"*** Cleaning up , dev guid [%@]", self.serverRequest.deviceGuid);
    if (self.serverRequest.parameters) {
        MPLOGERROR(@"*** Cleaning up , parameters\n%@", [self.serverRequest.parameters asJSON]);
    }
    if (_onEnd) _onEnd();
    if (!_wasResponseReceived) {
        self->_serverResponse           = [[EHRServerResponse alloc] init];
        _serverResponse.responseContent = [NSDictionary dictionary];
        _serverResponse.requestStatus   = [[EHRRequestStatus alloc] init];
    }
    _serverResponse.requestStatus.status  = status;
    _serverResponse.requestStatus.message = message;
    _serverResponse.requestStatus.command = self.serverRequest.command;
    _serverResponse.requestStatus.route   = self.serverRequest.route;
    _wasResponseReceived = YES;

    if (_onError) {
        _onError(self);
    }
    [self cleanupForNextCall];
    [[AppState sharedAppState] setNetworkActivityIndicatorVisible:NO];

}

- (void)cleanupWithSuccess {

    if (_onEnd) _onEnd();

    if (_onSuccess) {
        _onSuccess(self);
    }

    [self cleanupForNextCall];
    [[AppState sharedAppState] setNetworkActivityIndicatorVisible:NO];

}

- (void)cleanupForNextCall {

    // keep the _onSuccess and _onError blocks ... presumably this will be called again

    _isCallingServer     = NO;
    _wasResponseReceived = NO;
    _urlRequest          = nil;
    _urlConnection       = nil;
    _responseData        = nil;
    _attemptNumber       = 0;

    // do NOT destroy serverResponse, it is used by caller to figure out wtf
    // _serverResponse will be reset at top of next call

}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

    TRACE_KILLROY
    MPLOGERROR(@"*** URL connection to server failed with error [%@]", [error description]);
    MPLOGERROR(@"*** request is : \n%@", [self.serverRequest asJSON]);

    if (_attemptNumber >= self.maximumAttempts) {
        NSString *message = [NSString stringWithFormat:@"Failed on [%@] after [%ld] attempts", self.serverRequest.server.host, (unsigned long) self.maximumAttempts];
        [self cleanupWithError:@"HTTP_ERROR" message:message];
    } else {
        [self makeFreshURLconnection];
        [self performSelector:@selector(fireUrlConnection) withObject:nil afterDelay:.001f];
    }

}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
    TRACE_KILLROY

    if ([self.serverRequest.server.scheme isEqualToString:@"https"]) {
        TRACE(@"Using credentials for URL %@", _url.absoluteString);
        return YES;
    } else {
        return NO;
    }
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    TRACE_KILLROY
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
#pragma  unused(connection)

    TRACE_KILLROY
    /* Setup */
    NSURLProtectionSpace *protectionSpace = [challenge protectionSpace];
    assert(protectionSpace);
    SecTrustRef trust = [protectionSpace serverTrust];
    assert(trust);
    CFRetain(trust);                        // Don't know when ARC might release protectionSpace
    NSURLCredential *credential = [NSURLCredential credentialForTrust:trust];

    BOOL               trusted     = NO;
    OSStatus           err;
    SecTrustResultType trustResult = (SecTrustResultType) 0; // was 0

    err = SecTrustSetAnchorCertificates(trust, certs);
    if (err == noErr) {
        err = SecTrustEvaluate(trust, &trustResult);
        if (err == noErr) {
            // http://developer.apple.com/library/mac/#qa/qa1360/_index.html
            switch (trustResult) {
                case kSecTrustResultProceed:
//                case kSecTrustResultConfirm:
                case kSecTrustResultUnspecified:trusted = YES;
                    break;
                default:trusted = NO;
                    break;
            }
        }
    }
    CFRelease(trust);

    // Return based on whether we decided to trust or not
    if (trusted) {
        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
    } else {
        MPLOG(@"Trust evaluation failed");
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }

}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    TRACE_KILLROY
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
#ifndef NDEBUG
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
#else
    TSKPinningValidator *pinningValidator = [[TrustKit sharedInstance] pinningValidator];
    if (![pinningValidator handleChallenge:challenge
                         completionHandler:^(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential){
//        NSLog(@"disposition: %@", disposition);
        if (disposition == NSURLSessionAuthChallengeCancelAuthenticationChallenge) {
            [challenge.sender cancelAuthenticationChallenge:challenge];
        } else {
            [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
        }
    }])
    {
        [challenge.sender rejectProtectionSpaceAndContinueWithChallenge:challenge];
        return;
//    } else {
//        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
#endif
    TRACE_KILLROY
}

#pragma mark - NSUrlConnectionDataDelegate

- (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request {
    NSString *postString = [self.serverRequest asJSON];
    NSData   *postAsData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSInputStream inputStreamWithData:postAsData];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)response {

    // allow all redirects unmodified
    return request;
}

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response {

    // we are now getting   403'1 and 401's

    TRACE(@"Response : \n%@", [response description]);
    NSHTTPURLResponse *res = (NSHTTPURLResponse *) response;
    if (res.statusCode > 400) {
        MPLOGERROR(@"*** Request status : [%li]", (unsigned long) res.statusCode);
        MPLOGERROR(@"*** Requested URL  : [%@]", [_url description]);
        MPLOGERROR(@"*** Request        : \n%@", [_serverRequest asJSON]);
        if (_isCallingServer) {
            [_urlConnection cancel];
        }

        if (res.statusCode == 401) {
            MPLOGERROR(@"connectio did receive responst : AUTH damit");
            [self on401Barf];
            dispatch_async(dispatch_get_main_queue(), ^{
                MPLOGERROR(@"\nBroadcasting kAuthenticationFailure event !");
                [[NSNotificationCenter defaultCenter] postNotificationName:kAuthenticationFailure object:nil userInfo:nil];
                [self cleanupWithError:@"401" message:@"Authentication failure."];
            });
        } else {
            NSString *msg = [NSString stringWithFormat:@"Unknown error from server [%lu]",(long)res.statusCode];
            [self cleanupWithError:@"INTERNAL_ERROR" message:msg];
        }

    } else if (res.statusCode == 200) {
        TRACE(@"Got 200 from mr server.");
    }
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data {

    // we could receive chunks asyn, lets handle all chunks. When the server closes
    // we will receive a 'didReceiveResponse' where we can unpack the whole thing.

    [_responseData appendData:data];

}

- (void)       connection:(NSURLConnection *)connection
          didSendBodyData:(NSInteger)bytesWritten
        totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    TRACE(@"written : %lu, totalWritten : %lu ", (unsigned long) bytesWritten, (unsigned long) totalBytesWritten);
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse {

    // no caching allowed

    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

    TRACE(@"loading finished.");

    // all is complete here, nothing more will be received from the connection

    NSError      *error = nil;
    NSDictionary *dic   = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        MPLOG(@"*** Error encountered while deserializing JSON from server : %@", error.description);
        MPLOG(@"*** response_data is \n%@", [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding]);
        if (_attemptNumber >= self.maximumAttempts) {
            [self cleanupWithError:@"MALFORMED_JSON" message:error.description];
        } else {
            [self makeFreshURLconnection];
            [_urlConnection start];
        }
    } else {
        if (_verbose) {
            MPLOG(@"Received : \n%@", [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding]);
        } else {
            TRACE(@"Received : \n%@", [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding]);
        }
        self->_serverResponse = [EHRServerResponse objectWithContentsOfDictionary:dic];
        _wasResponseReceived = YES;

        if ([_serverResponse.requestStatus.status isEqualToString:@"OK"]) {
            [self cleanupWithSuccess];
        } else if ([_serverResponse.requestStatus.status isEqualToString:@"MAINTENANCE"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                MPLOGERROR(@"Broadcasting kServerMaintenance event !");
                [[NSNotificationCenter defaultCenter] postNotificationName:kServerMaintenance object:nil userInfo:nil];
                [self cleanupForNextCall];
            });
        } else if ([_serverResponse.requestStatus.status isEqualToString:@"APP_VERSION"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                MPLOGERROR(@"Broadcasting kAppMustUpdate event !");
                [[NSNotificationCenter defaultCenter] postNotificationName:kAppMustUpdate object:nil userInfo:nil];
                [self cleanupForNextCall];
            });
        } else if ([_serverResponse.requestStatus.status isEqualToString:@"AUTH_FAILED"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                MPLOGERROR(@"Broadcasting kAuthenticationFailure event !");
                NSDictionary *req = [self.serverRequest asDictionary];
                MPLOGERROR(@"The sent request which got a AUTH_FAILED\n%@", req);

                NSDictionary *serv = [self.serverRequest.server asDictionary];
                MPLOGERROR(@"The server which got a AUTH_FAILED\n%@", serv);

                MPLOGERROR(@"The creds : \n%@", [[[SecureCredentials sharedCredentials] asDictionary] asJSON]);

                [[NSNotificationCenter defaultCenter] postNotificationName:kAuthenticationFailure object:nil userInfo:nil];
                [self cleanupForNextCall];
            });
        } else {
            [self cleanupWithError:_serverResponse.requestStatus.status message:_serverResponse.requestStatus.message];
        }
    }

}

- (void)fireUrlConnection {
    TRACE_KILLROY
    [_urlConnection start];
}

- (void)makeFreshURLconnection {

    if (_urlConnection) _urlConnection = nil;
    if (_urlRequest) _urlRequest       = nil;

    _responseData   = [NSMutableData data];
    _serverResponse = nil;
    //NSURLRequestReloadIgnoringLocalCacheData
    //NSURLRequestUseProtocolCachePolicy
    _url            = [self.serverRequest.server urlForRoute:self.serverRequest.route];
    _urlRequest     = [NSMutableURLRequest requestWithURL:_url
                                              cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                          timeoutInterval:self.timeOut];
    [_urlRequest setHTTPMethod:@"POST"];

    NSString *postString = [self.serverRequest asJSON];
    TRACE(@"Sending to [%@]", [_url description]);
    TRACE(@"Sending %@", postString);

    [_urlRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [_urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [_urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    _urlConnection = [[NSURLConnection alloc] initWithRequest:_urlRequest
                                                     delegate:self];
#pragma clang diagnostic pop
    _attemptNumber++;

}

- (void)setOnStart:(VoidBlock)onStart {
    if (_onStart) _onStart = nil;
    _onStart = [onStart copy];
}

- (void)setOnEnd:(VoidBlock)onEnd {
    if (_onEnd) _onEnd = nil;
    _onEnd = [onEnd copy];
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end
