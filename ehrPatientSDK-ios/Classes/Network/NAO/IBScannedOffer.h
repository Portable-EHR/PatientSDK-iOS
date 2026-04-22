//
// Created by Yves Le Borgne on 2023-04-05.
//

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "EHRNetworkableP.h"
#import "EHRInstanceCounterP.h"
#import "GERuntimeConstants.h"

@interface IBScannedOffer : NSObject <EHRInstanceCounterP, EHRNetworkableP, EHRPersistableP> {
    NSInteger _instanceNumber;
}

@property(nonatomic) NSString *scannedHost;
@property(nonatomic) NSString *scannedCode;
@property(nonatomic) NSString *scanReasonCode;

@end