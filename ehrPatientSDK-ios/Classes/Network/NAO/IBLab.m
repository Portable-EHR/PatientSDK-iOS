//
// Created by Yves Le Borgne on 2016-03-23.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "IBLab.h"
#import "IBAddress.h"

@implementation IBLab
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
    IBLab *ad = [[IBLab alloc] init];
    ad.guid   = WantStringFromDic(theDictionary,@"guid");
    ad.name = WantStringFromDic(theDictionary, @"name");
    ad.dayPhone     = WantStringFromDic(theDictionary, @"dayPhone");
    ad.url         = WantStringFromDic(theDictionary, @"url");

    id val = [theDictionary objectForKey:@"address"];
    if (val) ad.address = [IBAddress objectWithContentsOfDictionary:val];

    return ad;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    PutStringInDic(self.name, dic, @"name");
    PutStringInDic(self.guid, dic,@"guid");
    PutStringInDic(self.dayPhone, dic, @"dayPhone");
    PutStringInDic(self.url, dic, @"url");
    if (self.address) [dic setObject:[self.address asDictionary] forKey:@"address"];
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

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}
@end