//
// Created by Yves Le Borgne on 2023-01-04.
//

#import "ConvoEntryPayloadSpec.h"

@interface ConvoEntryPayloadSpec () {
    NSInteger _instanceNumber;
}

@end;

@implementation ConvoEntryPayloadSpec

TRACE_ON

@synthesize text;

+ (instancetype)default __attribute__((unused)) {
    ConvoEntryPayloadSpec *ps = [[ConvoEntryPayloadSpec alloc] init];
    ps.text = @"This is a message Entry from iOS";
    return ps;
}

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {

    return nil;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.text, dic, @"text");
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
    self.text = nil;
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}
@end