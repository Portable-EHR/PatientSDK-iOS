//
// Created by Yves Le Borgne on 2023-01-08.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "EHRNetworkableP.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

@interface EntryMovePayload : NSObject <EHRInstanceCounterP, EHRNetworkableP> {

}

@property(nonatomic) NSString *fromLocation;
@property(nonatomic) NSString *toLocation;

@end