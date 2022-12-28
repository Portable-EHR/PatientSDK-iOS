//
// Created by Yves Le Borgne on 2017-01-24.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "MessagesModel.h"

@implementation MessagesModel

TRACE_OFF

-(instancetype) init {
    if ((self=[super init])){
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        MPLOGERROR(@"*** Super returned nil !!!");
    }
    return self;
}

/*
 * implement EHRNetworkableP
 */

+ (id)objectWithJSON:(NSString *)jsonString {
    return nil;
}

+ (id)objectWithJSONdata:(NSData *)jsonData {
    return nil;
}

- (NSData *)asJSONdata {
    return nil;
}

- (NSString *)asJSON {
    return nil;
}

/*
 * implement EHRPersistableB
 */

+ (id)objectWithContentsOfDictionary:(NSDictionary *)dic {
    return nil;
}

- (NSDictionary *)asDictionary {
    return nil;
}

/*
 * dealloc, cleanup and stuff
 */

-(void) dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end