//
//  IBResponder.h
//  EHRPatientSDK
//
//  Created by Vinay on 2025-02-18.
//

#import <Foundation/Foundation.h>
#import "EHRNetworkableP.h"
#import "EHRInstanceCounterP.h"

@interface IBResponder : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
}

@property(nonatomic) NSString *relationship;
@property(nonatomic) NSString *patientGuid;


@end
