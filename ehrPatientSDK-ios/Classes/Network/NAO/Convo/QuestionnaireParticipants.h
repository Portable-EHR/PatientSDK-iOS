//
//  QuestionnaireParticipants.h
//  EHRPatientSDK
//
//  Created by Vinay on 2024-09-17.
//

#ifndef QuestionnaireParticipants_h
#define QuestionnaireParticipants_h

#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "EHRNetworkableP.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

@interface QuestionnaireParticipants : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSString  *_participantUUID;
    NSString  *_token;
    NSString  *_status;
}
@property(nonatomic) NSString *participantUUID;
@property(nonatomic) NSString *token;
@property(nonatomic) NSString *status;

@end

#endif /* QuestionnaireParticipants_h */
