//
// Created by Yves Le Borgne on 2022-12-31.
//

#import <Foundation/Foundation.h>

@interface NSDate (Compare)
-(BOOL) isLaterThanOrEqualTo:(NSDate*)date __attribute__((unused));
-(BOOL) isEarlierThanOrEqualTo:(NSDate*)date __attribute__((unused));
-(BOOL) isLaterThan:(NSDate*)date __attribute__((unused));
-(BOOL) isEarlierThan:(NSDate*)date __attribute__((unused));
-(BOOL) isToday __attribute__((unused));
-(BOOL) isYesterday __attribute__((unused));
-(BOOL) isThisMonth __attribute__((unused));
-(NSInteger) daysToNow  __attribute__((unused));
-(BOOL) sameDayAs:(NSDate*) otherDate  __attribute__((unused));
-(BOOL) sameMonthAs:(NSDate*) otherDate  __attribute__((unused));
-(BOOL) sameYearAs:(NSDate*) otherDate  __attribute__((unused));
-(BOOL) inPreviousMonthOf: otherDate  __attribute__((unused));
@end