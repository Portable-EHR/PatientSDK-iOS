//
// Created by Yves Le Borgne on 2022-12-28.
//

#import "WebServices.h"
#import "ConsentWS.h"
#import "NotificationWS.h"

@interface WebServices () {
    NSInteger      _instanceNumber;
    CommandsWS     *_commands;
    ConvoWS        *_convo;
    NotificationWS *_notification;
}
@end

@implementation WebServices

TRACE_OFF

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        _commands     = [[CommandsWS alloc] init];
        _convo        = [[ConvoWS alloc] init];
        _consent      = [[ConsentWS alloc] init];
        _notification = [[NotificationWS alloc] init];
    } else {
        MPLOG(@"*** super returns nil!");
    }
    return self;
}

- (ConvoWS *)__unused  convo {
    return _convo;
}

- (CommandsWS *)__unused commands {
    return _commands;
}

- (ConsentWS *)consent {
    return _consent;
}

- (void)dealloc {
    _commands     = nil;
    _convo        = nil;
    _consent      = nil;
    _notification = nil;
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end
