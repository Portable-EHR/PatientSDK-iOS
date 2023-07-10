//
// Created by Yves Le Borgne on 2020-03-11.
// Copyright (c) 2020 Portable EHR inc. All rights reserved.
//

#import "DateUtil.h"
#import "NSDate+Compare.h"

@implementation DateUtil

static int SECONDS_IN_A_MINUTE = 60;
static int SECONDS_IN_A_HOUR   = 60 * 60;
static int SECONDS_IN_A_DAY    = 24 * 60 * 60;
static int SECONDS_IN_A_MONTH  = 30 * 24 * 60 * 60;
static int SECONDS_IN_A_YEAR   = 365 * 24 * 60 * 60;

static NSString* en_abbrev_second= @"s";
static NSString* en_abbrev_minute= @"m";
static NSString* en_abbrev_hour  = @"h";
static NSString* en_abbrev_day   = @"d";
static NSString* en_abbrev_month = @"M";
static NSString* en_abbrev_year  = @"y";

static NSString* fr_abbrev_second= @"s";
static NSString* fr_abbrev_minute= @"m";
static NSString* fr_abbrev_hour  = @"h";
static NSString* fr_abbrev_day   = @"j";
static NSString* fr_abbrev_month = @"M";
static NSString* fr_abbrev_year  = @"a";

+(NSString*) distanceFromDate:(NSDate *) date language:(NSString *) lang decorate:(BOOL) decorate{
    NSDate   *now          = [NSDate date];
    NSString *distance;
    long     nowInSeconds  = (long) [now timeIntervalSince1970];
    long     dateInSeconds = (long) [date timeIntervalSince1970];
    bool inThePast      = (dateInSeconds < nowInSeconds);
    long deltaInSeconds = ABS(nowInSeconds-dateInSeconds);

    NSString*  abbrev_second = en_abbrev_second;
    NSString*  abbrev_minute = en_abbrev_minute;
    NSString*  abbrev_hour   = en_abbrev_hour;
    NSString*  abbrev_day    = en_abbrev_day;
    NSString*  abbrev_month  = en_abbrev_month;
    NSString*  abbrev_year   = en_abbrev_year;
    if ([lang isEqualToString:@"fr"]) {
        abbrev_second = fr_abbrev_second;
        abbrev_minute = fr_abbrev_minute;
        abbrev_hour = fr_abbrev_hour;
        abbrev_day = fr_abbrev_day;
        abbrev_month = fr_abbrev_month;
        abbrev_year = fr_abbrev_year;
    }

    if (deltaInSeconds < SECONDS_IN_A_MINUTE) {
        distance = [NSString stringWithFormat:@"%lu %@",deltaInSeconds,abbrev_second];
    } else if (deltaInSeconds < SECONDS_IN_A_HOUR) {
        deltaInSeconds = deltaInSeconds / SECONDS_IN_A_MINUTE;
        distance = [NSString stringWithFormat:@"%lu %@",deltaInSeconds,abbrev_minute];
    } else if (deltaInSeconds < SECONDS_IN_A_DAY) {
        deltaInSeconds = deltaInSeconds / SECONDS_IN_A_HOUR;
        distance = [NSString stringWithFormat:@"%lu %@",deltaInSeconds,abbrev_hour];
    } else if (deltaInSeconds < SECONDS_IN_A_MONTH) {
        deltaInSeconds = deltaInSeconds / SECONDS_IN_A_DAY;
        distance = [NSString stringWithFormat:@"%lu %@",deltaInSeconds,abbrev_day];
    } else if (deltaInSeconds < SECONDS_IN_A_YEAR) {
        deltaInSeconds = deltaInSeconds / SECONDS_IN_A_MONTH;
        distance = [NSString stringWithFormat:@"%lu %@",deltaInSeconds,abbrev_month];
    } else {
        // years here
        deltaInSeconds = deltaInSeconds / SECONDS_IN_A_YEAR;
        distance = [NSString stringWithFormat:@"%lu %@",deltaInSeconds,abbrev_year];
    }

    if (decorate) {
        if (inThePast) {
            if ([lang isEqualToString:@"fr"]) {
                distance = [NSString stringWithFormat:@"%@ %@",@"il y a",distance];
            } else {
                distance = [NSString stringWithFormat:@"%@ %@",distance, @"ago"];
            }
        } else {
            if ([lang isEqualToString:@"fr"]) {
                distance = [NSString stringWithFormat:@"%@ %@",@"dans",distance];
            } else {
                distance = [NSString stringWithFormat:@"%@ %@",@"in",distance];
            }
        }

    }

    /*
     *         NSString*  distance;
             Date    now           = new Date();
             long    nowmilli      = now.getTime();
             long    datemilli     = date.getTime();
             boolean inThePast     = (datemilli < nowmilli);
             long    deltamilli    = nowmilli - datemilli;
             long    deltaLong     = deltamilli / 1000;
             int     delta         = Math.abs((int) deltaLong);
             NSString*  abbrev_second = en_abbrev_second;
             NSString*  abbrev_minute = en_abbrev_minute;
             NSString*  abbrev_hour   = en_abbrev_hour;
             NSString*  abbrev_day    = en_abbrev_day;
             NSString*  abbrev_month  = en_abbrev_month;
             NSString*  abbrev_year   = en_abbrev_year;
             if (lang.contentEquals("fr")) {
                 abbrev_second = fr_abbrev_second;
                 abbrev_minute = fr_abbrev_minute;
                 abbrev_hour = fr_abbrev_hour;
                 abbrev_day = fr_abbrev_day;
                 abbrev_month = fr_abbrev_month;
                 abbrev_year = fr_abbrev_year;
             }

             if (delta < SECONDS_IN_A_MINUTE) {
                 distance = delta + " " + abbrev_second;
             } else if (delta < SECONDS_IN_A_HOUR) {
                 delta = delta / SECONDS_IN_A_MINUTE;
                 distance = delta + " " + abbrev_minute;
             } else if (delta < SECONDS_IN_A_DAY) {
                 delta = delta / SECONDS_IN_A_HOUR;
                 distance = delta + " " + abbrev_hour;
             } else if (delta < SECONDS_IN_A_MONTH) {
                 delta = delta / SECONDS_IN_A_DAY;
                 distance = delta + " " + abbrev_day;
             } else if (delta < SECONDS_IN_A_YEAR) {
                 delta = delta / SECONDS_IN_A_MONTH;
                 distance = delta + " " + abbrev_month;
             } else {
                 // years here
                 delta = delta / SECONDS_IN_A_YEAR;
                 distance = delta + " " + abbrev_year;
             }

             if (decorate) {
                 if (inThePast) {
                     if (lang.contentEquals("fr")) {
                         distance= @"il y a " + distance;
                     } else {
                         distance = distance + " ago";
                     }
                 } else {
                     if (lang.contentEquals("fr")) {
                         distance= @"dans " + distance;
                     } else {
                         distance= @"in " + distance;
                     }
                 }

             }
     */

    return distance;
}

