//
//  Study.h
//  EHRPatientSDK
//
//  Created by Vinay on 2025-01-06.
//

#ifndef Study_h
#define Study_h

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "EHRInstanceCounterP.h"
#import "IBStudy.h"
#import "IBConsentable.h"
#import "IBDispensaryInf.h"


@interface Study : NSObject <EHRInstanceCounterP,EHRPersistableP> {
    NSInteger _instanceNumber;
}

@property IBStudy *IBStudy;
@property IBConsentable *consentable;
@property IBDispensaryInf *dispensaryInf;

@end

#endif /* Study_h */
