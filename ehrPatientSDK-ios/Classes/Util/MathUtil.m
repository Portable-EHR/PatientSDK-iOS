//
// Created by Yves Le Borgne on 2019-12-25.
// Copyright (c) 2019 Portable EHR inc. All rights reserved.
//

#import "MathUtil.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"
@implementation MathUtil

+ (NSInteger)randomNumberBetween:(NSInteger)min and:(NSInteger)max __unused {
    return min + arc4random_uniform((uint32_t)(max - min + 1));
}

+(BOOL) isOdd:(NSInteger) number{
    return ![self isEven:number];
}

+(BOOL) isEven:(NSInteger) number{
    return ((number % 2) == 0);
}

@end
#pragma clang diagnostic pop