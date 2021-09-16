//
// Created by Yves Le Borgne on 2017-08-22.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "EHRPersistableP.h"
#import "IBMediaInfo.h"

@implementation IBMediaInfo

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
    IBMediaInfo *mi = [[IBMediaInfo alloc] init];
    mi.guid=WantStringFromDic(dic, @"guid");
    return nil;

}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.guid forKey:@"guid"];
    return dic;
}

@end