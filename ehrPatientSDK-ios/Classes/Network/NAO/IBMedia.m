//
// Created by Yves Le Borgne on 2016-03-24.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "IBMedia.h"

@implementation IBMedia
TRACE_OFF

@dynamic text;

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
    IBMedia *ad = [[IBMedia alloc] init];
    ad.guid          = WantStringFromDic(theDictionary,@"guid");
    ad.fileName      = WantStringFromDic(theDictionary, @"fileName");
    ad.mediaLocation = WantStringFromDic(theDictionary, @"mediaLocation");
    ad.mediaType     = WantStringFromDic(theDictionary, @"mediaType");
    ad.content       = WantStringFromDic(theDictionary, @"content");

    [ad text];

    return ad;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    PutStringInDic(self.mediaLocation, dic, @"mediaLocation");
    PutStringInDic(self.mediaType, dic, @"mediaType");
    PutStringInDic(self.guid, dic,@"guid");
    PutStringInDic(self.fileName, dic, @"fileName");
    PutStringInDic(self.content, dic, @"content");

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

- (NSString *)text {
    if (_text) return _text;
    if ([self.mediaType isEqualToString:@"labRequestText"]) [self extractText];
    if ([self.mediaType isEqualToString:@"labResultText"]) [self extractText];
    if ([self.mediaType isEqualToString:@"text"]) [self extractText];
    return _text;

}

#pragma mark private methods

- (void)extractText {

    if (!self.content) {
        _text = nil;
        TRACE(@"Null content in payload, text not extracted.");
    } else {
        NSData *nsdataFromBase64String = [[NSData alloc] initWithBase64EncodedString:self.content options:NSDataBase64DecodingIgnoreUnknownCharacters];
        _text = [[NSString alloc] initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
        TRACE(@"Decoded: %@", _text);
    }

}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}
@end