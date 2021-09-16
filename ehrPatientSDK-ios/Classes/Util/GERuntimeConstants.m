//
//  GERuntimeConstants.m
//  Max Power
//
//  Created by Yves Le Borgne on 10-09-19.
//  // Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//


#import "EHRInstanceCounterP.h"
#import "GEDeviceHardware.h"
#import "Version.h"
#import "EHRPersistableP.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
#pragma ide diagnostic ignored "OCUnusedGlobalDeclarationInspection"
Version  *kAppVersion;
NSString *kAppAlias;
NSString *kAppGuid;

NSString *kSystemVersion = @"000000";

NSString     *kNotificationsModelRefreshNotification = @"kNotificationsModelRefreshNotification";
NSString     *kEulaModelRefreshNotification          = @"kEulaModelRefreshNotification";
NSString     *kPatientModelRefreshNotification       = @"kPatientModelRefreshNotification";
NSString     *kUserModelRefreshNotification          = @"kUserModelRefreshNotification";
NSString     *kUserDeactivatedNotification           = @"kUserDeactivatedNotification";
NSString     *kAppWillResumeForeground               = @"kAppWillResumeForeground";
NSString     *kAuthenticationFailure                 = @"kAuthenticationFailure";
NSString     *kServerMaintenance                     = @"kServerMaintenance";
NSString     *kAppMustUpdate                         = @"kAppMustUpdate";
NSDictionary *kHostNames;
NSString     *kHostName                              = @"portableehr.ca";
NSString     *kStackKey                              = @"CA.prod";
NSInteger    kBuildNumber                            = 10;

UIColor *kColorBackgroundHighlight;
UIColor *kColorDarkening10;
UIColor *kColorDarkening20;
UIColor *kColorDarkening30;
UIColor *kColorDarkening40;
UIColor *kColorDarkening60;
UIColor *kColorBackground;
UIColor *kColorSelectable;
UIColor *kColorSelected;
UIColor *kColorText;
UIColor *kColorErrorText;
UIColor *kColorCyan;
UIColor *kColorTransparent;
UIColor *kColorArchive;
UIColor *kColorHide;
UIFont  *kBandTitleFont;
UIFont  *kWarningFont;
UIFont  *kBandContentFont;
UIFont  *kMenuButtonFont;
UIFont  *kEulaContentFont;

CGFloat kToolbarHeight   = 40.0;
CGFloat kToolbarItemSize = 24.0;

// network stuff
#ifndef MP_DEBUG
#define MP_DEBUG  0
#endif

#if MP_DEBUG

NSInteger kNetworkRetries                 = 1;
float     kNetworkTimeOut                 = 30;
float     kNetworkForegroundRefreshInSecs = 15;     // 15 seconds
float     kNetworkBackgroundRefreshInSecs = 15 * 60;  // 15 minutes
#else
NSInteger kNetworkRetries                 = 3;
float     kNetworkTimeOut                 = 30;
float     kNetworkForegroundRefreshInSecs = 15;     // 15 seconds
float     kNetworkBackgroundRefreshInSecs = 15 * 60;  // 15 minutes
#endif

int const K_LAST_SCENE         = 40;
BOOL      kIsIpad              = NO;
BOOL      kIsIphoneIpod        = YES;
BOOL      kIsIphoneIpodTall    = NO;
BOOL      kIsRetina            = NO;
int       kMapRightMenuWidth   = 0;
int       kMapBottomMenuHeight = 0;

// confidential statics

static BOOL _isDeviceTypeSet = NO;

@interface GERuntimeConstants ()
NSString *classNotWired(NSString *theClass);
NSString *classDoesNotRespond(NSString *theClass);
NSString *classInstances(NSString *theClass);
NSString *remainingClassInstances(NSString *theClass);
@end

@implementation GERuntimeConstants

static __strong NSMutableArray *allocatedClasses;

