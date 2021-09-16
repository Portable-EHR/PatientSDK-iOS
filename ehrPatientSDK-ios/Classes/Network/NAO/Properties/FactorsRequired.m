//
// Created by Yves Le Borgne on 2018-08-26.
// Copyright (c) 2019 Portable EHR inc. All rights reserved.
//

#import "EHRPersistableP.h"
#import "FactorsRequired.h"

@implementation FactorsRequired

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

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

+ (id)objectWithContentsOfDictionary:(NSDictionary *)dic {
    FactorsRequired *f = [[FactorsRequired alloc] init];
    f.email                = WantBoolFromDic(dic, @"email");
    f.emailVerification    = WantBoolFromDic(dic, @"emailVerification");
    f.mobile               = WantBoolFromDic(dic, @"mobile");
    f.mobileVerification   = WantBoolFromDic(dic, @"mobileVerification");
    f.identityVerification = WantBoolFromDic(dic, @"identityVerification");
    f.alias                = WantBoolFromDic(dic, @"alias");
    f.password             = WantBoolFromDic(dic, @"password");
    return f;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutBoolInDic(self.email, dic, @"email");
    PutBoolInDic(self.emailVerification, dic, @"emailVerification");
    PutBoolInDic(self.mobile, dic, @"mobile");
    PutBoolInDic(self.mobileVerification, dic, @"mobileVerification");
    PutBoolInDic(self.identityVerification, dic, @"identityVerification");
    PutBoolInDic(self.alias, dic, @"alias");
    PutBoolInDic(self.password, dic, @"password");
    return dic;
}

@end