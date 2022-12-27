//
// Created by Yves Le Borgne on 2022-12-27.
//

#import "ConversationEntry.h"

@implementation ConversationEntry

TRACE_OFF

@synthesize id = _id;
@synthesize from = _from;
@synthesize type = _type;
@synthesize audience = _audience;
@synthesize attachmentCount = _attachmentCount;
@synthesize status = _status;
@synthesize payload = _payload;
@synthesize createdOn = _createdOn;

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
    ConversationEntry *ce = [[ConversationEntry alloc] init];
    ce->_id              = WantStringFromDic(dic, @"id");
    ce->_from            = WantStringFromDic(dic, @"from");
    ce->_type            = WantStringFromDic(dic, @"type");
    ce->_audience        = WantStringFromDic(dic, @"audience");
    ce->_createdOn       = WantDateFromDic(dic, @"createdOn");
    ce->_attachmentCount = WantIntegerFromDic(dic, @"attachmentCount");
    NSDictionary *payloadAsDic = WantDicFromDic(dic, @"payload");
    if (nil != payloadAsDic) ce->_payload = [ConversationEntryPayload objectWithContentsOfDictionary:payloadAsDic];
    NSArray        *statusAsArray = WantArrayFromDic(dic, @"status");
    NSMutableArray *statii        = [NSMutableArray array];
    if (nil != statusAsArray) {
        for (id element in statusAsArray) {
            [statii addObject:[ConversationEntryStatus objectWithContentsOfDictionary:element]];
        }
    }
    ce->_status = [NSArray arrayWithArray:statii];

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
    if (nil != _payload) dic[@"payload"] = [_payload asDictionary];
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
    _id              = nil;
    _type            = nil;
    _from            = nil;
    _audience        = nil;
    _attachmentCount = 0;
    _payload         = nil;
    _status          = nil;
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end