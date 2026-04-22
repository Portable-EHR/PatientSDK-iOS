//
// Created by Yves Le Borgne on 2023-03-28.
//

#import "EHRState.h"
#import "PehrSDKConfig.h"
#import "Models.h"
#import "UserModel.h"

@interface EHRState () {
    NSInteger                       _instanceNumber;
    IBAppInfo                       *_app;
    IBDeviceInfo                    *_device;
    IBUser                          *_user;
    SecureCredentials               *_secureCredentials;
    id <EHRLibStateDelegate> __weak _delegate;
}
@end

@implementation EHRState

@dynamic isSDKusable;

- (BOOL)isSDKusable {
    return (_delegate != nil) &&
            PehrSDKConfig.shared.models.userModel.isSDKuserUsable;
}

TRACE_OFF

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        _app               = [[IBAppInfo alloc] init];
        _device            = [IBDeviceInfo initFromDevice];
        _user              = [IBUser guest];
        _secureCredentials = [SecureCredentials sharedCredentials];
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

- (void)dealloc {
    _app               = nil;
    _device            = nil;
    _user              = nil;
    _secureCredentials = nil;
    _delegate          = nil;
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

//region API
- (void)setDelegate:(id <EHRLibStateDelegate>)delegate {
    _delegate = delegate;
}
@end