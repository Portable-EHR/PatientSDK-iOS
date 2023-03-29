//
//  PehrSDKConfig.h
//  ehrPatientSDK-ios
//
//  Created by Rahul Asthana on 20/09/21.
//

#ifndef EHRLib_PehrSDKConfig_h
#define EHRLib_PehrSDKConfig_h

#import <Foundation/Foundation.h>

//typedef void(^VoidBlock)(void);
//typedef void(^SenderBlock)(id call);
//typedef void(^NSErrorBlock)(NSError *);
#import "EHRState.h"
#import "EHRLibRuntimeGlobals.h"

//#import "EHRUserRegistrationManifest.h"


@class WebServices;
@class Models;
@class Version;
@class IBAppInfo;
@class EHRUserRegistrationManifest;

@interface PehrSDKConfig : NSObject {
    @private
    __strong NSString
            *_appGuid,
            *_appAlias,
            *_appVersion,
            *_stackKey,
            *_localIPaddress,
            *_deviceLanguage;

    @private
    __strong  Models *_models;
    @private
    __strong WebServices *_ws;

    @private
    IBAppInfo *_appInfo;

    @private
    EHRState *_state;
}


+ (PehrSDKConfig *)shared;

@property(nonatomic, readonly) NSString *deviceLanguage;

- (NSString *)getAppGuid;
- (NSString *)getAppAlias;
- (Version *)getAppVersion;
- (NSString *)getAppStackKey;
- (NSString *)getLocalIPaddress;

- (WebServices *)ws __attribute__((unused));
- (Models *)models  __attribute__((unused));
- (EHRState *)state  __attribute__((unused));

- (void)startWithCompletion:(VoidBlock)successBlock
                    onError:(VoidBlock)errorBlock;
- (void)stopWithCompletion:(VoidBlock)successBlock
                   onError:(VoidBlock)errorBlock;
- (void)registerUser:(EHRUserRegistrationManifest *)manifest
           onSuccess:(VoidBlock)successBlock
             onError:(VoidBlock)errorBlock;
- (void)deregisterUserWithCompletion:(VoidBlock)successBlock
                             onError:(VoidBlock)errorBlock;

-
delegate:(id <EHRLibStateDelegate>)delegate
   appGuid:(NSString *)appGuid
  appAlias:(NSString *)appAlias
appVersion:(NSString *)appVersion
  stackKey:(NSString *)stackKey
 onSuccess:(SenderBlock)successBlock
   onError:(SenderBlock)errorBlock;

-
delegate:(id <EHRLibStateDelegate>)delegate appGuid:(NSString *)appGuid
      appAlias:(NSString *)appAlias
    appVersion:(NSString *)appVersion
localIPaddress:(NSString *)address
     onSuccess:(SenderBlock)successBlock
       onError:(SenderBlock)errorBlock;

@end


#endif /* EHRLib_PehrSDKConfig_h */
