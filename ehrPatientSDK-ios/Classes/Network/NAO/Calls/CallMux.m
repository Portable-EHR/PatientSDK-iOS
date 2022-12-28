//
// Created by Yves Le Borgne on 2022-12-28.
//

#import "CallMux.h"

@implementation CallMux

TRACE_OFF

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        _app = [[AppCallMux alloc] init];
    } else {
        MPLOG(@"*** super returns nil!");
    }
    return self;
}

- (void)dealloc {
    _app = nil;
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end