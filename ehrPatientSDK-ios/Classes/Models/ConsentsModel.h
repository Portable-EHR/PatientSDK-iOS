//
// Created by Yves Le Borgne on 2023-04-07.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "GERuntimeConstants.h"
#import "EHRLibRuntimeGlobals.h"

@class IBConsent;

@interface ConsentsModel : NSObject <EHRInstanceCounterP> {
    NSInteger _instanceNumber;

}

+ (instancetype _Nonnull)instance;
- (NSArray <IBConsent *> *_Nonnull)allConsents;  // not mutable, not dictionary
- (IBConsent *_Nullable)consentWithGuid:(NSString * _Nonnull)guid;
- (NSInteger)count;
- (IBConsent *_Nullable)getEula;
- (IBConsent *_Nullable)getCCRP;

- (void)populateWithConsents:(NSArray<IBConsent *> * _Nonnull)pulledConsents;

@end