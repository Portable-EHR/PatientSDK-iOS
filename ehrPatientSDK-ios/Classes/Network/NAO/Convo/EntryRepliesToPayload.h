//
//  EntryRepliesToPayload.h
//  EHRPatientSDK
//
//  Created by Vinay on 2023-10-02.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "EHRNetworkableP.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

@interface EntryRepliesToPayload : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
    NSString  *_text;

}

@property(nonatomic) NSString *text;

@end