+ (void)initialize {

    kAppVersion  = [Version versionWithMajor:1 minor:1 build:38];
    kBuildNumber = 10;
    kAppAlias    = @"pehr.patient.ios";

    MPLOG(@"Initializing Run time constants %@", NSStringFromBool(YES));
    kSystemVersion = NormalizedVersionString([[UIDevice currentDevice] systemVersion]);
    MPLOG(@"Running iOS version : %@", kSystemVersion);
    MPLOG(@"Running on          : %@", [GEDeviceHardware platformString]);
    CGSize sz = [UIScreen mainScreen].bounds.size;
    MPLOG(@"Screen dimensions   : %@", NSStringFromCGSize(sz));
    MPLOG(@"App alias           : %@", kAppAlias);
    MPLOG(@"App version         : %@", [kAppVersion toString]);
    MPLOG(@"App build number    : %lu", (long) kBuildNumber);
    allocatedClasses = [NSMutableArray array];
    _isDeviceTypeSet = NO;

    kColorDarkening10         = [UIColor colorWithRed:0.f / 255.f green:0.f / 255.f blue:0.f / 255.f alpha:0.1f]; // 33586B
    kColorDarkening20         = [UIColor colorWithRed:0.f / 255.f green:0.f / 255.f blue:0.f / 255.f alpha:0.2f]; // 33586B
    kColorDarkening30         = [UIColor colorWithRed:0.f / 255.f green:0.f / 255.f blue:0.f / 255.f alpha:0.3f]; // 33586B
    kColorDarkening40         = [UIColor colorWithRed:0.f / 255.f green:0.f / 255.f blue:0.f / 255.f alpha:0.4f]; // 33586B
    kColorDarkening60         = [UIColor colorWithRed:0.f / 255.f green:0.f / 255.f blue:0.f / 255.f alpha:0.6f]; // 33586B
    kColorBackgroundHighlight = [UIColor colorWithRed:51.f / 255.f green:88.f / 255.f blue:107.f / 255.f alpha:1.f]; // 33586B
    kColorBackground          = [UIColor colorWithRed:34.f / 255.f green:91.f / 255.f blue:120.f / 255.f alpha:1.f]; // 225B78
    kColorText                = [UIColor whiteColor];
    kColorErrorText           = [UIColor colorWithRed:254.f / 255.f green:176.f / 255.f blue:26.f / 255.f alpha:1.f];
    kColorSelectable          = [UIColor colorWithRed:177.f / 255.f green:240.f / 255.f blue:230.f / 255.f alpha:1.f];
    kColorSelected            = [UIColor colorWithRed:177.f / 255.f green:240.f / 255.f blue:230.f / 255.f alpha:.41];
    kColorArchive             = [UIColor colorWithRed:171.0f / 255.0f green:31.0f / 255.0f blue:32.0f / 255.0f alpha:1.0f];
    kColorHide                = [UIColor colorWithRed:50.0f / 255.0f green:153.0f / 255.0f blue:187.0f / 255.0f alpha:1.0f];
    kColorTransparent         = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    kColorCyan                = [UIColor cyanColor];

    kBandTitleFont   = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    kBandContentFont = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:16];
    kMenuButtonFont  = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    kEulaContentFont = [UIFont fontWithName:@"HelveticaNeue" size:14];
    kWarningFont     = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];

    NSMutableDictionary *kvps = [NSMutableDictionary dictionary];
    kvps[@"CA.prod"]      = @"portableehr.ca";
    kvps[@"CA.staging"]   = @"portableehr.net";
    kvps[@"CA.devhome"]   = @"10.0.1.21";
    kvps[@"CA.devoffice"] = @"192.168.32.32";
    kHostNames = kvps;
    kStackKey  = @"CA.prod";
    kHostName  = kHostNames[kStackKey];
    kIsIpad    = [GEDeviceHardware isTablet];

    if (@available(iOS 12.0, *)) {

        switch (UIScreen.mainScreen.traitCollection.userInterfaceStyle) {
            case UIUserInterfaceStyleDark:
                // put your dark mode code here
                // https://stackoverflow.com/a/19128558/915467
                MPLOG(@"IS DARK !");
                break;
            case UIUserInterfaceStyleLight:
            case UIUserInterfaceStyleUnspecified:MPLOG(@"IS NOT DARK !");
                break;
            default:break;
        }
    }

}

const CGBounds CGBoundsZero;

CGBounds getWindowCrop() {
    CGBounds crop = [GEDeviceHardware windowCrop];
    return crop;
}

BOOL isDarkMode() {
    BOOL result = NO;
    if (@available(iOS 12.0, *)) {
        switch (UIScreen.mainScreen.traitCollection.userInterfaceStyle) {
            case UIUserInterfaceStyleDark:
                // https://stackoverflow.com/a/19128558/915467
                result = YES;
                break;
            case UIUserInterfaceStyleLight:
            case UIUserInterfaceStyleUnspecified:break;
            default:break;
        }
    }
    return result;
}

CGBounds CGBoundsMake(CGFloat start, CGFloat top, CGFloat end, CGFloat bottom) {
    CGBounds bounds;
    bounds.start  = start;
    bounds.top    = top;
    bounds.end    = end;
    bounds.bottom = bottom;
    return bounds;
}

