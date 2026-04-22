//
// Created by Yves Le Borgne on 2017-04-12.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "IBVersion.h"
#import "GERuntimeConstants.h"

@implementation IBVersion

TRACE_OFF

#pragma  mark ctors

- (id)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        self.major = 0;
        self.minor = 0;
        self.build = 0;

    } else {
        TRACE(@"*** Super returned nil !");
    }
    return self;
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

+ (instancetype)versionWithString:(NSString *)versionAsString {
    NSArray   *toks = [versionAsString componentsSeparatedByString:@"."];
    IBVersion *iv   = [[self alloc] init];
    if ([toks count] == 3) {
        iv.major = [toks[0] integerValue];
        iv.minor = [toks[1] integerValue];
        iv.build = [toks[2] integerValue];
    } else if ([toks count] == 2) {
        iv.major = [toks[0] integerValue];
        iv.minor = [toks[1] integerValue];
    } else if ([toks count] == 1) {
        iv.major = [toks[0] integerValue];
    }
    return iv;
}

+ (id)objectWithJSON:(NSString *)jsonString {
    return nil;
}

+ (id)objectWithJSONdata:(NSData *)jsonData {
    return nil;
}

- (NSData *)asJSONdata {
    return nil;
}

- (NSString *)asJSON {
    return nil;
}

+ (id)objectWithContentsOfDictionary:(NSDictionary *)dic {
    return nil;
}

- (NSDictionary *)asDictionary {
    return nil;
}

- (NSInteger)asInt {
    NSInteger integer = self.major * 1000 * 1000 + self.minor * 1000 + self.build;
    return integer;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%d.%d.%03d",(unsigned int) self.major,(unsigned int) self.minor, (unsigned int) self.build];
}

- (NSComparisonResult)compare:(IBVersion *)otherObject {
    if ([self asInt] == [otherObject asInt]) return NSOrderedSame;
    if ([self asInt] > [otherObject asInt]) return NSOrderedDescending;
    return NSOrderedAscending;
}
@end