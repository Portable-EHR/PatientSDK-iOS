//
// Created by Yves Le Borgne on 2023-01-30.
//

#import "EHRLibState.h"
#import "EHRPersistableP.h"
#import "IBAppInfo.h"
#import "IBDeviceInfo.h"
#import "IBUser.h"

@interface EHRLibState () {
    NSInteger    _instanceNumber;
    IBAppInfo    *_app;
    IBDeviceInfo *_device;
    IBUser       *_user;
}
@end;

@implementation EHRLibState

TRACE_ON

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        _app    = [[IBAppInfo alloc] init];
        _device = [IBDeviceInfo initFromDevice];
        _user   = [IBUser guest];
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

- (void)dealloc {
    _app    = nil;
    _device = nil;
    _user   = nil;

    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end