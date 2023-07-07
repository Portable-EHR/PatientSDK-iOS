//
// Created by Yves Le Borgne on 2022-12-31.
//

#import "NSDate+Compare.h"

@implementation NSDate (Compare)

-(BOOL) isLaterThanOrEqualTo:(NSDate*)date __attribute__((unused)) {
    return !([self compare:date] == NSOrderedAscending);
}

-(BOOL) isEarlierThanOrEqualTo:(NSDate*)date __attribute__((unused)) {
    return !([self compare:date] == NSOrderedDescending);
}
-(BOOL) isLaterThan:(NSDate*)date __attribute__((unused)) {
    return ([self compare:date] == NSOrderedDescending);

}
-(BOOL) isEarlierThan:(NSDate*)date __attribute__((unused)) {
    return ([self compare:date] == NSOrderedAscending);
}

-(BOOL)isToday {

    // Get the current date
    NSDate *currentDate = [NSDate date];

    // Create a date formatter to remove the time component from the current date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    NSDate *currentDateWithoutTime = [dateFormatter dateFromString:currentDateString];

    // Create a date formatter to remove the time component from the given date
    NSString *givenDateString = [dateFormatter stringFromDate:self];
    NSDate *givenDateWithoutTime = [dateFormatter dateFromString:givenDateString];

    // Compare the two dates
    NSComparisonResult result = [currentDateWithoutTime compare:givenDateWithoutTime];

    return result == NSOrderedSame;

}

-(BOOL)isYesterday {
    // Create an instance of NSCalendar
    NSCalendar *calendar = [NSCalendar currentCalendar];

    // Get the current date
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    NSDate *currentDateWithoutTime = [dateFormatter dateFromString:currentDateString];

    // Create a date component for one day
    NSDateComponents *oneDayComponent = [[NSDateComponents alloc] init];
    [oneDayComponent setDay:-1];

    // Calculate the date that is one day before the current date
    NSDate *yesterdayDateWithoutTime = [calendar dateByAddingComponents:oneDayComponent toDate:currentDateWithoutTime options:0];

    NSString *selfAsString =  [dateFormatter stringFromDate:self];
    NSDate *selfWithoutTime = [dateFormatter dateFromString:selfAsString];


    // Compare the given date with yesterday's date
    NSComparisonResult result = [selfWithoutTime compare:yesterdayDateWithoutTime];

    return result == NSOrderedSame;
}

@end