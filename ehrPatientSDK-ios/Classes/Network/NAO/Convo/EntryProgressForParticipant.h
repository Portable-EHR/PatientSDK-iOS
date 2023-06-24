//
// Created by Yves Le Borgne on 2023-06-23.
//

#import <Foundation/Foundation.h>
#import "ConversationEntry.h"
#import "ConversationParticipant.h"
#import "EntryParticipantStatus.h"
#import "Conversation.h"

@interface EntryProgressForParticipant : NSObject <EHRInstanceCounterP> {

}

+ (instancetype) forEntry:(ConversationEntry *)entry andParticipant:(ConversationParticipant *)participant inConversation:(Conversation *)conversation;

@property(nonatomic) ConversationEntry                        *entry;
@property(nonatomic) ConversationParticipant                  *participant;
@property(nonatomic) Conversation                             *conversation;
@property(nonatomic) NSMutableArray<EntryParticipantStatus *> *statusLines;
@property(nonatomic) EntryParticipantStatus                   *latestStatusLine;
@property(nonatomic) EntryProgress                            currentProgress;

- (EntryParticipantStatus*)setProgress:(EntryProgress)progress;
- (EntryParticipantStatus*)setProgress:(EntryProgress)progress date:(NSDate *)date;

@end