//
// Created by Yves Le Borgne on 2015-10-01.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "GERuntimeConstants.h"
#import "EHRServerResponse.h"
#import "EHRRequestStatus.h"
#import "GEMacros.h"

@implementation EHRServerResponse

TRACE_OFF

-(id) init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

#pragma mark - EHRPersistableP

+(id)objectWithContentsOfDictionary:(NSDictionary *)theDictionary {
    EHRServerResponse *resp = [[EHRServerResponse alloc] init];
    id val = nil;
    if((val = [theDictionary objectForKey:@"requestStatus"])) resp.requestStatus=[EHRRequestStatus objectWithContentsOfDictionary:val];
    if((val = [theDictionary objectForKey:@"responseContent"])) resp.responseContent=val; //todo : should validate it is a dictionary
    return resp;
}

-(NSDictionary *) asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.requestStatus) [dic setObject:[self.requestStatus asDictionary] forKey:@"requestStatus"];
    if(self.responseContent) [dic setObject:self.responseContent forKey:@"responseContent"];
    return dic;
}

-(void) dealloc{

    GE_DEALLOC();
    GE_DEALLOC_ECHO();

}

@end
