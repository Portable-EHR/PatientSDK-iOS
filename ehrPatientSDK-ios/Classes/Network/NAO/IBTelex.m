//
// Created by Yves Le Borgne on 2016-03-24.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "IBTelex.h"

@implementation IBTelex
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
    IBTelex  *ad      = [[IBTelex alloc] init];
    NSString *message = WantStringFromDic(theDictionary, @"messageB64");
    TRACE(@"%@",message);

    if (message) {
        NSData *nsdataFromBase64String = [[NSData alloc] initWithBase64EncodedString:message options:NSDataBase64DecodingIgnoreUnknownCharacters];
        ad.message = [[NSString alloc] initWithData:nsdataFromBase64String
                                           encoding:NSUTF8StringEncoding];
//        if (!ad.message) ad.message=[[NSString alloc] initWithData:nsdataFromBase64String encoding:NSISOLatin1StringEncoding];
    }

    NSString *payload = WantStringFromDic(theDictionary, @"documentB64");

    if (payload) {
        NSData *nsdataFromBase64String = [[NSData alloc] initWithBase64EncodedString:payload options:NSDataBase64DecodingIgnoreUnknownCharacters];
        ad.pdf          = nsdataFromBase64String;
        ad.documentType = WantStringFromDic(theDictionary, @"documentType");
    }

    ad.subject      = WantStringFromDic(theDictionary, @"subject");
    ad.from         = WantStringFromDic(theDictionary, @"from");
    ad.to           = WantStringFromDic(theDictionary, @"to");
    ad.patient      = WantStringFromDic(theDictionary, @"patient");
    ad.source       = WantStringFromDic(theDictionary, @"source");
    ad.documentName = WantStringFromDic(theDictionary, @"documentName");

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
    GE_DEALLOC_ECHO();
}
@end