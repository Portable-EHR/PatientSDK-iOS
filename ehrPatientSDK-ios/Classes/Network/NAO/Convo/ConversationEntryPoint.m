//
// Created by Yves Le Borgne on 2022-12-27.
//

#import "ConversationEntryPoint.h"

@implementation ConversationEntryPoint

TRACE_OFF

@synthesize id = _id;
@synthesize name = _name;
@synthesize descriptionText = _descriptionText;

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
    ConversationEntryPoint *cep = [[ConversationEntryPoint alloc] init];

    cep.id              = WantStringFromDic(dic, @"id");
    cep.name            = WantStringFromDic(dic, @"name");
    cep.descriptionText = WantStringFromDic(dic, @"description");
    // ALERT : mapping network property to avoid clash with NSObject.description

    return cep;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.id, dic, @"id");
    PutStringInDic(self.name, dic, @"name");
    PutStringInDic(self.descriptionText, dic, @"description");
    return dic;
}

- (void)dealloc {
    _name            = nil;
    _id              = nil;
    _descriptionText = nil;

    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end