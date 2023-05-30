//
// Created by Yves Le Borgne on 2023-01-28.
//

#import <IBConsent.h>
#import "Models.h"
#import "EulaModel.h"
#import "NotificationsModel.h"
#import "UserModel.h"
#import "IBConsent.h"
#import "PehrSDKConfig.h"
#import "ConsentsModel.h"

@interface Models () {
    NSInteger          _instanceNumber;
    EulaModel          *_eula;
    NotificationsModel *_notifications;
    UserModel          *_userModel;
    ConsentsModel      *_consentsModel;
}
@end

@implementation Models

@synthesize consentsModel = _consentsModel;

- (EulaModel *)eula {
    return _eula;
}

- (NotificationsModel *)notifications {
    return _notifications;
}

- (UserModel *)userModel {
    return _userModel;
}

TRACE_OFF

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        _eula          = [[EulaModel alloc] init];
        _notifications = [NotificationsModel instance];
        _userModel     = [UserModel guest];
        _consentsModel = [ConsentsModel instance];

    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
    _eula          = nil;
    _notifications = nil;
    _userModel     = nil;
    _consentsModel = nil;
}

@end