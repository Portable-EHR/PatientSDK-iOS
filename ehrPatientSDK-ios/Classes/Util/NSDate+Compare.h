//
// Created by Yves Le Borgne on 2022-12-31.
//

#import <Foundation/Foundation.h>

@interface NSDate (Compare)
-(BOOL) isLaterThanOrEqualTo:(NSDate*)date __attribute__((unused));
-(BOOL) isEarlierThanOrEqualTo:(NSDate*)date __attribute__((unused));
-(BOOL) isLaterThan:(NSDate*)date __attribute__((unused));
-(BOOL) isEarlierThan:(NSDate*)date __attribute__((unused));
@end