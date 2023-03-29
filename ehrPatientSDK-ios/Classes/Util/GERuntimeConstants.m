//
//  GERuntimeConstants.m
//  Max Power
//
//  Created by Yves Le Borgne on 10-09-19.
//  // Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "GEDeviceHardware.h"
#import "PehrSDKConfig.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
#pragma ide diagnostic ignored "OCUnusedGlobalDeclarationInspection"
Version  *kAppVersion;
NSString *kAppAlias;
NSString *kAppGuid;

NSString *kSystemVersion = @"000000";

NSString            *kNotificationUpdated                   = @"kNotificationUpdated";
NSString            *kNewNotification                       = @"kNewNotification";
NSString            *kNotificationsModelRefreshNotification = @"kNotificationsModelRefreshNotification";
NSString            *kEulaModelRefreshNotification          = @"kEulaModelRefreshNotification";
NSString            *kPatientModelRefreshNotification       = @"kPatientModelRefreshNotification";
NSString            *kUserModelRefreshNotification          = @"kUserModelRefreshNotification";
NSString            *kUserDeactivatedNotification           = @"kUserDeactivatedNotification";
NSString            *kAppWillResumeForeground               = @"kAppWillResumeForeground";
NSString            *kAuthenticationFailure                 = @"kAuthenticationFailure";
NSString            *kServerMaintenance                     = @"kServerMaintenance";
NSString            *kAppMustUpdate                         = @"kAppMustUpdate";
NSMutableDictionary *kHostNames;
NSString            *kHostName                              = @"portableehr.dev";
NSString            *kStackKey                              = @"CA.dev";
NSString            *kLocalIPAddress                        = @"127.0.0.1";
NSInteger           kBuildNumber                            = 10;


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

    NSMutableDictionary *kvps = [NSMutableDictionary dictionary];
    kvps[@"CA.prod"]    = @"portableehr.ca";
    kvps[@"CA.staging"] = @"portableehr.net";
    kvps[@"CA.dev"]     = @"portableehr.dev";
    kvps[@"CA.local"]   = [[PehrSDKConfig shared] getLocalIPaddress];
    kvps[@"CA.partner"] = @"api.portableehr.io";
    kHostNames = kvps;
    kStackKey  = [[PehrSDKConfig shared] getAppStackKey];
    kHostName  = kHostNames[kStackKey];

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

//endregion


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

+ (void)setLocalIPaddress:(NSString *)address {
    kLocalIPAddress = address;
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

NSDate *WantDateFromDic(NSDictionary *dic, NSString *key)  {
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

NSArray *WantArrayFromDic(NSDictionary *dic, NSString *key) {
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
    dic[key] = @((int) theInt);
}

void PutBoolInDic(BOOL theBool, NSMutableDictionary *dic, NSString *key) {

    if (!theBool) return;                                    // not writing 'NO'
    if (!dic) return;
    if (!key) return;
    dic[key] = NSStringFromBool(theBool);   // human readable
}

void PutUrlInDic(NSURL *theUrl, NSMutableDictionary *dic, NSString *key) {

    if ([[theUrl class] isKindOfClass:[NSNull class]]) return;
    if (!theUrl) return;                                    // not writing 'NO'
    if (!dic) return;
    if (!key) return;
    dic[key] = theUrl.absoluteString;      // human readable
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