+(NSString *) displayDate:(NSDate *) date language:(NSString *) lang{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSString *languageString = @"en";
    if ([lang isEqualToString:@"fr"]) languageString=@"fr";
    NSLocale *locale= [[NSLocale alloc] initWithLocaleIdentifier:languageString];
    [dateFormat setLocale:locale];
    [dateFormat setDateFormat:@"d MMM yyyy HH:mm"];
    NSString *dateAsString = [dateFormat stringFromDate:date];
    return dateAsString;
}


+(NSString *) defaultDeviceFormatMedium:(NSDate*) date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle=NSDateFormatterMediumStyle;
    formatter.timeStyle=NSDateFormatterShortStyle;
    formatter.formatterBehavior=NSDateFormatterBehaviorDefault;


    return [formatter stringFromDate:date];

}

 +(NSDate*)dateWithoutTime:(NSDate *)dateWithTime {
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:@"yyyy-MM-dd"];
     NSString *dateAsString  = [dateFormatter stringFromDate:dateWithTime];
     NSDate *dateWithoutTime = [dateFormatter dateFromString:dateAsString];
     return dateWithoutTime;
 }

+(NSInteger) daysBetween:(NSDate*) date and:(NSDate*) otherDate{
    NSDate *startDate = [otherDate isEarlierThanOrEqualTo:date] ? otherDate : date;
    NSDate *endDate = [date isLaterThanOrEqualTo:otherDate] ? date : otherDate;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit units = NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:units fromDate:startDate toDate:endDate options:0];
    NSInteger numberOfDays = components.day;
    return ABS(numberOfDays);
}

+(BOOL)isDate:(NSDate *)firstDate inSameYearAs:(NSDate *)otherDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *date1Components = [calendar components:NSCalendarUnitYear fromDate:firstDate];
    NSDateComponents *date2Components = [calendar components:NSCalendarUnitYear fromDate:otherDate];
    BOOL isSameYear = (date1Components.year == date2Components.year);
    return isSameYear;
}

+(BOOL)isDate:(NSDate *)firstDate inSameMonthAs:(NSDate *)otherDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *date1Components = [calendar components:NSCalendarUnitMonth+NSCalendarUnitYear fromDate:firstDate];
    NSDateComponents *date2Components = [calendar components:NSCalendarUnitMonth+NSCalendarUnitYear fromDate:otherDate];
    BOOL isSameMonth = (date1Components.month == date2Components.month) && (date1Components.year==date2Components.year);
    return isSameMonth;
}

+(BOOL)isDate:(NSDate *)firstDate inPreviousMonthOf:(NSDate *)otherDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *date1Components = [calendar components:NSCalendarUnitMonth+NSCalendarUnitYear fromDate:firstDate];
    NSDateComponents *date2Components = [calendar components:NSCalendarUnitMonth+NSCalendarUnitYear fromDate:otherDate];
    if (date1Components.month==12 && date2Components.month==1){
        return date1Components.year==(date2Components.year -1);
    }

    BOOL isSameMonth = (date1Components.month == (date2Components.month-1)) && (date1Components.year==date2Components.year);
    return isSameMonth;
}

@end