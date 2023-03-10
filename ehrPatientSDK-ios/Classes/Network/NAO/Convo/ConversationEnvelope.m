//
// Created by Yves Le Borgne on 2022-12-27.
//

#import "ConversationEnvelope.h"

@implementation ConversationEnvelope

TRACE_OFF

@synthesize hasUnseenContent = _hasUnseenContent;

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
    ce.guid           = WantStringFromDic(dic, @"guid");
    ce.status         = WantStringFromDic(dic, @"status");
    ce.location       = WantStringFromDic(dic, @"location");
    ce.staffTitle     = WantStringFromDic(dic, @"staffTittle");
    ce.clientTitle    = WantStringFromDic(dic, @"clientTittle");
    ce.teaser         = WantStringFromDic(dic, @"teaser");
    ce.lastUpdated    = WantDateFromDic(dic, @"lastUpdated");
    ce.dispensaryName = WantStringFromDic(dic, @"dispensaryName");
    ce.createdOn      = WantDateFromDic(dic, @"createdOn");
    ce.unread         = WantIntegerFromDic(dic, @"unread");
    return ce;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.guid, dic, @"guid");
    PutStringInDic(self.status, dic, @"status");
    PutStringInDic(self.location, dic, @"location");
    PutStringInDic(self.staffTitle, dic, @"staffTittle");
    PutStringInDic(self.clientTitle, dic, @"clientTittle");
    PutStringInDic(self.teaser, dic, @"teaser");
    PutStringInDic(self.dispensaryName, dic, @"dispensaryName");
    PutDateInDic(self.lastUpdated, dic, @"lastUpdated");
    PutDateInDic(self.createdOn, dic, @"createdOn");
    PutIntegerInDic(self.unread, dic, @"unread");
    return dic;
}

- (void)dealloc {
    _guid           = nil;
    _status         = nil;
    _location       = nil;
    _staffTitle     = nil;
    _clientTitle    = nil;
    _teaser         = nil;
    _lastUpdated    = nil;
    _createdOn      = nil;
    _dispensaryName = nil;
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

- (NSString *)getFullLocation {
    if (self.dispensaryName && self.location) {
        NSString *fmt = @"%@ ( %@ )";
        return [NSString stringWithFormat:fmt, self.dispensaryName, self.location];
    } else {
        return self.location;
    }
}

- (BOOL)isOpen {
    if (!self.status) return false;
    return ([self.status isEqualToString:@"open"]);
}

- (BOOL)isClosed {
    if (!self.status) return false;
    return ([self.status isEqualToString:@"closed"]);
}

@end