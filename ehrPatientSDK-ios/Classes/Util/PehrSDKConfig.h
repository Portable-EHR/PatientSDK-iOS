//
//  PehrSDKConfig.h
//  ehrPatientSDK-ios
//
//  Created by Rahul Asthana on 20/09/21.
//

#import <Foundation/Foundation.h>

#import "Version.h"

@class WebServices;

@interface PehrSDKConfig : NSObject

+ (PehrSDKConfig *)shared;

- (NSString *)getAppGuid;
- (NSString *)getAppAlias;
- (Version *)getAppVersion;
- (NSString *)getAppStackKey;
- (NSString *)getLocalIPaddress;
- (NSString *)getDeviceLanguage;

- (WebServices *) ws __attribute__((unused));

-    setup:(NSString *)appGuid
  appAlias:(NSString *)appAlias
appVersion:(NSString *)appVersion
  stackKey:(NSString *)stackKey;

-        setup:(NSString *)appGuid
      appAlias:(NSString *)appAlias
    appVersion:(NSString *)appVersion
localIPaddress:(NSString *)address;

@end
