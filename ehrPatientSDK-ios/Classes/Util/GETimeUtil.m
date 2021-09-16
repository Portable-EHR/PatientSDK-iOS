//
//  GETimeUtil.m
//  Max Power
//
//  Created by Yves Le Borgne on 10-08-31.
//  // Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "GETimeUtil.h"
@import QuartzCore;

@implementation GETimeUtil


+ (double)currentTimeInMs {
    return CACurrentMediaTime();
}

+ (NSDate *)dateFromString:(NSString *)dateAsString {

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd h:mm:ss a"];
    NSDate *date = [dateFormat dateFromString:dateAsString];
    return date;

}

+ (NSString *)stringFromDate:(NSDate *)dateAsDate {

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd h:mm:ss a"];

    NSString *dateAsString = [dateFormat stringFromDate:dateAsDate];
    return dateAsString;

}

+ (int)secondsFromHHMMSS:(NSString *)hhmmss {

    NSArray *tokens = [hhmmss componentsSeparatedByString:@":"];
    int     hh      = [tokens[0] intValue];
    int     mm      = [tokens[1] intValue];
    int     ss      = [tokens[2] intValue];
    return hh * 3600 + mm * 60 + ss;
}

+ (NSString *)HHMMSSfromSeconds:(int)seconds {

    int hours = (int) floor(seconds / 3600);
    seconds -= hours * 3600;
    int minutes = (int) floor(seconds / 60);
    seconds -= minutes * 60;

    return [NSString stringWithFormat:@"%02d h %02d m %02d s", hours, minutes, seconds];

}

+ (int)intervalInMinutesBetween:(NSDate *)from to:(NSDate *)to {
    int delta = (int) (ABS( [from timeIntervalSince1970] - [to timeIntervalSince1970])/60);
    return delta;
}

+ (int)intervalInSecondsBetween:(NSDate *)from to:(NSDate *)to{
    int delta = (int) (ABS( [from timeIntervalSince1970] - [to timeIntervalSince1970]));
    return delta;
}



@end
