//
//  IBCohorts.h
//  EHRPatientSDK
//
//  Created by Vinay on 2025-01-07.
//

#ifndef IBCohorts_h
#define IBCohorts_h

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "EHRInstanceCounterP.h"
#import "IBCohortsCriteria.h"

@interface IBCohorts : NSObject <EHRInstanceCounterP,EHRPersistableP> {
    NSInteger _instanceNumber;
}

//@property IBCohortsCriteria *cohortsCriteria;
@property (nonatomic) NSString *gender;
@property (nonatomic) NSString *minimumAge;
@property (nonatomic) NSString *maximumAge;

@property (nonatomic) NSString *size;

@end

#endif /* IBCohorts_h */
