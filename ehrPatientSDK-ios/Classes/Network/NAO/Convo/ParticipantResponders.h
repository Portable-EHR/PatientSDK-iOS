//
//  ParticipantResponders.h
//  EHRPatientSDK
//
//  Created by Vinay on 2025-03-27.
//

#ifndef ParticipantResponders_h
#define ParticipantResponders_h

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "EHRNetworkableP.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"
#import "IBContact.h"

@interface ParticipantResponders : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    
    NSInteger _instanceNumber;
    
    
}

@property(nonatomic) IBContact      *contact;
@property(nonatomic) NSString       *guid;

@end
#endif /* ParticipantResponders_h */
