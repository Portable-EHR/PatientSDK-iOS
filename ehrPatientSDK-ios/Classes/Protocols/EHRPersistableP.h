//
//  EHRPersistableP.h
//  Battles
//
//  Created by Yves Le Borgne on 12-05-23.
//  Copyright (c) 2012-2014 Max Power Studios inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+JSON.h"

@protocol EHRPersistableP <NSObject>

+ (id)objectWithContentsOfDictionary:(NSDictionary *)dic;
- (NSDictionary *)asDictionary;

@end
