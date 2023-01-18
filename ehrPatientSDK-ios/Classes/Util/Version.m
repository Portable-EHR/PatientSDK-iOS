//
// Created by Yves Le Borgne on 2017-03-15.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#include "Version.h"

@implementation Version

TRACE_OFF

- (id)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        self.major = 0;
        self.minor = 0;
        self.build = 0;
    } else {
        MPLOGERROR(@"Yelp ! super returned nil !");
    }
    return self;
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

+ (instancetype)versionWithMajor:(NSUInteger)major minor:(NSUInteger)minor build:(NSUInteger)build __unused {
    Version *v = [[self alloc] init];
    v.major = major;
    v.minor = minor;
    v.build = build;
    return v;
}

+ (instancetype)versionWithString:(NSString *)versionAsString __unused {
    NSArray  *tokens = [versionAsString componentsSeparatedByString:@"."];
    NSString *majString, *minString, *bldString;
    minString = @"0";
    bldString = @"0";
    majString = [tokens objectAtIndex:0];
    if (tokens.count >= 2) {
        minString = [tokens objectAtIndex:1];
    }
    if (tokens.count == 3) {
        bldString = [tokens objectAtIndex:2];
    }
    if (tokens.count != 3) return nil;
    NSUInteger maj = (unsigned long) [majString integerValue];
    NSUInteger min = (unsigned long) [minString integerValue];
    NSUInteger bld = (unsigned long) [bldString integerValue];
    return [self versionWithMajor:maj minor:min build:bld];
}

+(instancetype) iosVersion {

    NSString *nf = kSystemVersion;
    NSString *majString, *minString, *bldString;
    majString=[nf substringWithRange:NSMakeRange(0, 2)];
    minString=[nf substringWithRange:NSMakeRange(2, 2)];
    bldString=[nf substringWithRange:NSMakeRange(4, 2)];
    NSUInteger maj = (unsigned long) [majString integerValue];
    NSUInteger min = (unsigned long) [minString integerValue];
    NSUInteger bld = (unsigned long) [bldString integerValue];
    return [self versionWithMajor:maj minor:min build:bld];

}

- (BOOL)isGreaterThan:(Version *)other __unused {
    if (!other) return NO;
    return [self asNumber] > [other asNumber];
}

- (BOOL)isLessThan:(Version *)other __unused {
    return [self asNumber] < [other asNumber];
}

- (BOOL)isGreaterOrEqualTo:(Version *)other __unused {
    return [self asNumber] >= [other asNumber];
}

- (BOOL)isLessOrEqualTo:(Version *)other __unused {
    return [self asNumber] <= [other asNumber];
}

- (NSUInteger)asNumber {
    return self.build + 1000 * self.minor + 1000000 * self.major;
}

- (BOOL)isEqualTo:(Version *)other __unused {
    if (!other) return NO;
    return [self asNumber] == [other asNumber];
}

- (NSString *)toString __unused {
    NSString *s = [NSString stringWithFormat:@"%lu.%lu.%lu", (unsigned long) self.major, (unsigned long) self.minor, (unsigned long) self.build];
    return s;
}

- (NSString *)description {
    return [self toString];
}

@end