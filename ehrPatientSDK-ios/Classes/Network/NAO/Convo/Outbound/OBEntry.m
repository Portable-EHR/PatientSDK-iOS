//
// Created by Yves Le Borgne on 2023-01-04.
//

#import "OBEntry.h"
#import "OBMessageEntry.h"

@interface OBEntry () {
    NSInteger _instanceNumber;
}

@end

@implementation OBEntry

@synthesize type, audience;

TRACE_ON

+ (instancetype)default {
    OBEntry *ces = [[self alloc] init];
    ces.type     = @"message";
    ces.audience = @"all";
    return ces;
}

+ (instancetype)withParticipantPayload:(EntryPartipantPayload *)payload {
    OBEntry *ces = [[self alloc] init];
    ces.type    = @"participant";
    ces.payload = payload;
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
    self.type     = nil;
    self.audience = nil;
    self.payload  = nil;
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    OBEntry *oe = [[self alloc] init];
    oe.type     = WantStringFromDic(dic, @"tyep");
    oe.audience = WantStringFromDic(dic, @"audience");

    NSDictionary *payloadDic = WantDicFromDic(dic, @"payload");
    if (payloadDic) {
        if ([oe.type isEqualToString:@"message"]) {
            oe.payload = [OBMessageEntry objectWithContentsOfDictionary:payloadDic];
        } else {
            MPLOGERROR(@"OBEntry : dont know how to deserialize entry type [%@]", oe.type);
        }
    }
    return oe;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.type, dic, @"type");
    PutStringInDic(self.audience, dic, @"audience");
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
