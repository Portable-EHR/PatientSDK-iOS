//
//  GEDeviceHardware.h
//  Portable EHR inc
//
//  Created by Yves Le Borgne on 11-11-24.
//  // Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PehrSDKConfig.h"

@interface GEDeviceHardware : NSObject

+ (NSString *)platform;
+ (NSString *)platformString;
+ (BOOL)isSimulator;
+ (BOOL)isDevice;
+ (BOOL)isPhone;
+ (BOOL)isTablet;
+ (BOOL)isIpod;
+ (BOOL)isDumbAssPhone;
+ (BOOL)isDumbAssIpad;
+(CGBounds) windowCrop;
@end
