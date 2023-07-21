//
// Created by Yves Le Borgne on 2022-12-27.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "EHRNetworkableP.h"
#import "NSDictionary+JSON.h"
#import "EntryMessagePayload.h"
#import "EntryParticipantStatus.h"
#import "EntryProgressForParticipant.h"
#import "ConversationParticipant.h"
#import "Conversation.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wignored-attributes"
@class EntryMessagePayload;
@class EntryProgressForParticipant;

typedef enum : NSInteger {
    EntryTypeMessage,
    EntryTypeShare,
    EntryTypeParticipant,
    EntryTypeMove,
    EntryTypeStatusChange,
    EntryTypeUnknown
} EntryType;

@interface ConversationEntry : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger                                _instanceNumber;
    NSString                                 *_id;
    NSString                                 *_from;
    NSString                                 *_type;
    NSString                                 *_audience;
    NSInteger                                _attachmentCount;
    NSMutableArray<EntryParticipantStatus *> *_status;
    EntryMessagePayload                      *_messageEntryPayload;
    NSDate                                   *_createdOn;
}

@property(nonatomic) NSString                                 *id;
@property(nonatomic) NSString                                 *from;
@property(nonatomic) NSString                                 *type;
@property(nonatomic) NSString                                 *audience __unused;
@property(nonatomic) NSMutableArray<EntryParticipantStatus *> *status;
@property(nonatomic) NSInteger                                attachmentCount __unused;
@property(nonatomic) id                                       payload __unused;
@property(nonatomic) NSDate                                   *createdOn;
@property(nonatomic) EntryType                                entryType __unused;
@property(nonatomic, readonly) BOOL                           isMessageType;
@property(nonatomic, readonly) BOOL                           isParticipantType;
@property(nonatomic, readonly) BOOL                           isMoveType;
@property(nonatomic, readonly) BOOL                           isStatusChangeType;
@property(nonatomic, readonly) BOOL                           isShareType __unused;
@property(nonatomic) BOOL                                     isInView __unused; // utility, not to be persisted, defaults false
@property(nonatomic) BOOL                                     wasSeen __unused;  // utility, in support of visibility assessment

- (void)addStatusLine:(EntryParticipantStatus *)statusLine __attribute__((unused));
- (EntryProgressForParticipant *)progressForParticipant:(ConversationParticipant *)participant ofConvo:(Conversation*) conversation;
@end

#pragma clang diagnostic pop