NSString *NSStringFromCGBounds(CGBounds a) {
    NSString *ret = @"(s: %f, t: %f, e: %f, b: %f)";
    return [NSString stringWithFormat:ret, a.start, a.top, a.end, a.bottom];
}

+ (void)setStackKey:(NSString *)serverKey {
    MPLOG(@"Setting server key to [%@]", serverKey);
    kStackKey = serverKey;
    kHostName = kHostNames[serverKey];

    if (!kHostName) {
        MPLOGERROR(@"**** No nost name for key [%@], carping out", serverKey);
        exit(9);
    }

}

+ (NSString *)getHostNameForStackKey:(NSString *)key {
    if (!key) {
        MPLOGERROR(@"**** Attempt to get host name for nil key, bailing out");
        return nil;
    }
    NSString *hostName = kHostNames[key];
    if (!hostName) {
        MPLOGERROR(@"**** Attempt to get host name for invalid key [%@], bailing out", key);
        return nil;
    }
    return hostName;
}

+ (NSString *)getStackKeyForHostName:(NSString *)hostName {
    if (!hostName) {
        MPLOGERROR(@"**** Attempt to get host name for nil key [%@], bailing out", hostName);
        return nil;
    }
    for (NSString *key in [kHostNames allKeys]) {
        NSString *strawman = kHostNames[key];
        if ([strawman isEqualToString:hostName]) return key;
    }
    MPLOGERROR(@"**** Attempt to get stack key for invalid host [%@], bailing out", hostName);
    return nil;
}

+ (void)setAppAlias:(NSString *)appAlias {
    kAppAlias = appAlias;
}

+ (void)setAppGuid:(NSString *)appGuid {
    kAppGuid = appGuid;
}

+ (void)setAppVersion:(NSString *)appVersionAsString {
    kAppVersion = [Version versionWithString:appVersionAsString];
}

+ (void)setBuildNumber:(NSInteger)buildNumber {
    kBuildNumber = buildNumber;
}

+ (NSArray *)allocatedClasses __unused {

    return allocatedClasses;
}

+ (void)addAllocatedClass:(NSString *)theClass {

    if ([allocatedClasses containsObject:theClass]) return;
    [allocatedClasses addObject:theClass];
}

+ (NSString *)allocatedClassesAsString __unused {

    NSString      *res = @"";
    for (NSString *classAsName in allocatedClasses) {
        id cl = NSClassFromString(classAsName);
        if (cl) {
            res = [res stringByAppendingString:classInstances(classAsName)];
        } else {
            [res stringByAppendingString:classNotWired(classAsName)];
        }
    }
    return res;
}

+ (NSString *)remainingAllocatedClassesAsString __unused {

    NSString      *res = @"";
    for (NSString *classAsName in allocatedClasses) {
        id cl = NSClassFromString(classAsName);
        if (cl) {
            res = [res stringByAppendingString:remainingClassInstances(classAsName)];
        } else {
            [res stringByAppendingString:classNotWired(classAsName)];
        }
    }
    return res;
}

NSString *classNotWired(NSString *theClass) {

    return [NSString stringWithFormat:@"%-30s : Class did not return a class object.\n", [theClass cStringUsingEncoding:NSASCIIStringEncoding]];

}

NSString *classInstances(NSString *theClass) {

    id ob = (id <EHRInstanceCounterP>) NSClassFromString(theClass);
//    @try {

    NSInteger noi = [ob numberOfInstances];
    return [NSString stringWithFormat:@"%-30s : %04li\n", [theClass cStringUsingEncoding:NSASCIIStringEncoding], (long) noi];
//    }
//    @catch (NSException *e) {
//        return [NSString stringWithFormat:@"%-30s : +(NSInteger) numberOfInstances not implemented.\n", [theClass cStringUsingEncoding:NSASCIIStringEncoding]];
//    }

}

NSString *remainingClassInstances(NSString *theClass) {

    id ob = (id <EHRInstanceCounterP>) NSClassFromString(theClass);
//    @try {

    NSInteger noi = [ob numberOfInstances];
    if (noi < 1) return @"";
    return [NSString stringWithFormat:@"%-30s : %04li\n", [theClass cStringUsingEncoding:NSASCIIStringEncoding], (long) noi];
//    }
//    @catch (NSException *e) {
//        return [NSString stringWithFormat:@"%-30s : +(NSInteger) numberOfInstances not implemented.\n", [theClass cStringUsingEncoding:NSASCIIStringEncoding]];
//    }

}

