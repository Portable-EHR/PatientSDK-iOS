//
//  EntryMentionedParticipants.h
//  EHRPatientSDK
//
//  Created by Vinay on 2023-09-19.
//

#ifndef EntryMentionedParticipants_h
#define EntryMentionedParticipants_h

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "EHRNetworkableP.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

@interface EntryMentionedParticipants : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSString  *_participantId;
    NSString  *_reminder;
    NSString  *_reminderState;
}

@property(nonatomic) NSString *participantId;
@property(nonatomic) NSString *reminder;
@property(nonatomic) NSString *reminderState;
@end

#endif /* EntryMentionedParticipants_h */
