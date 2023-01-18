//
// Created by Yves Le Borgne on 2023-01-04.
//

#import "ConvoEntrySpec.h"
#import "ConvoEntryPayloadSpec.h"

@implementation ConvoEntrySpec

@synthesize type, audience, payload, attachmentCount, createdOn;

TRACE_ON

+ (instancetype)default {
    ConvoEntrySpec *ces = [[self alloc] init];
    ces.type            = @"message";
    ces.audience        = @"all";
    ces.attachmentCount = 0;
    ces.payload         = [ConvoEntryPayloadSpec default];
    ces.createdOn       = [NSDate date];
    return ces;
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
    self.type            = nil;
    self.audience        = nil;
    self.payload         = nil;
    self.attachmentCount = nil;

    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    return nil;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.type, dic, @"type");
    PutStringInDic(self.audience, dic, @"audience");
    PutIntegerInDic(self.attachmentCount, dic, @"attachmentCount");
    PutPersistableInDic(self.payload, dic, @"payload");
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