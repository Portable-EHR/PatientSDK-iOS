//
//  IBStudy.h
//  EHRPatientSDK
//
//  Created by Vinay on 2025-01-03.
//

#ifndef IBStudy_h
#define IBStudy_h

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "EHRInstanceCounterP.h"
#import "IBCohorts.h"
#import "IBCompensation.h"

@interface IBStudy : NSObject <EHRInstanceCounterP,EHRPersistableP> {
    NSInteger _instanceNumber;
}

@property (nonatomic) NSString *plannedStart;
@property (nonatomic) NSString *plannedCompletion;
@property (nonatomic) NSInteger plannedVisits;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *progress;
@property (nonatomic) NSString *guid;
@property (nonatomic) NSArray  *cohorts;
@property (nonatomic) IBCompensation  *compensation;

@end

#endif /* IBStudy_h */
