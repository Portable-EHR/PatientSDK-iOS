//
//  EHRGuid.m
//  Max Power
//
//  Created by Yves Le Borgne on 10-10-27.
//  // Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "EHRGuid.h"

@implementation EHRGuid

+ (NSString *)guid {

    return [[NSUUID new] UUIDString];
//    prior to iOS 6
//    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
}

+(NSString *) uuid {
    return [[NSProcessInfo processInfo] globallyUniqueString];
}
@end
