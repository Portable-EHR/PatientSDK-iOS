//
// Created by Yves Le Borgne on 2023-01-08.
//

#import "EntryMovePayload.h"

@interface EntryMovePayload () {
    NSInteger _instanceNumber;
}
@end

@implementation EntryMovePayload

TRACE_OFF

@synthesize fromLocation;
@synthesize toLocation;

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
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    EntryMovePayload *emp = [[self alloc] init];
    emp.fromLocation= WantStringFromDic(dic, @"fromLocation");
    emp.toLocation= WantStringFromDic(dic, @"toLocation");
    return emp;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.fromLocation, dic, @"fromLocation");
    PutStringInDic(self.toLocation, dic, @"toLocation");
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