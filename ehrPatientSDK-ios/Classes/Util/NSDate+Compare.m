//
// Created by Yves Le Borgne on 2022-12-31.
//

#import "NSDate+Compare.h"
#import "DateUtil.h"

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

    NSDate *todayWithoutTime = [DateUtil dateWithoutTime:[NSDate date]];
    NSDate *selfWithoutTime =[DateUtil dateWithoutTime:self];
    NSComparisonResult result = [todayWithoutTime compare:selfWithoutTime];

    return result == NSOrderedSame;

}

-(BOOL)isYesterday {
    // Create an instance of NSCalendar
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDate *todayWithoutTime = [DateUtil dateWithoutTime:[NSDate date]];
    NSDateComponents *oneDayComponent = [[NSDateComponents alloc] init];
    [oneDayComponent setDay:-1];
    NSDate *yesterdayDateWithoutTime = [calendar dateByAddingComponents:oneDayComponent toDate:todayWithoutTime options:0];

    NSDate *selfWithoutTime =[DateUtil dateWithoutTime:self];
    NSComparisonResult result = [selfWithoutTime compare:yesterdayDateWithoutTime];

    return result == NSOrderedSame;
}

-(NSInteger)daysToNow {
    return [DateUtil daysBetween:[NSDate date] and:self];
}

-(BOOL)sameDayAs:(NSDate *)otherDate {
    NSDate *selfWithoutTime=[DateUtil dateWithoutTime:self];
    NSDate *otherWithoutTime=[DateUtil dateWithoutTime:otherDate];
    NSComparisonResult result = [selfWithoutTime compare:otherWithoutTime];
    return result == NSOrderedSame;
}

-(BOOL)isSameYearAs:(NSDate *)otherDate {
    return [DateUtil isDate:self inSameYearAs:otherDate];
}

@end