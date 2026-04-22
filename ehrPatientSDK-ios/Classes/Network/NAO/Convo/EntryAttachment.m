//
// Created by Yves Le Borgne on 2022-12-27.
//

#import "EntryAttachment.h"
#import "GERuntimeConstants.h"

@implementation EntryAttachment

TRACE_ON

@synthesize id = _id;
@synthesize name = _name;
@synthesize mimeType = _mimeType;
@synthesize b64 = _b64;

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        MPLOG(@"*** super returns nil!");
    }
    return self;
}

- (NSData *)getDocument __unused {
    NSData *nsdataFromBase64String = [[NSData alloc] initWithBase64EncodedString:_b64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return nsdataFromBase64String;
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
    EntryAttachment *ea = [[EntryAttachment alloc] init];
    ea.id       = WantStringFromDic(dic, @"id");
    ea.name     = WantStringFromDic(dic, @"name");
    ea.mimeType = WantStringFromDic(dic, @"mimeType");
    ea.b64      = WantStringFromDic(dic, @"b64");
    return ea;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.id, dic, @"id");
    PutStringInDic(self.name, dic, @"name");
    PutStringInDic(self.mimeType, dic, @"mimeType");
    PutStringInDic(self.b64, dic, @"b64");
    return nil;
}

- (void)dealloc {
    _id       = nil;
    _name     = nil;
    _mimeType = nil;
    _b64      = nil;

    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end