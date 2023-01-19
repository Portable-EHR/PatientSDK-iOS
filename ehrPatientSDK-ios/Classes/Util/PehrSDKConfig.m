//
//  PehrSDKConfig.m
//  ehrPatientSDK-ios
//
//  Created by Rahul Asthana on 20/09/21.
//

#import "PehrSDKConfig.h"
#import "GEMacros.h"
#import <TrustKit/TrustKit.h>

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
    [self performPinning];
    return self;
}


- (void)performPinning {
    
    NSArray * publicKeyHashes = @[
        @"++MBgDH5WGvL9Bcn5Be30cRcL0f5O+NyoXuWtQdX1aI=",
        @"f0KW/FtqTjs108NpYj42SrGvOB2PpxIVM8nWxjPqJGE=",
        @"NqvDJlas/GRcYbcWE8S/IceH9cq77kg0jVhZeAPXq8k=",
        @"9+ze1cZgR9KO1kZrVDxA4HQ6voHRCSVNz4RdTCx4U8U=",
        @"KwccWaCgrnaw6tsrrSO61FgLacNgG2MMLq8GE6+oP5I=",
    ];
    NSDictionary *trustKitConfig =
    @{
      // The list of domains we want to pin and their configuration
      kTSKPinnedDomains: @{
              
              @"api.portableehr.ca" : @{
                      kTSKIncludeSubdomains:@YES,
                      kTSKEnforcePinning:@YES,
                      kTSKPublicKeyHashes : publicKeyHashes,
                      kTSKPublicKeyAlgorithms : @[kTSKAlgorithmRsa2048],
              },
              
              @"api.portableehr.net" : @{
                      kTSKIncludeSubdomains:@YES,
                      kTSKEnforcePinning:@YES,
                      kTSKPublicKeyHashes : publicKeyHashes,
                      kTSKPublicKeyAlgorithms : @[kTSKAlgorithmRsa2048],
              },
              
              @"api.portableehr.io" : @{
                      kTSKIncludeSubdomains:@YES,
                      kTSKEnforcePinning:@YES,
                      kTSKPublicKeyHashes : publicKeyHashes,
                      kTSKPublicKeyAlgorithms : @[kTSKAlgorithmRsa2048],
              }
    }};
    [TrustKit initSharedInstanceWithConfiguration:trustKitConfig];
}


@end

