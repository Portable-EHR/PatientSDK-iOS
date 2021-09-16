//
// Created by Yves Le Borgne on 2020-03-11.
// Copyright (c) 2020 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject {

}
+(NSString*) distanceFromDate:(NSDate *) date language:(NSString *) lang decorate:(BOOL) decorate;
+(NSString *) displayDate:(NSDate *) date language:(NSString *) lang;
@end