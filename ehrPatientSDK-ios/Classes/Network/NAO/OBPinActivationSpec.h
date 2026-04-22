//
//  OBPinActivationSpec.h
//  EHRPatientSDK
//
//  Created by Vinay on 2023-10-18.
//

#ifndef OBPinActivationSpec_h
#define OBPinActivationSpec_h

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRNetworkableP.h"
#import "GERuntimeConstants.h"

@interface OBPinActivationSpec : NSObject <EHRNetworkableP, EHRInstanceCounterP> {
    NSInteger _instanceNumber;
}

@property(nonatomic) NSString *mobilePhone;
@property(nonatomic) NSString *activationPin;
@end

#endif /* OBPinActivationSpec_h */
