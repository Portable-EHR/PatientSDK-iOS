//
//  PehrSDKConfig.h
//  ehrPatientSDK-ios
//
//  Created by Rahul Asthana on 20/09/21.
//

#import "Version.h"

@interface PehrSDKConfig : NSObject {

    @private
    __strong NSString
            *_appGuid,
            *_appAlias,
            *_appVersion,
            *_stackKey;

}

+ (PehrSDKConfig *)shared;

- (NSString *)getAppGuid;
- (NSString *)getAppAlias;
- (Version *)getAppVersion;
- (NSString *)getAppStackKey;

- setup:(NSString *)appGuid appAlias:(NSString *)appAlias appVersion:(NSString *)appVersion stackKey:(NSString *)stackKey;

@end
