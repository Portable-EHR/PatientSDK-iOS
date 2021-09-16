//
// Created by Yves Le Borgne on 2015-10-06.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSON)
+(id) dictionaryWithJSONdata:(NSData*)jsonData;
+(id) dictionaryWithJSON:(NSString*)jsonString;
-(NSData*) asJSONdata;
-(NSString*) asJSON;
@end