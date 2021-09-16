//
//  GETimeUtil.h
//  Max Power
//
//  Created by Yves Le Borgne on 10-08-31.
//  // Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GETimeUtil : NSObject {

}

+ (NSDate *)dateFromString:(NSString *)dateAsString;
+ (NSString *)stringFromDate:(NSDate *)dateAsDate;

+ (NSString *)HHMMSSfromSeconds:(int)seconds;
+ (int)secondsFromHHMMSS:(NSString *)hhmmss;

+ (int)intervalInMinutesBetween:(NSDate *)from to:(NSDate *)to;
+ (int)intervalInSecondsBetween:(NSDate *)from to:(NSDate *)to;

+ (double)currentTimeInMs;

@end
