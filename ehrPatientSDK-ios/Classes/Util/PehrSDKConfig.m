//
//  PehrSDKConfig.m
//  ehrPatientSDK-ios
//
//  Created by Rahul Asthana on 20/09/21.
//

#import "PehrSDKConfig.h"
#import "GEMacros.h"

@implementation PehrSDKConfig

static PehrSDKConfig *_Instance = nil;

TRACE_OFF

- (id)init {

    self = [super init];
    if (self) {

        GE_ALLOC();

    } else {
        TRACE(@"*** super returned nil !");
    }
    return self;

}

+ (PehrSDKConfig *)shared {

    static dispatch_once_t once;
    static PehrSDKConfig      *_Instance;
    dispatch_once(&once, ^{
        _Instance = [[PehrSDKConfig alloc] init];

    });
    return _Instance;

}

- (NSString *)getAppGuid {
    return _appGuid;
}

- (NSString *)getAppAlias {
    return _appAlias;
}

- (Version *)getAppVersion {
    return [Version versionWithString:_appVersion];
}

- (NSString *)getAppStackKey {
    return _stackKey;
}

- setup:(NSString *)appGuid appAlias:(NSString *)appAlias appVersion:(NSString *)appVersion stackKey:(NSString *)stackKey __unused {
    self->_appGuid = appGuid;
    self->_appAlias = appAlias;
    self->_appVersion = appVersion;
    self->_stackKey = stackKey;
    return self;
}


@end

