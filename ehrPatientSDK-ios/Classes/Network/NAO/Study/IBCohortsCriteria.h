//
//  IBCohortsCriteria.h
//  EHRPatientSDK
//
//  Created by Vinay on 2025-01-07.
//

#ifndef IBCohortsCriteria_h
#define IBCohortsCriteria_h

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "EHRInstanceCounterP.h"

@interface IBCohortsCriteria : NSObject <EHRInstanceCounterP,EHRPersistableP> {
    NSInteger _instanceNumber;
}

@property (nonatomic) NSString *gender;
@property (nonatomic) NSString *minimumAge;
@property (nonatomic) NSString *maximumAge;

@end


#endif /* IBCohortsCriteria_h */
