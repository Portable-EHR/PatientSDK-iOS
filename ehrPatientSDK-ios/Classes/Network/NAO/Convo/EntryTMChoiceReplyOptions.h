//
//  EntryTMChoiceReplyOptions.h
//  EHRPatientSDK
//
//  Created by Vinay on 2023-09-19.
//

#ifndef EntryTMChoiceReplyOptions_h
#define EntryTMChoiceReplyOptions_h

#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "EHRNetworkableP.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

@interface EntryTMChoiceReplyOptions : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSString  *_id;
    NSString  *_choiceLabel;
}
@property(nonatomic) NSString *id;
@property(nonatomic) NSString *choiceLabel;

@end

#endif /* EntryTMChoiceReplyOptions_h */
