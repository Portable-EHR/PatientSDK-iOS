//
// Created by Yves Le Borgne on 2015-10-01.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"

@protocol EHRNetworkableP <NSObject, EHRPersistableP>

+ (id)objectWithJSON:(NSString *)jsonString;
+ (id)objectWithJSONdata:(NSData *)jsonData;
- (NSData *)asJSONdata;
- (NSString *)asJSON;

@end