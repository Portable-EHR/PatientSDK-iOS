//
// Created by Yves Le Borgne on 2019-08-31.
// Copyright (c) 2019 Portable EHR inc. All rights reserved.
//

#import "Inbox.h"
#import "EHRInstanceCounterP.h"
#import "NotificationsModel.h"
#import "UserModel.h"
#import "PatientNotification.h"
#import "PehrSDKConfig.h"

@implementation Inbox

static NSString *NOTIFICATION_CAPABILITY    = @"core.patientNotification";
static NSString *PRIVATE_MESSAGE_CAPABILITY = @"core.privateMessage";
static NSString *APPOINTMENT_CAPABILITY     = @"core.appointment";

TRACE_ON

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        MPLOGERROR(@"*** Super returned nil !!!");
    }
    return self;
}

- (instancetype)initWithPObox:(NSString *)poBox {
    if ((self = [self init])) {
        _pobox = poBox;
    }
    return self;
}

+ (instancetype)notificationsInbox {
    Inbox *ib = [[Inbox alloc] initWithPObox:NOTIFICATION_CAPABILITY];
    return ib;
}

+ (instancetype)privateMessagesInbox {
    Inbox *ib = [[Inbox alloc] initWithPObox:PRIVATE_MESSAGE_CAPABILITY];
    return ib;
}

+ (instancetype)appointmentsInbox {
    Inbox *ib = [[Inbox alloc] initWithPObox:APPOINTMENT_CAPABILITY];
    return ib;
}

- (void)refreshContent {

    if ([_pobox isEqualToString:NOTIFICATION_CAPABILITY]) {
        [self refreshKnownInbox];
    } else if ([_pobox isEqualToString:APPOINTMENT_CAPABILITY]) {
        [self refreshKnownInbox];
    } else if ([_pobox isEqualToString:PRIVATE_MESSAGE_CAPABILITY]) {
        [self refreshKnownInbox];
    } else {
        MPLOGERROR(@"Dont know how to refresh a [%@]", _pobox);
    }

}

- (void)refreshKnownInbox {
    BOOL wasModified = NO;
    if (_inboxNotifications) {
        wasModified = [self updateInbox];
    } else {
        wasModified = [self seedInbox];
    }

    if (wasModified){
        // todo : tell filters attached here.
    }
}

- (BOOL)seedInbox {
    _inboxNotifications = [NSDictionary dictionary];
    _allNotifications = PehrSDKConfig.shared.models.notifications.allNotifications;
    for (PatientNotification *pn in _allNotifications.allValues) {
        MPLOG(@"seeding PN [%@]", [pn description]);
    }
    return YES;
}

- (BOOL)updateInbox {
    return YES;
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end