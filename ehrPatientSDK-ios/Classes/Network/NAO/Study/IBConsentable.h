//
//  IBConsentable.h
//  EHRPatientSDK
//
//  Created by Vinay on 2025-01-06.
//

#ifndef IBConsentable_h
#define IBConsentable_h

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "EHRInstanceCounterP.h"
#import "IBConsentGranted.h"

@interface IBConsentable : NSObject <EHRInstanceCounterP,EHRPersistableP> {
    NSInteger _instanceNumber;
    IBConsentGranted *_consent;
}

@property (nonatomic) NSString *active;
@property (nonatomic) NSString *guid;
@property(nonatomic) IBConsentGranted *consent;
- (IBConsentGranted *)__unused getGrantedConsent;

@end

#endif /* IBConsentable_h */
