//
//  IBStackName.h
//  EHRPatientSDK
//
//  Created by Vinay on 2025-10-13.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRNetworkableP.h"

@interface IBStackName : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
}

@property(nonatomic) NSString *en;
@property(nonatomic) NSString *es;
@property(nonatomic) NSString *fr;
@end
