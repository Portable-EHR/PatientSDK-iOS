//
//  EntryTMPossibleReplyTypes.h
//  EHRPatientSDK
//
//  Created by Vinay on 2023-09-19.
//

#ifndef EntryTMPossibleReplyTypes_h
#define EntryTMPossibleReplyTypes_h

#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "EHRNetworkableP.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

@interface EntryTMPossibleReplyTypes : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSString  *_possibleRepliesTypes;
}
@property(nonatomic) NSString *possibleRepliesTypes;
@end

#endif /* EntryTMPossibleReplyTypes_h */