+ (void)setMenuWidth:(int)inMenuWidth {

    kMapRightMenuWidth = inMenuWidth;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CGRect currentWindowSize() {
    UIView *rootView     = [[[UIApplication sharedApplication] keyWindow]
            rootViewController].view;
    CGRect originalFrame = [[UIScreen mainScreen] bounds];
    CGRect adjustedFrame = [rootView convertRect:originalFrame fromView:nil];
    return adjustedFrame;
}

#pragma clang diagnostic pop

NSString *NormalizedVersionString(NSString *versionString) {

    int
            maj    = 0,
            min    = 0,
            subMin = 0;

    NSArray *toks = [versionString componentsSeparatedByString:@"."];
    if ([toks count] > 3) return @"000000";
    if ([toks count] == 0) return @"000000";
    maj = [toks[0] intValue];
    if ([toks count] > 1) min    = [toks[1] intValue];
    if ([toks count] > 2) subMin = [toks[2] intValue];

    return [NSString stringWithFormat:@"%02i%02i%02i", maj, min, subMin];

}

BOOL systemVersionEqualTo(NSString *dotVersionAsString) {

    NSString *normalizedVersion = NormalizedVersionString(dotVersionAsString);
    return ([kSystemVersion compare:normalizedVersion options:NSNumericSearch] == NSOrderedSame);
}

BOOL systemVersionGreaterThan(NSString *dotVersionAsString) {

    NSString *normalizedVersion = NormalizedVersionString(dotVersionAsString);
    return ([kSystemVersion compare:normalizedVersion options:NSNumericSearch] == NSOrderedDescending);
}

BOOL systemVersionGreaterThanOrEqualTo(NSString *dotVersionAsString) {

    NSString *normalizedVersion = NormalizedVersionString(dotVersionAsString);
    return ([kSystemVersion compare:normalizedVersion options:NSNumericSearch] == NSOrderedAscending);
}

BOOL systemVersionLessThan(NSString *dotVersionAsString) {

    NSString *normalizedVersion = NormalizedVersionString(dotVersionAsString);
    return ([kSystemVersion compare:normalizedVersion options:NSNumericSearch] == NSOrderedAscending);
}

BOOL systemVersionLessThanOrEqualTo(NSString *dotVersionAsString) {

    NSString *normalizedVersion = NormalizedVersionString(dotVersionAsString);
    return ([kSystemVersion compare:normalizedVersion options:NSNumericSearch] == NSOrderedDescending);
}

#pragma clang diagnostic push
#pragma ide diagnostic ignored "UnavailableInDeploymentTarget"
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

void openScheme(NSString *scheme) {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL         *URL         = [NSURL URLWithString:scheme];

    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:URL options:@{}
           completionHandler:^(BOOL success) {
               MPLOG(@"Open %@: %d", scheme, success);
           }];
    } else {
        BOOL success = [application openURL:URL];
        MPLOG(@"Open %@: %d", scheme, success);
    }
}

#pragma clang diagnostic pop

//region Persistence helpers

