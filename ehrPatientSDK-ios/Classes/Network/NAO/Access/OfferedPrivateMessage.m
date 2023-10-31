//
// Created by Yves Le Borgne on 2020-03-06.
// Copyright (c) 2020 Portable EHR inc. All rights reserved.
//

#import "OfferedPrivateMessage.h"
#import "IBConsent.h"

@implementation OfferedPrivateMessage
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

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)theDictionary {
    OfferedPrivateMessage *ct = [[OfferedPrivateMessage alloc] init];
    id                    val = nil;

    if ((val = theDictionary[@"privateMessageInfo"])) {
        ct.privateMessageInfo = [IBPrivateMessageInfo objectWithContentsOfDictionary:val];
    }
    if ((val = theDictionary[@"privateMessage"])) {
        ct.privateMessage = [IBPrivateMessageInfo objectWithContentsOfDictionary:val];
    }

    return ct;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    if (self.privateMessage) {
        PutPersistableInDic(self.privateMessage, dic, @"privateMessage");
    }
    if (self.privateMessageInfo) {
        PutPersistableInDic(self.privateMessageInfo, dic, @"privateMessageInfo");
    }
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
