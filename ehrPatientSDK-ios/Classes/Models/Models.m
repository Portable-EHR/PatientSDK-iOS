//
// Created by Yves Le Borgne on 2023-01-28.
//

#import <IBConsent.h>
#import "Models.h"
#import "ConvoPlacesModel.h"
#import "EulaModel.h"
#import "NotificationsModel.h"
#import "UserModel.h"
#import "IBConsent.h"

@interface Models () {
    NSInteger             _instanceNumber;
    ConvoPlacesModel      *_convoPlaces;
    EulaModel             *_eula;
    NotificationsModel    *_notifications;
    UserModel             *_userModel;
    NSArray <IBConsent *> *_consents;
}
@end

@implementation Models

- (ConvoPlacesModel *)conversationPlaces {
    return _convoPlaces;
}

- (EulaModel *)eula {
    return _eula;
}

- (NotificationsModel *)notifications {
    return _notifications;
}

- (UserModel *)userModel {
    return _userModel;
}

- (NSArray <IBConsent *> *)consents {
    return _consents;
}

TRACE_OFF

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        _convoPlaces   = [[ConvoPlacesModel alloc] init];
        _eula          = [[EulaModel alloc] init];
        _notifications = [[NotificationsModel alloc] init];
        _userModel     = [UserModel guest];
        _consents      = [NSMutableArray array];

    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
    _convoPlaces   = nil;
    _eula          = nil;
    _notifications = nil;
    _userModel     = nil;
}

@end