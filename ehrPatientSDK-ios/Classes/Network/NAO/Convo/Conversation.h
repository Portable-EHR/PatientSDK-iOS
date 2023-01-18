//
// Created by Yves Le Borgne on 2022-12-27.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "EHRNetworkableP.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

@class ConversationEntry;
@class ConversationEntry;
@class ConversationParticipant;

@interface Conversation : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;

    NSString *_id;
    NSString *_status;
    NSString *_location;
    NSString *_staffTitle;
    NSString *_clientTitle;

    NSMutableArray *_participants;
    NSMutableArray *_entries;

    NSMutableDictionary *_indexedParticipants;
    NSMutableDictionary *_indexedEntries;

    BOOL _hasMoreEntries;

}

- (ConversationParticipant *)partipantForEntry:(ConversationEntry *)entry __attribute__((unused));
- (ConversationParticipant *)myself __attribute__((unused));
- (void)addEntry:(ConversationEntry *)entry;
@property(nonatomic, readonly) NSMutableDictionary *indexedParticipants;
@property(nonatomic, readonly) NSMutableDictionary *indexedEntries;
@property(nonatomic) NSString                      *staffTitle;
@property(nonatomic) NSString                      *clientTitle;
@property(nonatomic) NSString                      *id;
@property(nonatomic) NSString                      *status;
@property(nonatomic) NSString                      *location;
@property(nonatomic) NSMutableArray                *participants;
@property(nonatomic) NSMutableArray                *entries;
@property(nonatomic) BOOL                          hasMoreEntries;
@property(nonatomic, readonly) BOOL                isOpen;
@property(nonatomic, readonly) BOOL                isClosed;

@end