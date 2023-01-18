//
// Created by Yves Le Borgne on 2022-12-27.
//

#import "Conversation.h"
#import "ConversationParticipant.h"
#import "ConversationEntry.h"

@implementation Conversation

TRACE_OFF

@synthesize staffTitle = _staffTitle;
@synthesize clientTitle = _clientTitle;
@synthesize location = _location;
@synthesize status = _status;
@synthesize id = _id;
@synthesize indexedParticipants = _indexedParticipants;
@synthesize indexedEntries = _indexedEntries;
@synthesize hasMoreEntries = _hasMoreEntries;

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        MPLOG(@"*** super returns nil!");
    }
    return self;
}

+ (instancetype)objectWithJSON:(NSString *)jsonString {
    NSDictionary *dic = [NSDictionary dictionaryWithJSON:jsonString];
    return [self objectWithContentsOfDictionary:dic];
}

+ (instancetype)objectWithJSONdata:(NSData *)jsonData {
    NSDictionary *dic = [NSDictionary dictionaryWithJSONdata:jsonData];
    return [self objectWithContentsOfDictionary:dic];
}

- (NSString *)asJSON {
    return [[self asDictionary] asJSON];
}

- (NSData *)asJSONdata {
    return [[self asDictionary] asJSONdata];
}

+ (id)objectWithContentsOfDictionary:(NSDictionary *)dic {
    Conversation *convo = [[self alloc] init];

    convo->_id          = WantStringFromDic(dic, @"id");
    convo->_clientTitle = WantStringFromDic(dic, @"clientTittle");
    convo->_staffTitle  = WantStringFromDic(dic, @"staffTittle");
    convo->_status      = WantStringFromDic(dic, @"status");
    convo->_location    = WantStringFromDic(dic, @"location");

    NSArray        *participators = WantArrayFromDic(dic, @"participants");
    NSMutableArray *participants  = [NSMutableArray array];
    for (id        somn in participators) {
        [participants addObject:[ConversationParticipant objectWithContentsOfDictionary:somn]];
    }
    convo->_participants = participants;

    NSArray        *entryes    = WantArrayFromDic(dic, @"entries");
    NSMutableArray *entryesyes = [NSMutableArray array];
    for (id        somn in entryes) {
        [entryesyes addObject:[ConversationEntry objectWithContentsOfDictionary:somn]];
    }

    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdOn"
                                                 ascending:YES];
    NSArray *sortedArray = [entryesyes sortedArrayUsingDescriptors:@[sortDescriptor]];
    convo->_entries = [NSMutableArray arrayWithArray:sortedArray];
//    convo->_entries = [NSArray arrayWithArray:sortedArray];

    convo->_indexedParticipants = [NSMutableDictionary dictionary];
    for (ConversationParticipant *participant in convo->_participants) {
        convo->_indexedParticipants[participant.guid] = participant;
    }

    convo->_indexedEntries = [NSMutableDictionary dictionary];
    for (ConversationEntry *entry in convo->_entries) {
        convo->_indexedEntries[entry.id] = entry;
    }

    return convo;
}

- (void)addEntry:(ConversationEntry *)entry {
    [_entries addObject:entry];
    [self sortAndIndexEntries];
}

-(void) sortAndIndexEntries {
    NSMutableArray *entryesyes = [NSMutableArray arrayWithArray:_entries];

    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdOn"
                                                 ascending:YES];
    NSArray *sortedArray = [entryesyes sortedArrayUsingDescriptors:@[sortDescriptor]];
    _entries = [NSMutableArray arrayWithArray:sortedArray];

    _indexedEntries = [NSMutableDictionary dictionary];
    for (ConversationEntry *entry in _entries) {
        _indexedEntries[entry.id] = entry;
    }
}
- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    PutStringInDic(self.id, dic, @"id");
    PutStringInDic(self.staffTitle, dic, @"staffTittle");
    PutStringInDic(self.clientTitle, dic, @"clientTittle");
    PutStringInDic(self.status, dic, @"status");
    PutStringInDic(self.location, dic, @"location");

    NSMutableArray *participators = [NSMutableArray array];
    if (self.participants.count > 0) {
        for (id <EHRNetworkableP> participant in self.participants) {
            [participators addObject:[participant asDictionary]];
        }
    }
    dic[@"participants"] = participators;

    NSMutableArray *entryes = [NSMutableArray array];
    if (self.entries.count > 0) {
        for (id <EHRNetworkableP> entry in self.entries) {
            [participators addObject:[entry asDictionary]];
        }
    }
    dic[@"entries"] = entryes;

    return dic;
}


//region Unmess data handling

- (ConversationParticipant *)partipantForEntry:(ConversationEntry *)entry __attribute__((unused)) {
    NSString *lookingfor = entry.from;
    if (nil != lookingfor) {
        return _indexedParticipants[lookingfor];
    }
    return nil;
}

- (ConversationParticipant *)myself __attribute__((unused)) {
    for (ConversationParticipant *participant in _participants) {
        if (participant.mySelf) return participant;
    }
    return nil;
}

//endregion

-(BOOL)hasMoreEntries {
    return NO;
}

-(BOOL)isOpen {
    return [_status isEqualToString:@"open"];
}

-(BOOL) isClosed {
    return ! self.isOpen;
}

-(NSMutableArray *)entries {
    return _entries;
}

-(NSMutableArray *)participants {
    return _participants;
}

- (void)dealloc {
    _id           = nil;
    _staffTitle   = nil;
    _clientTitle  = nil;
    _status       = nil;
    _location     = nil;
    _participants = nil;
    _entries      = nil;
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end