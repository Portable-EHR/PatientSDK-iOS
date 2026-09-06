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
    NSInteger attachmentCount;
    NSArray *_questionnaires;
}

@property(nonatomic) NSString *text;
@property(nonatomic) NSInteger attachmentCount;
@property(nonatomic) NSArray *questionnaires;
@end
