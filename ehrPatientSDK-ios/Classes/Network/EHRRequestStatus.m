//
// Created by Yves Le Borgne on 2015-10-01.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "EHRRequestStatus.h"
#import "GERuntimeConstants.h"

@implementation EHRRequestStatus

TRACE_OFF

- (id)init {

    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

+ (id)objectWithContentsOfDictionary:(NSDictionary *)theDictionary {

    EHRRequestStatus *req = [[EHRRequestStatus alloc] init];
    NSString         *val = nil;
    if ((val = [theDictionary objectForKey:@"route"]))req.route = val;
    if ((val = [theDictionary objectForKey:@"command"])) req.command = val;
    if ((val = [theDictionary objectForKey:@"apiVersion"])) req.apiVersion = val;
    if ((val = [theDictionary objectForKey:@"status"])) req.status = val;
    if ((val = [theDictionary objectForKey:@"message"])) req.message = val;
    return req;

}

- (NSDictionary *)asDictionary {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.route)[dic setObject:self.route forKey:@"route"];
    if (self.command)[dic setObject:self.command forKey:@"command"];
    if (self.apiVersion)[dic setObject:self.apiVersion forKey:@"apiVersion"];
    if (self.status)[dic setObject:self.status forKey:@"status"];
    if (self.message)[dic setObject:self.message forKey:@"message"];
    return dic;

}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end