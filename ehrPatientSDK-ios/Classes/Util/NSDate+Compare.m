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

@end