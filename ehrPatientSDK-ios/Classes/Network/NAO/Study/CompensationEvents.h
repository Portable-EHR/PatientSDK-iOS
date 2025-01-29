//
//  CompensationEvents.h
//  EHRPatientSDK
//
//  Created by Vinay on 2025-01-09.
//

#ifndef CompensationEvents_h
#define CompensationEvents_h

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "EHRNetworkableP.h"

@interface CompensationEvents : NSObject <EHRInstanceCounterP, EHRPersistableP> {

//    NSDictionary   *_description;
    
}

@property(nonatomic) NSInteger amount;
@property(nonatomic) NSString *guid;
@property(nonatomic) NSDictionary *eventDescription;

@end

#endif /* CompensationEvents_h */
