//
// Created by Yves Le Borgne on 2023-02-25.
//

#import "EntrySharePayload.h"

@interface EntrySharePayload () {
    NSInteger _instanceNumber;
}
@end

@implementation EntrySharePayload

@dynamic isPrivateMessage;

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
    EntrySharePayload *esp = [[EntrySharePayload alloc] init];
    esp.id     = WantStringFromDic(dic, @"id");
    esp.text   = WantStringFromDic(dic, @"text");
    esp.type   = WantStringFromDic(dic, @"type");
    esp.status = WantStringFromDic(dic, @"status");
    return esp;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.id, dic, @"id");
    PutStringInDic(self.text, dic, @"text");
    PutStringInDic(self.type, dic, @"type");
    PutStringInDic(self.status, dic, @"status");
    return dic;
}

- (void)dealloc {
    _id     = nil;
    _text   = nil;
    _type   = nil;
    _status = nil;
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

//region properties

- (BOOL)isConsentActive __unused {
    return [_status isEqualToString:@"active"];
}

- (BOOL)isConsentInvalid __unused {
    return [_status isEqualToString:@"invalid"];
}

- (BOOL)isConsentRevoked __unused {
    return [_status isEqualToString:@"revoked"];
}

- (BOOL)isConsentExpired __unused {
    return [_status isEqualToString:@"expired"];
}

- (BOOL)isConsentNotFound __unused {
    return [_status isEqualToString:@"not_found"];
}

-(BOOL)isNoAccess {
    return [_status isEqualToString:@"no_access"];
}


- (BOOL)isPrivateMessage __unused {
    return [_type isEqualToString:@"private-message"];
}


//endregion


@end