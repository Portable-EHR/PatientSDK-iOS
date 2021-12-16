//
//  IBConsentInfo.h
//  ehrPatientSDK-ios
//
//

#ifndef IBConsentInfo_h
#define IBConsentInfo_h

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRNetworkableP.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

@interface IBConsentInfo : NSObject <EHRInstanceCounterP, EHRNetworkableP, EHRPersistableP> {
    NSInteger    _instanceNumber;
    NSString     *_renderer;
    NSString     *_text;
}

@property(nonatomic) NSString     *renderer;
@property(nonatomic) NSString     *text;

@end


#endif /* IBConsentInfo_h */