NSDate *WantDateFromDic(NSDictionary *dic, NSString *key) {
    if (!key) return nil;
    id     val;
    NSDate *date = nil;
    if ((val = dic[key])) {
        NSString        *dateAsString = val;
        NSDateFormatter *df           = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
//        NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
//        [df setLocale:posix];
        [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        date = [df dateFromString:dateAsString];
        if (!date) {
            MPLOG(@"String [%@] returned a nil date.", dateAsString);
        }
    }
    return date;
}

NSString *WantStringFromDic(NSDictionary *dic, NSString *key) {
    if (!key) return nil;
    return dic[key];
}

NSDictionary *WantDicFromDic(NSDictionary *dic, NSString *key) {
    if (!key) return nil;
    return dic[key];
}

NSInteger WantIntegerFromDic(NSDictionary *dic, NSString *key) {
    if (!key) return 0;
    if (!dic) return 0;
    id val = (dic[key]);
    return [val integerValue];
}

BOOL WantBoolFromDic(NSDictionary *dic, NSString *key) {
    if (!key) return NO;
    return WantBool(dic[key]);
}

NSURL *WantUrlFromDic(NSDictionary *dic, NSString *key) {
    if (!key) return nil;
    if (!dic) return nil;
    id val = dic[key];
    if (!val) return nil;
    return [NSURL URLWithString:val];
}

void PutDateInDic(NSDate *theDate, NSMutableDictionary *dic, NSString *key) {

    if (!theDate) return;
    if (!dic) return;
    if (!key) return;
    NSString *stringFromDate = NetworkDateFromDate(theDate);
    dic[key] = stringFromDate;

}

void PutStringInDic(NSString *token, NSMutableDictionary *dic, NSString *key) {

    if ([[token class] isKindOfClass:[NSNull class]]) return;
    if (token == (id) [NSNull null]) return;
    if (!token) return;
    if (!dic) return;
    if (!key) return;
    dic[key] = token;
}

void PutPersistableInDic(id <EHRPersistableP> token, NSMutableDictionary *dic, NSString *key) {

    if ([[token class] isKindOfClass:[NSNull class]]) return;
    if (token == (id) [NSNull null]) return;
    if (!token) return;
    if (!dic) return;
    if (!key) return;
    dic[key] = [token asDictionary];
}

void PutIntegerInDic(NSInteger theInt, NSMutableDictionary *dic, NSString *key) {
    if (theInt == 0) return; // save space
    if (!dic) return;
    if (!key) return;
    [dic setObject:[NSNumber numberWithInt:(int) theInt] forKey:key];
}

void PutBoolInDic(BOOL theBool, NSMutableDictionary *dic, NSString *key) {

    if (!theBool) return;                                    // not writing 'NO'
    if (!dic) return;
    if (!key) return;
    [dic setObject:NSStringFromBool(theBool) forKey:key];   // human readable
}

void PutUrlInDic(NSURL *theUrl, NSMutableDictionary *dic, NSString *key) {

    if ([[theUrl class] isKindOfClass:[NSNull class]]) return;
    if (!theUrl) return;                                    // not writing 'NO'
    if (!dic) return;
    if (!key) return;
    [dic setObject:theUrl.absoluteString forKey:key];      // human readable
}

//endregion

//region date helpers

NSDate *now() {
    return [NSDate date];
}

NSDate *forever() {
    return [NSDate dateWithTimeIntervalSince1970:0];
}

NSString *NetworkDateFromDate(NSDate *theDate) {
    if (!theDate) theDate          = [NSDate dateWithTimeIntervalSince1970:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
//    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en"]];
    NSString *stringFromDate = [dateFormatter stringFromDate:theDate];
    return stringFromDate;

}

//endregion

NSString *NSStringFromBool(BOOL theBool) {

    if (!theBool) return @"NO";
    return @"YES";
}

NSString *NetworkStringFromBool(BOOL theBool) {

    if (!theBool) return @"false";
    return @"true";
}

BOOL WantBool(id theBool) {
    if (!theBool) return NO;
    if ([theBool isKindOfClass:[NSNumber class]]) return [theBool boolValue];
    if ([theBool isKindOfClass:[NSString class]]) return BoolFromString(theBool);
    return NO;
}

BOOL BoolFromString(NSString *theBool) {

    if (!theBool) return NO;
    theBool = [theBool uppercaseString];
    if ([theBool isEqualToString:@"YES"]) return YES;
    if ([theBool isEqualToString:@"TRUE"]) return YES;
    if ([theBool isEqualToString:@"1"]) return YES;
    return NO;

}

void Carp(NSException *e, NSString *message) {

    MPLOG(@"*** an exception [%@] occured while  [%@].\n%@\n\n%@",
            e.description,
            message,
            e.callStackSymbols,
            e.callStackReturnAddresses);
}

//region Logging support , dumb ass NSLog
void QuietLog(NSString *format, ...) {

    if (format == nil) {
        printf("nil\n");
        return;
    }

    NSDate          *date = [NSDate date];
    NSDateFormatter *df   = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm:ss.SSS"];
    NSString *formateTime     = [df stringFromDate:date];
    NSString *effectiveFormat = [NSString stringWithFormat:@"%@ | %@", formateTime, format];

    // Get a reference to the arguments that follow the format parameter
    va_list argList;
    va_start(argList, format);
    // Perform format string argument substitution, reinstate %% escapes, then print
    NSString *s = [[NSString alloc] initWithFormat:effectiveFormat arguments:argList];
    printf("%s\n", [[s stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"] UTF8String]);
    va_end(argList);
}
//endregion

//region Memory info
unsigned long get_memory_bytes(void) {

    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t          kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t) &info, &size);
    return kerr == KERN_SUCCESS ? info.resident_size : 0;
}

float get_memory_kb(void) {

    return (get_memory_bytes() / 1024.f);
}

float get_memory_mb(void) {

    return (get_memory_kb() / 1024.f);
}

//endregion

@end

#pragma clang diagnostic pop