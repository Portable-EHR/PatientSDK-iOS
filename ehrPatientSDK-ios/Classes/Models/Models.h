//
// Created by Yves Le Borgne on 2023-01-28.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"

@class ConvoPlacesModel;
@class EulaModel;
@class NotificationsModel;
@class UserModel;

@interface Models : NSObject <EHRInstanceCounterP> {

}

- (ConvoPlacesModel *)conversationPlaces;
- (EulaModel *)eula;
- (NotificationsModel *)notifications;
- (UserModel *)userModel;

@end