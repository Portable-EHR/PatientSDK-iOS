//
// Created by Yves Le Borgne on 2022-12-27.
//

#import "ConversationEntryStatus.h"

@implementation ConversationEntryStatus

TRACE_OFF

@synthesize participantId = _participantId;
@synthesize entryId = _entryId;
@synthesize status = _status;
@synthesize date = _date;

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
    ConversationEntryStatus *ces = [[ConversationEntryStatus alloc] init];
    ces.participantId = WantStringFromDic(dic, @"participantId");
    ces.entryId       = WantStringFromDic(dic, @"entryId");
    ces.status        = WantStringFromDic(dic, @"status");
    ces.date          = WantDateFromDic(dic, @"date");
    return ces;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.participantId, dic, @"participantId");
    PutStringInDic(self.entryId, dic, @"entryId");
    PutStringInDic(self.status, dic, @"status");
    PutDateInDic(self.date, dic, @"date");
    return dic;
}

- (void)dealloc {
    _participantId = nil;
    _entryId       = nil;
    _status        = nil;
    _date          = nil;
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end