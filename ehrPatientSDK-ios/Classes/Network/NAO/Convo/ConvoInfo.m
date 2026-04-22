//
// Created by Yves Le Borgne on 2022-12-31.
//

#import "ConvoInfo.h"
#import "GERuntimeConstants.h"

@implementation ConvoInfo

TRACE_OFF

@synthesize teaser = _teaser, guid=_guid, clientTitle = _clientTitle, lastUpdated = _lastUpdated;
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
    _guid=nil;
    _lastUpdated = nil;
    _clientTitle = nil;
    _teaser = nil;
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}


+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    ConvoInfo *ci = [[self alloc] init];
    ci.lastUpdated = WantDateFromDic(dic, @"lastUpdated");
    ci.clientTitle = WantStringFromDic(dic, @"clientTitle");
    ci.teaser      = WantStringFromDic(dic, @"teaser");
    return ci;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.clientTitle, dic, @"clientTitle");
    PutStringInDic(self.teaser, dic, @"teaser");
    PutDateInDic(self.lastUpdated, dic, @"lastUpdated");
    return dic;
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

@end