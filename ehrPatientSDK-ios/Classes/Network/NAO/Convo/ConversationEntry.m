//
// Created by Yves Le Borgne on 2022-12-27.
//

#import "ConversationEntry.h"
#import "EntryPartipantPayload.h"
#import "EntryMovePayload.h"
#import "EntryStatusChangePayload.h"
#import "EntrySharePayload.h"
#import "GERuntimeConstants.h"
#import "DateUtil.h"

@implementation ConversationEntry

TRACE_OFF

@synthesize id = _id;
@synthesize from = _from;
@synthesize type = _type;
@synthesize audience = _audience;
@synthesize attachmentCount = _attachmentCount;
@synthesize status = _status;
@synthesize payload;
@synthesize createdOn = _createdOn;

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        self.entryType = EntryTypeUnknown;
        self.isInView = NO;
        self.wasSeen = NO;
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
    ConversationEntry *ce = [[ConversationEntry alloc] init];
    ce->_id              = WantStringFromDic(dic, @"id");
    ce->_from            = WantStringFromDic(dic, @"from");
    ce->_type            = WantStringFromDic(dic, @"type");
    ce->_audience        = WantStringFromDic(dic, @"audience");
    ce->_createdOn       = WantDateFromDic(dic, @"createdOn");
    ce->_attachmentCount = WantIntegerFromDic(dic, @"attachmentCount");
    NSDictionary *payloadAsDic = WantDicFromDic(dic, @"payload");
    if (nil != payloadAsDic) {
        if (ce.isMessageType) {
            ce.entryType = EntryTypeMessage;
            ce.payload   = [EntryMessagePayload objectWithContentsOfDictionary:payloadAsDic];
        } else if (ce.isParticipantType) {
            ce.entryType = EntryTypeParticipant;
            ce.payload   = [EntryPartipantPayload objectWithContentsOfDictionary:payloadAsDic];
        } else if (ce.isMoveType) {
            ce.entryType = EntryTypeMove;
            ce.payload   = [EntryMovePayload objectWithContentsOfDictionary:payloadAsDic];
        } else if (ce.isStatusChangeType) {
            ce.entryType = EntryTypeStatusChange;
            ce.payload   = [EntryStatusChangePayload objectWithContentsOfDictionary:payloadAsDic];
        } else if (ce.isShareType) {
            ce.entryType = EntryTypeShare;
            ce.payload   = [EntrySharePayload objectWithContentsOfDictionary:payloadAsDic];
        }
    }
    NSArray        *statusAsArray = WantArrayFromDic(dic, @"status");
    NSMutableArray *statii        = [NSMutableArray array];
    if (nil != statusAsArray) {
        for (id element in statusAsArray) {
            [statii addObject:[EntryParticipantStatus objectWithContentsOfDictionary:element]];
        }
    }
    ce->_status = [NSMutableArray arrayWithArray:statii];

    return ce;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(_id, dic, @"id");
    PutStringInDic(_from, dic, @"from");
    PutStringInDic(_type, dic, @"type");
    PutStringInDic(_audience, dic, @"audience");
    PutDateInDic(_createdOn, dic, @"createdOn");
    PutIntegerInDic(_attachmentCount, dic, @"attachmentCount");
    if (nil != _messageEntryPayload) dic[@"payload"] = [_messageEntryPayload asDictionary];
    NSMutableArray *statii = [NSMutableArray array];
    if (nil != _status && _status.count > 0) {
        for (id <EHRNetworkableP> element in _status) {
            [statii addObject:[element asDictionary]];
        }
    }
    dic[@"status"] = [NSArray arrayWithArray:statii];

    return nil;
}

- (void)dealloc {
    _id                  = nil;
    _type                = nil;
    _from                = nil;
    _audience            = nil;
    _attachmentCount     = 0;
    _messageEntryPayload = nil;
    _status              = nil;
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

// convenience API

-(EntryProgressForParticipant*)progressForParticipant:(ConversationParticipant *)participant ofConvo:(Conversation*) conversation{
    return [EntryProgressForParticipant forEntry:self andParticipant:participant inConversation:conversation];
}

- (BOOL)isMessageType {
    if (!_type) return false;
    return [_type isEqualToString:@"message"];
}

- (BOOL)isStatusChangeType {
    if (!_type) return false;
    return ([_type isEqualToString:@"status-change"] || [_type isEqualToString:@"status_change"]);
}

- (BOOL)isMoveType {
    if (!_type) return false;
    return [_type isEqualToString:@"move"];
}

- (BOOL)isShareType {
    if (!_type) return false;
    return [_type isEqualToString:@"share"];
}

- (BOOL)isParticipantType {
    if (!_type) return false;
    return [_type isEqualToString:@"participant"];
}

-(void)addStatusLine:(EntryParticipantStatus *)statusLine __attribute__((unused))  __attribute__((unused)) {
    if ([self hasStatusFor:statusLine]) {
        MPLOGERROR(@"Attempt to duplicate status line for [%@], ignored",statusLine.status);
    }
    [_status addObject:statusLine];

}

-(BOOL) hasStatusFor:(EntryParticipantStatus*) statusLine {
    for (NSUInteger i = 0; i < _status.count ; ++i) {
        EntryParticipantStatus *straman = _status[i];
        if ( ! [straman.entryId isEqualToString:statusLine.entryId]) continue;
        if ( ! [straman.participantId isEqualToString:statusLine.participantId]) continue;
        if ([straman.status isEqualToString:statusLine.status]) return YES;
    }
    return NO;
}

-(NSString*) description {
    NSString *format = @"id : %@ , type : %@, created : %@";
    return [NSString stringWithFormat:format,self.id, self.type,[DateUtil defaultDeviceFormatMedium:self.createdOn] ];
}

@end
