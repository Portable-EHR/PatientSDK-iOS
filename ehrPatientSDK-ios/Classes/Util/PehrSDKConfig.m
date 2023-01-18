//
//  PehrSDKConfig.m
//  ehrPatientSDK-ios
//
//  Created by Rahul Asthana on 20/09/21.
//

#import "WebServices.h"

@interface PehrSDKConfig () {

    @private
    __strong NSString
            *_deviceLanguage,
            *_appGuid,
            *_appAlias,
            *_appVersion,
            *_stackKey,
            *_localIPaddress;

    @private
    __strong WebServices *_ws;
}

@end

@implementation PehrSDKConfig

static PehrSDKConfig *_Instance = nil;


TRACE_OFF

- (id)init {

    self = [super init];
    if (self) {

        GE_ALLOC();
        _ws          =   [[WebServices alloc] init];
        _deviceLanguage = [[NSLocale preferredLanguages][0] componentsSeparatedByString:@"-"][0];

    } else {
        TRACE(@"*** super returned nil !");
    }
    return self;

}

+ (PehrSDKConfig *)shared {

    static dispatch_once_t once;
    static PehrSDKConfig   *_Instance;
    dispatch_once(&once, ^{
        _Instance = [[PehrSDKConfig alloc] init];

    });
    return _Instance;

}

- (WebServices *) ws __attribute__((unused)) {
    return _ws;
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

- (NSString *)getLocalIPaddress {
    return _localIPaddress;
}

- (NSString *)getDeviceLanguage {
    return _deviceLanguage;
}

- setup:(NSString *)appGuid appAlias:(NSString *)appAlias appVersion:(NSString *)appVersion stackKey:(NSString *)stackKey __unused {
    self->_appGuid        = appGuid;
    self->_appAlias       = appAlias;
    self->_appVersion     = appVersion;
    self->_stackKey       = stackKey;
    self->_localIPaddress = nil;

    [GERuntimeConstants initialize];
    [GERuntimeConstants setAppGuid:appGuid];
    [GERuntimeConstants setAppAlias:appAlias];
    [GERuntimeConstants setAppVersion:appVersion];
    [GERuntimeConstants setStackKey:stackKey];
    [GERuntimeConstants setBuildNumber:10]; // todo : figure out this old dependency (from MaxPower Game Engine)


    return self;
}

- setup:(NSString *)appGuid appAlias:(NSString *)appAlias appVersion:(NSString *)appVersion localIPaddress:(NSString *)address  __unused {
    self->_appGuid        = appGuid;
    self->_appAlias       = appAlias;
    self->_appVersion     = appVersion;
    self->_stackKey       = @"CA.local";
    self->_localIPaddress = address;

    [GERuntimeConstants initialize];
    [GERuntimeConstants setAppGuid:appGuid];
    [GERuntimeConstants setAppAlias:appAlias];
    [GERuntimeConstants setAppVersion:appVersion];
    [GERuntimeConstants setLocalIPaddress:address];
    kHostNames[@"CA.local"] = address;
    [GERuntimeConstants setBuildNumber:10]; // todo : figure out this old dependency (from MaxPower Game Engine)


    return self;
}

@end

