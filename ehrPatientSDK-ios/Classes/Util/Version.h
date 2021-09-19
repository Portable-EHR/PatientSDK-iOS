//
// Created by Yves Le Borgne on 2017-03-15.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "GEMacros.h"

@interface Version : NSObject <EHRInstanceCounterP> {

    NSInteger _instanceNumber;

}
@property(nonatomic) NSUInteger major;
@property(nonatomic) NSUInteger minor;
@property(nonatomic) NSUInteger build;

+ (instancetype)versionWithMajor:(NSUInteger)major minor:(NSUInteger)minor build:(NSUInteger)build;
+ (instancetype)versionWithString:(NSString *)versionAsString;
+(instancetype) iosVersion ;
- (BOOL)isGreaterThan:(Version *)other;
- (BOOL)isLessThan:(Version *)other;
- (BOOL)isGreaterOrEqualTo:(Version *)other;
- (BOOL)isLessOrEqualTo:(Version *)other;
- (BOOL)isEqualTo:(Version *)other;
- (NSString *)toString;
@end
