//
// Created by Yves Le Borgne on 2023-06-23.
//

#import "EntryProgressForParticipant.h"
#import "GERuntimeConstants.h"

@interface EntryProgressForParticipant () {
    NSInteger                                _instanceNumber;
    Conversation                             *_conversation;
    ConversationEntry                        *_entry;
    ConversationParticipant                  *_participant;
    NSMutableArray<EntryParticipantStatus *> *_statusLines;
}
@end

@implementation EntryProgressForParticipant

@synthesize entry = _entry;
@synthesize participant = _participant;
@synthesize conversation = _conversation;
@dynamic latestStatusLine;
@dynamic currentProgress;
@dynamic statusLines;

//region getters, business

- (NSMutableArray<EntryParticipantStatus *> *)statusLines {
    return _statusLines;
}

/**
 *
 * not trusting the time stamps, go at this logically from highest
 * progress down to lowest. Convo backend is missing some 'sent' entries
 * so fuckit
 *
 * @return EntryProgress
 */
- (EntryProgress)currentProgress {
    if (_statusLines.count==0) return EntryProgressInvalid;
    if ([self hasLineForProgress:EntryProgressAcked]) return EntryProgressAcked;
    if ([self hasLineForProgress:EntryProgressRead]) return EntryProgressRead;
    if ([self hasLineForProgress:EntryProgressReceived]) return EntryProgressReceived;
    if ([self hasLineForProgress:EntryProgressSent]) return EntryProgressSent;
    return EntryProgressInvalid;
}

-(BOOL) hasLineForProgress:(EntryProgress) strawman {
    for (NSUInteger i = 0; i < _statusLines.count ; ++i) {
        EntryParticipantStatus *line = _statusLines[i];
        if(line.progress==strawman) return YES;
    }
    return NO;
}

- (EntryParticipantStatus *)setProgress:(EntryProgress)progress {
    return [self setProgress:progress date:[NSDate date]];
}

- (EntryParticipantStatus *)setProgress:(EntryProgress)progress date:(NSDate *)date {
    if (!_entry) {
        MPLOGERROR(@"invoked before entry was set !");
        return nil;
    }

    EntryProgress          current = [self currentProgress];
    EntryParticipantStatus *new;
    if (progress > current) {
        new = [[EntryParticipantStatus alloc] init];
        new.entryId             = _entry.id;
        new.progress            = progress;
        new.date                = date;
        new.participantId       = _participant.guid;
        new.shouldSendToBackend = YES;
        [self.entry addStatusLine:new];
        [self addStatusLine:new];
    } else {
        TRACE(@"Attempting to set progress to an earlier stage, ignored !");
    }
    return new;
}

//endregion

TRACE_ON

+ (instancetype)forEntry:(ConversationEntry *)entry andParticipant:(ConversationParticipant *)participant inConversation:(Conversation *)conversation {
    EntryProgressForParticipant *eppp = [[self alloc] init];
    if (eppp) {
        eppp->_entry        = entry;
        eppp->_participant  = participant;
        eppp->_statusLines  = [NSMutableArray array];
        eppp->_conversation = conversation;

        for (EntryParticipantStatus *status in entry.status) {
            if ([status.participantId isEqualToString:participant.guid]) {
                [eppp->_statusLines addObject:status];
            }
        }
        [eppp sortOnStatusDate];

    } else {
        TRACE(@"*** super returned nil!");
    }
    return eppp;
}

- (void)addStatusLine:(EntryParticipantStatus *)statusLine {

    [_entry addStatusLine:statusLine];
    [_statusLines addObject:statusLine];
    [self sortOnStatusDate];
}

- (void)sortOnStatusDate {

    NSMutableArray   *unsorted = _statusLines;
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                 ascending:YES];
    NSArray *sortedArray = [unsorted sortedArrayUsingDescriptors:@[sortDescriptor]];
    _statusLines = [NSMutableArray arrayWithArray:sortedArray];

}

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
    [_statusLines removeAllObjects];
    _entry        = nil;
    _participant  = nil;
    _statusLines  = nil;
    _conversation = nil;
}

@end