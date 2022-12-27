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
@synthesize participants = _participants;
@synthesize entries = _entries;

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

    convo->_id= WantStringFromDic(dic, @"id");
    convo->_clientTitle= WantStringFromDic(dic, @"clientTitle");
    convo->_staffTitle= WantStringFromDic(dic, @"staffTitle");
    convo->_status= WantStringFromDic(dic, @"status");
    convo->_location= WantStringFromDic(dic, @"location");

    NSArray *participators =    WantArrayFromDic(dic,@"participants");
    NSMutableArray *participants = [NSMutableArray array];
    for (id somn in participators){
        [participants addObject:[ConversationParticipant objectWithContentsOfDictionary:somn]];
    }
    convo->_participants = [NSArray arrayWithArray:participants];

    NSArray *entryes = WantArrayFromDic(dic, @"entries");
    NSMutableArray *entryesyes = [NSMutableArray array];
    for (id somn in entryes){
        [entryesyes addObject:[ConversationEntry objectWithContentsOfDictionary:somn]];
    }
    convo->_entries = [NSArray arrayWithArray:entryesyes];


    return convo;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    PutStringInDic(self.id, dic, @"id");
    PutStringInDic(self.staffTitle, dic, @"staffTitle");
    PutStringInDic(self.clientTitle, dic, @"clientTitle");
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