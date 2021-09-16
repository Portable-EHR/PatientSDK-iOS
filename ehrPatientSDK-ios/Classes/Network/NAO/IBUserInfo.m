//
// Created by Yves Le Borgne on 2015-10-08.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "IBUserInfo.h"
#import "IBContact.h"

@implementation IBUserInfo

TRACE_OFF

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

#pragma mark - precanned users

+ (IBUserInfo *)userWithServerUserInfo:(NSDictionary *)userInfo __unused {
    return [self objectWithContentsOfDictionary:userInfo];
}

#pragma mark - EHRPersistableP

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    id         val = nil;
    IBUserInfo *us = [[self alloc] init];

    us.guid     = WantStringFromDic(dic, @"guid");
    us.language = WantStringFromDic(dic, @"language");
    us.username = WantStringFromDic(dic, @"username");
    if ((val = [dic objectForKey:@"contact"])) us.contact = [IBContact objectWithContentsOfDictionary:val];
    return us;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.guid) [dic setObject:self.guid forKey:@"guid"];
    if (self.language) [dic setObject:self.guid forKey:@"language"];
    if (self.username) [dic setObject:self.guid forKey:@"username"];
    if (self.contact) [dic setObject:[self.contact asDictionary] forKey:@"contact"];
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

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end