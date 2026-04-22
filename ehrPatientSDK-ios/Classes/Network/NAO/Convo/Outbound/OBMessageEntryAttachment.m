//
// Created by Yves Le Borgne on 2023-02-18.
//

#import "OBMessageEntryAttachment.h"

@interface OBMessageEntryAttachment () {
    NSInteger _instanceNumber;
}

@end

@implementation OBMessageEntryAttachment

+ (instancetype)name:(NSString *)humanName mimeType:(NSString *)mimeType data:(NSData *)data {
    NSString *b64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
    return [OBMessageEntryAttachment name:humanName mimeType:mimeType b64:b64];
}

+ (instancetype)name:(NSString *)humanName mimeType:(NSString *)mimeType b64:(NSString *)data {
    OBMessageEntryAttachment *omea = [[OBMessageEntryAttachment alloc] init];
    omea.name     = humanName;
    omea.mimeType = mimeType;
    omea.b64      = data;
    return omea;
}

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    OBMessageEntryAttachment *ea = [[self alloc] init];
    ea.name     = WantStringFromDic(dic, @"name");
    ea.b64      = WantStringFromDic(dic, @"b64");
    ea.mimeType = WantStringFromDic(dic, @"mimeType");
    return nil;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.mimeType, dic, @"mimeType");
    PutStringInDic(self.b64, dic, @"b64");
    PutStringInDic(self.name, dic, @"name");
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

TRACE_ON

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
@end