//
// Created by Yves Le Borgne on 2023-05-10.
//

#import "IBPrivateMessageAttachment.h"
#import "GERuntimeConstants.h"

@implementation IBPrivateMessageAttachment
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

#pragma mark - EHRPersistableP

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)theDictionary {
    IBPrivateMessageAttachment *ad = [[IBPrivateMessageAttachment alloc] init];
    ad.b64      = WantStringFromDic(theDictionary, @"b64");
    ad.name     = WantStringFromDic(theDictionary, @"name");
    ad.mimeType = WantStringFromDic(theDictionary, @"mimeType");
    ad.date     = WantDateFromDic(theDictionary, @"date");
    return ad;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    /*
     * THIS DOES NOT PERSIST : CONFIDENTIAL MESSAGES ONLY
     */
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

#pragma mark getters

#pragma mark private methods

- (void)dealloc {
    GE_DEALLOC();
    _name     = nil;
    _mimeType = nil;
    _b64      = nil;
}

- (NSData *)decodedDocument __unused {
    NSData *nsdataFromBase64String = [[NSData alloc] initWithBase64EncodedString:_b64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return nsdataFromBase64String;
}

@end