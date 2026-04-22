//
//  IBConsentGranted.h
//  ehrPatientSDK-ios
//
//

#ifndef IBConsentGranted_h
#define IBConsentGranted_h

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "EHRNetworkableP.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

@interface IBConsentGranted : NSObject <EHRInstanceCounterP, EHRNetworkableP, EHRPersistableP> {
    NSInteger    _instanceNumber;
    NSString     *_guid;
    NSString     *_user_guid;
    NSString     *_patient_guid;
    NSString     *_givenOn;
}

@property(nonatomic) NSString     *guid;
@property(nonatomic) NSString     *user_guid;
@property(nonatomic) NSString     *patient_guid;
@property(nonatomic) NSString     *givenOn;

@end

#endif /* IBConsentGranted_h */
