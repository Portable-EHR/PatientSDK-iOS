//
//  GERuntimeConstants.h
//  Max Power
//
//  Created by Yves Le Borgne on 10-09-19.
//  // Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <mach/mach.h>
#import <sys/proc.h>
#import "EHRInstanceCounterP.h"
#import "Version.h"
#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMacroInspection"
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
#pragma ide diagnostic ignored "OCUnusedGlobalDeclarationInspection"
#define GENodeGeometryZero = GENodeGeometryMake(0,0,0,0)

@class Version;
@protocol EHRPersistableP;
@protocol EHRInstanceCounterP;

typedef enum CCScreenMode : NSUInteger {
    CCScreenModeUnknown      = 0,
    CCScreenModeFlexibleSize = 1,
    CCScreenModeFixedSize    = 2

} CCScreenMode;


// note : the sizes below are all 'design' pixels, ie the game
//		  is supposed to run on a 480x320 device.
//
//		  With iPone 4 whose size is 960x640, but has the same
//		  physical size as the iPhone 3 and iPodTouch devices, we
//		  will need to scale up every pic we read in order to achieve
//		  the same look.


extern NSString *kSystemVersion;

extern NSMutableDictionary *kHostNames;
extern NSString            *kStackKey;
extern NSString            *kHostName;
extern NSString            *kLocalIPaddress;

extern UIColor *kColorDarkening10;
extern UIColor *kColorDarkening20;
extern UIColor *kColorDarkening30;
extern UIColor *kColorDarkening40;
extern UIColor *kColorDarkening60;
extern UIColor *kColorBackgroundHighlight;
extern UIColor *kColorBackground;
extern UIColor *kColorSelectable;
extern UIColor *kColorSelected;
extern UIColor *kColorText;
extern UIColor *kColorErrorText;
extern UIColor *kColorCyan;
extern UIColor *kColorTransparent;
extern UIColor *kColorHide;
extern UIColor *kColorArchive;
extern UIColor *kColorAppleBlue;
extern UIColor *kColorAppleImessageBlue;

extern UIFont *kBandTitleFont;
extern UIFont *kBandContentFont;
extern UIFont *kMenuButtonFont;
extern UIFont *kEulaContentFont;
extern UIFont *kWarningFont;

extern CGFloat kToolbarHeight;
extern CGFloat kToolbarItemSize;

// notifications

extern NSString *kNotificationUpdated;
extern NSString *kNewNotification;
extern NSString *kNotificationsModelRefreshNotification;
extern NSString *kEulaModelRefreshNotification;
extern NSString *kPatientModelRefreshNotification;
extern NSString *kUserModelRefreshNotification;
extern NSString *kUserDeactivatedNotification;
extern NSString *kAuthenticationFailure;            // for StartViewController, posted by EHRCall
extern NSString *kServerMaintenance;                // for StartViewController, posted by EHRCall
extern NSString *kAppMustUpdate;                    // for StartViewController, posted by EHRCall
extern NSString *kAppWillResumeForeground;

extern NSString  *kAppAlias;
extern NSString  *kAppGuid;
extern Version   *kAppVersion;
extern NSInteger kBuildNumber;

// network parameters

extern NSInteger kNetworkRetries;
extern float     kNetworkTimeOut;
extern float     kNetworkForegroundRefreshInSecs;
extern float     kNetworkBackgroundRefreshInSecs;

typedef struct CGBounds {
    CGFloat start;
    CGFloat top;
    CGFloat end;
    CGFloat bottom;
}                CGBounds;

extern const CGBounds CGBoundsZero;

extern CGBounds getWindowCrop(void);
extern BOOL isDarkMode(void);

extern NSString *NSStringFromCGBounds(CGBounds b);

//typedef void(^VoidBlock)(void);
//typedef void(^SenderBlock)(id call);
//typedef void(^NSErrorBlock)(NSError *);

extern CGBounds CGBoundsMake(CGFloat start, CGFloat top, CGFloat end, CGFloat bottom);

@interface GERuntimeConstants : NSObject {
}

+ (NSArray *)allocatedClasses;
+ (void)addAllocatedClass:(NSString *)className;
+ (NSString *)allocatedClassesAsString;
+ (NSString *)remainingAllocatedClassesAsString;
+ (void)setAppAlias:(NSString *)appAlias;
+ (void)setLocalIPaddress:(NSString *)address;
+ (void)setAppGuid:(NSString *)appGuid;
+ (void)setAppVersion:(NSString *)appVersionAsString;
+ (void)setBuildNumber:(NSInteger)buildNumber;
+ (void)setStackKey:(NSString *)key;
+ (NSString *)getHostNameForStackKey:(NSString *)key;
+ (NSString *)getStackKeyForHostName:(NSString *)hostName;

extern NSString *NormalizedVersionString(NSString *versionString);

extern void openScheme(NSString *scheme);
extern BOOL WantBool(id val);
extern NSDate *WantDateFromDic(NSDictionary *dic, NSString *key);
extern NSString *WantStringFromDic(NSDictionary *dic, NSString *key);
extern NSDictionary *WantDicFromDic(NSDictionary *dic, NSString *key);
extern NSArray *WantArrayFromDic(NSDictionary *dic, NSString *key);
extern NSInteger WantIntegerFromDic(NSDictionary *dic, NSString *key);
extern BOOL WantBoolFromDic(NSDictionary *dic, NSString *key);
extern NSURL *WantUrlFromDic(NSDictionary *dic, NSString *key);
extern void PutDateInDic(NSDate *theDate, NSMutableDictionary *dic, NSString *key);
extern void PutStringInDic(NSString *token, NSMutableDictionary *dic, NSString *key);
extern void PutIntegerInDic(NSInteger theInt, NSMutableDictionary *dic, NSString *key);
extern void PutBoolInDic(BOOL theBool, NSMutableDictionary *dic, NSString *key);
extern void PutUrlInDic(NSURL *theUrl, NSMutableDictionary *dic, NSString *key);
extern void PutPersistableInDic(id <EHRPersistableP> token, NSMutableDictionary *dic, NSString *key);

extern NSDate *now(void);
extern NSDate *forever(void);

extern NSString *NetworkDateFromDate(NSDate *date);
extern NSString *NSStringFromBool(BOOL theBool);
extern NSString *NetworkStringFromBool(BOOL theBool);
extern BOOL BoolFromString(NSString *theBool);

#define degreesToRadians(x) (M_PI * (x) / 180.0)

extern float deviceFontSize(float normalizedFont);
extern float deviceOffset(float normalizedOffset);
extern CGRect currentWindowSize(void);

extern void QuietLog(NSString *format, ...);
extern void Carp(NSException *e, NSString *message);

extern unsigned long get_memory_bytes(void);
extern float get_memory_kb(void);
extern float get_memory_mb(void);

extern BOOL systemVersionEqualTo(NSString *dotVersionAsString);
extern BOOL systemVersionGreaterThan(NSString *dotVersionAsString);
extern BOOL systemVersionGreaterThanOrEqualTo(NSString *dotVersionAsString);
extern BOOL systemVersionLessThan(NSString *dotVersionAsString);
extern BOOL systemVersionLessThanOrEqualTo(NSString *dotVersionAsString);

@end

#pragma clang diagnostic pop
