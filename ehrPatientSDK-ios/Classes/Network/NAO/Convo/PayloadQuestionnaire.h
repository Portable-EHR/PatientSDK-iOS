//
//  PayloadQuestionnaire.h
//  EHRPatientSDK
//
//  Created by Vinay on 2024-09-16.
//

#ifndef PayloadQuestionnaire_h
#define PayloadQuestionnaire_h


#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "EHRNetworkableP.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

@interface PayloadQuestionnaire : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSString  *_surveyId;
    NSString  *_title;
    NSArray   *_participants;
}
@property(nonatomic) NSString *surveyId;
@property(nonatomic) NSString *title;
@property(nonatomic) NSArray  *participants;

@end

#endif /* PayloadQuestionnaire_h */
