//
//  GEDeviceHardware.m
//  Max Power
//
//  Created by Yves Le Borgne on 11-11-24.
//  Copyright 2010-2014-2013 Max Power Studios inc. All rights reserved.
//

// ref : https://gist.github.com/adamawolf/3048717


#import "GEDeviceHardware.h"
#import "sys/sysctl.h"

@implementation GEDeviceHardware

- (id)init {

    self = [super init];
    if (self) {
        // Initialization code here.
    }

    return self;
}

+ (NSString *)platform {

    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

+ (NSString *)platformString {

    /*

        ref http://theiphonewiki.com/wiki/Models
        ref https://en.wikipedia.org/wiki/List_of_iOS_devices

        This is all public Apple API's, should not be cause for rejection

    */

    NSString *platform = [self platform];

    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";

    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (GSM)"; // GSM
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (GSM+CDMA)"; // Global
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5C (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5C (Global)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5S"; // GSM
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5S"; // Global
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6S"; // Global
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6S Plus"; // Global
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE"; // Global
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7 CDMA";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7+ CDMA";
    if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7 Global";
    if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7+ Global";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8 Global";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8+ Global/Asia";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X Global/Asia";
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8 Global";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8+ Global";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X Global";
    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"]) return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
    if ([platform isEqualToString:@"iPhone12,8"]) return @"iPhone 11 Pro Gen";

    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"]) return @"iPod Touch 6G";
    if ([platform isEqualToString:@"iPod9,1"]) return @"iPod Touch 7G";

    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([platform isEqualToString:@"iPad1,2"]) return @"iPad 3G";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2 (CDMAS)";
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini (CSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3 WiFi";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3 CDMA";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3 GSM";
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4 Wifi";
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4 (GSM+LTE)";
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4 (CDMA+LTE)";
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air (GSM+LTE)";
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air (CDMA+LTE)";
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2 (CDMA+LTE)";
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2 (CDMA+LTE)";
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2 (CDMA+LTE)";
    if ([platform isEqualToString:@"iPad4,7"]) return @"iPad Mini 3 (CDMA+LTE)";
    if ([platform isEqualToString:@"iPad4,8"]) return @"iPad Mini 3 (CDMA+LTE)";
    if ([platform isEqualToString:@"iPad4,9"]) return @"iPad Mini 3 (CDMA+LTE)";
    if ([platform isEqualToString:@"iPad5,1"]) return @"iPad Mini 4 (WiFi)";
    if ([platform isEqualToString:@"iPad5,2"]) return @"iPad Mini 4 (WiFi)";
    if ([platform isEqualToString:@"iPad5,3"]) return @"iPad Air 2 (WiFi)";
    if ([platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2 (CDMA+LTE)";
    if ([platform isEqualToString:@"iPad6,3"]) return @"iPad Pro 9.7";
    if ([platform isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7";
    if ([platform isEqualToString:@"iPad7,3"]) return @"iPad Pro 10.5";
    if ([platform isEqualToString:@"iPad7,4"]) return @"iPad Pro 10.5";
    if ([platform isEqualToString:@"iPad7,1"]) return @"iPad Pro 12.9";
    if ([platform isEqualToString:@"iPad7,2"]) return @"iPad Pro 12.9";
    if ([platform isEqualToString:@"iPad6,7"]) return @"iPad Pro 12.9 in.";
    if ([platform isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9 in.";
    if ([platform isEqualToString:@"iPad6,11"]) return @"iPad 2017 (WiFi+LTE) ";
    if ([platform isEqualToString:@"iPad6,12"]) return @"iPad 2017 (WiFi+LTE)";
    if ([platform isEqualToString:@"iPad7,1"]) return @"iPad Pro, 2nd gen 12.9 (WiFi)";
    if ([platform isEqualToString:@"iPad7,2"]) return @"iPad Pro, 2nd gen 12.9(WiFi+LTE)";
    if ([platform isEqualToString:@"iPad7,3"]) return @"iPad Pro, 3d gen 10.5(WiFi)";
    if ([platform isEqualToString:@"iPad7,4"]) return @"iPad Pro, 3d gen 10.5(WiFi+LTE)";

    if ([platform isEqualToString:@"iPad8,1"]) return @"iPad Pro, 3d gen 11.0 (WiFi)";
    if ([platform isEqualToString:@"iPad8,2"]) return @"iPad Pro, 3d gen 11.0 (WiFi)";
    if ([platform isEqualToString:@"iPad8,3"]) return @"iPad Pro, 3d gen 11.0 (WiFi)";
    if ([platform isEqualToString:@"iPad8,4"]) return @"iPad Pro, 3d gen 11.0 (WiFi)";
    if ([platform isEqualToString:@"iPad8,5"]) return @"iPad Pro, 3d gen 12.9 (WiFi)";
    if ([platform isEqualToString:@"iPad8,6"]) return @"iPad Pro, 3d gen 12.9 (WiFi)";
    if ([platform isEqualToString:@"iPad8,7"]) return @"iPad Pro, 3d gen 12.9 (WiFi)";
    if ([platform isEqualToString:@"iPad8,8"]) return @"iPad Pro, 3d gen 12.9 (WiFi)";
    if ([platform isEqualToString:@"iPad8,9"]) return @"iPad Pro, 2nd gen 11.0 (WiFi)";
    if ([platform isEqualToString:@"iPad8,10"]) return @"iPad Pro, 2nd gen 11.0 (WiFi+cell)";
    if ([platform isEqualToString:@"iPad8,11"]) return @"iPad Pro, 4d gen 12.9 (WiFi)";
    if ([platform isEqualToString:@"iPad8,12"]) return @"iPad Pro, 4d gen 12.9 (WiFi+cell)";
    if ([platform isEqualToString:@"iPad8,9"]) return @"iPad Pro, 3d gen 12.9 (WiFi)";

    if ([platform isEqualToString:@"i386"]) return @"Simulator";
    if ([platform isEqualToString:@"x86_64"]) return @"Simulator";

    return platform;
}

+ (BOOL)isSimulator {
    if ([[GEDeviceHardware platformString] isEqualToString:@"Simulator"]) return YES;
    return NO;
}

+ (BOOL)isDevice __unused {
    return ![GEDeviceHardware isSimulator];
}

+ (BOOL)isPhone __unused {
    if ([self isDevice]) {
        NSString *platform = [self platform];
        return [platform hasPrefix:@"iPhone"];
    } else {
        // simulator here ... revert to intervace idiom
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    }

}

+ (BOOL)isTablet __unused {
    if ([self isDevice]) {
        NSString *platform = [self platform];
        return [platform hasPrefix:@"iPad"];
    } else {
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    }
}

+ (BOOL)isIpod  __unused {
    if ([self isDevice]) {
        NSString *platform = [self platform];
        return [platform hasPrefix:@"iPod"];
    } else {
        return NO;
    }
}

+ (BOOL)isDumbAssPhone __unused {

    CGSize sz = [UIScreen mainScreen].bounds.size;
    if (sz.height == 812 || sz.width == 812) return YES;
    if (sz.height == 896 || sz.width == 896) return YES;
    return NO;
    // todo : this may not be true with latest wave of apple mad devices, true for iphone X
}

+ (BOOL)isDumbAssIpad __unused {

    CGSize sz = [UIScreen mainScreen].bounds.size;
    if (sz.height == 1366 || sz.width == 1366) return YES;
    if (sz.height == 1194 || sz.width == 1194) return YES;
    return NO;
    // todo : this may not be true with latest wave of apple mad devices, true for iphone X
}

+ (CGBounds)windowCrop {
    CGBounds crop = CGBoundsZero;
    if ([self isTablet]) {
        if ([self isDumbAssIpad]) {
            CGFloat                bottomMargin = 16.0f;
            CGFloat                leftMargin   = 16.0f;
            UIInterfaceOrientation orientation  = [[UIApplication sharedApplication] statusBarOrientation];
            if (orientation == UIInterfaceOrientationPortrait) {
                crop = CGBoundsMake(0, 0, 0, bottomMargin);
            } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
                // device does not honor the orientation and presents view with top to the right
                // need to offset from left !
                crop = CGBoundsMake(0, 0, 0, bottomMargin);
            } else if (orientation == UIInterfaceOrientationLandscapeRight) {
                crop = CGBoundsMake(leftMargin, 0, 0, bottomMargin);
            } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
                crop = CGBoundsMake(0, 0, leftMargin, bottomMargin);
            }
        }
    } else if ([self isPhone]) {
        if ([self isDumbAssPhone]) {
            CGFloat                bottomMargin = 16.0f;
            CGFloat                leftMargin   = 32.0f;
            UIInterfaceOrientation orientation  = [[UIApplication sharedApplication] statusBarOrientation];
            if (orientation == UIInterfaceOrientationPortrait) {
                crop = CGBoundsMake(0, 0, 0, bottomMargin);
            } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
                // device does not honor the orientation and presents view with top to the right
                // need to offset from left !
                crop = CGBoundsMake(bottomMargin, 0, 0, 0);
            } else if (orientation == UIInterfaceOrientationLandscapeRight) {
                crop = CGBoundsMake(leftMargin, 0, 0, bottomMargin);
            } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
                crop = CGBoundsMake(0, 0, leftMargin, bottomMargin);
            }
        }
    }
    return crop;
}

+ (BOOL)isIpad {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);

}

@end
