//
// Created by Yves Le Borgne on 2022-12-27.
//

#import "ConversationEnvelope.h"

@implementation ConversationEnvelope

TRACE_OFF

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
    ConversationEnvelope *ce = [[ConversationEnvelope alloc] init];
    ce.guid        = WantStringFromDic(dic, @"guid");
    ce.status      = WantStringFromDic(dic, @"status");
    ce.location    = WantStringFromDic(dic, @"location");
    ce.staffTitle  = WantStringFromDic(dic, @"staffTitle");
    ce.clientTitle = WantStringFromDic(dic, @"clientTitle");
    ce.teaser      = WantStringFromDic(dic, @"teaser");
    ce.lastUpdated = WantDateFromDic(dic, @"lastUpdated");
    return ce;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.guid, dic, @"guid");
    PutStringInDic(self.status, dic, @"status");
    PutStringInDic(self.location, dic, @"location");
    PutStringInDic(self.staffTitle, dic, @"staffTitle");
    PutStringInDic(self.clientTitle, dic, @"clientTitle");
    PutStringInDic(self.teaser, dic, @"teaser");
    PutDateInDic(self.lastUpdated, dic, @"lastUpdated");
    return dic;
}

- (void)dealloc {
    _guid        = nil;
    _status      = nil;
    _location    = nil;
    _staffTitle  = nil;
    _clientTitle = nil;
    _teaser      = nil;
    _lastUpdated = nil;
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end