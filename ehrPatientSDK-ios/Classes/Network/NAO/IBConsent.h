//
//  IBConsent.h
//  ehrPatientSDK-ios
//
//

#ifndef IBConsent_h
#define IBConsent_h

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRNetworkableP.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"
#import "IBConsentInfo.h"
#import "IBConsentGranted.h"

@interface IBConsent : NSObject <EHRInstanceCounterP, EHRNetworkableP, EHRPersistableP> {
    NSInteger        _instanceNumber;
    NSString         *_guid;
    NSString         *_alias;
    NSString         *_consentableElementType;
    BOOL             _active;
    NSString         *_activeFrom;
    IBConsentInfo    *_title;
    IBConsentInfo    *_descriptionText;
    IBConsentGranted *_consent;
}

@property(nonatomic) NSString         *guid;
@property(nonatomic) NSString         *alias;
@property(nonatomic) NSString         *consentableElementType;
@property(nonatomic) NSString         *activeFrom;
@property(nonatomic) IBConsentInfo    *title;
@property(nonatomic) IBConsentInfo    *descriptionText;
@property(nonatomic) IBConsentGranted *consent;
@property(nonatomic) BOOL             active;

- (IBConsentGranted *)getGrantedConsent;

@end

#endif /* IBConsent_h */
