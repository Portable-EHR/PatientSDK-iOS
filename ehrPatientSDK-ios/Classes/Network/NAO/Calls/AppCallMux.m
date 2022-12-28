//
// Created by Yves Le Borgne on 2022-12-28.
//

#import "AppCallMux.h"

@implementation AppCallMux

TRACE_OFF

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        MPLOG(@"*** super returns nil!");
    }
    return self;
}

-(EHRCall *)getAppInfoCall {
    return nil;
}


- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end