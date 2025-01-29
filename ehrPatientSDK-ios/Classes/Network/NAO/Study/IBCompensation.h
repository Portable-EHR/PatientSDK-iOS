//
//  IBCompensation.h
//  EHRPatientSDK
//
//  Created by Vinay on 2025-01-09.
//

#ifndef IBCompensation_h
#define IBCompensation_h

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "EHRInstanceCounterP.h"

@interface IBCompensation : NSObject <EHRInstanceCounterP,EHRPersistableP> {
    NSInteger _instanceNumber;
}

@property (nonatomic) NSString *guid;
@property (nonatomic) NSInteger maximum;
@property (nonatomic) NSArray *events;

@end

#endif /* IBCompensation_h */
