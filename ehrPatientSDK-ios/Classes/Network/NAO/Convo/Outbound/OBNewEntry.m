//
// Created by Yves Le Borgne on 2023-01-05.
//

#import "OBNewEntry.h"

@interface OBNewEntry() {
    NSInteger _instanceNumber;
}

@end

@implementation OBNewEntry

@synthesize id, entry;

TRACE_OFF

+ (instancetype)defaultForConvo:(Conversation *)conversation __attribute__((unused)) {
    OBNewEntry *ceas = [[self alloc] init];
    ceas.id    = conversation.id;
    ceas.entry = [OBEntry default];
    return ceas;
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
    self.id    = nil;
    self.entry = nil;
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    return nil;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.id, dic, @"id");
    PutPersistableInDic(self.entry, dic, @"entry");
    return dic;
}

- (NSString *)asJSON {
    return [[self asDictionary] asJSON];
}

- (NSData *)asJSONdata {
    return [[self asDictionary] asJSONdata];
}

+ (instancetype)objectWithJSONdata:(NSData *)jsonData {
    NSDictionary *dic = [NSDictionary dictionaryWithJSONdata:jsonData];
    return [self objectWithContentsOfDictionary:dic];
}

+ (instancetype)objectWithJSON:(NSString *)jsonString {
    NSDictionary *dic = [NSDictionary dictionaryWithJSON:jsonString];
    return [self objectWithContentsOfDictionary:dic];
}

@end
