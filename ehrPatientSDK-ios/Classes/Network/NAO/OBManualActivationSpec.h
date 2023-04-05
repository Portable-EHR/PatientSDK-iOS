//
// Created by Yves Le Borgne on 2023-04-05.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRNetworkableP.h"
#import "GERuntimeConstants.h"

@interface OBManualActivationSpec :  NSObject <EHRNetworkableP, EHRInstanceCounterP> {
    NSInteger _instanceNumber;
}
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *HCIN;
@property (nonatomic) NSString *HCINjurisdiction;
@property (nonatomic) NSString *mobilePhone;
@end