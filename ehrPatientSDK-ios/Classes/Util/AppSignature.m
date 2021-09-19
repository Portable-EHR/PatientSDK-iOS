//
// Created by Yves Le Borgne on 2019-06-18.
// Copyright (c) 2019 Portable EHR inc. All rights reserved.
//

#import "AppSignature.h"
#import "GEMacros.h"

@implementation AppSignature


TRACE_OFF

- (id)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        self.installedOn = nil;
        self.buildNumber = 0;
    } else {
        MPLOGERROR(@"Yelp ! super returned nil !");
    }
    return self;
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
    self.installedOn=nil;
}

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    AppSignature *as = [[AppSignature alloc] init];
    as.installedOn= WantDateFromDic(dic, @"installedOn");
    as.buildNumber= WantIntegerFromDic(dic, @"buildNumber");
    return as;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];
    PutDateInDic(self.installedOn, dictionary, @"installedOn");
    PutIntegerInDic(self.buildNumber, dictionary, @"buildNumber");
    return dictionary;
}

@end
