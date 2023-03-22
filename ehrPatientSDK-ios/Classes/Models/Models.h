//
// Created by Yves Le Borgne on 2023-01-28.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "Conversation.h"

@class ConvoPlacesModel;
@class EulaModel;
@class NotificationsModel;
@class UserModel;

@interface Models : NSObject <EHRInstanceCounterP> {

}


- (ConvoPlacesModel *_Nullable)conversationPlaces;
- (EulaModel *_Nonnull)eula;
- (NotificationsModel *_Nonnull)notifications;
- (UserModel *_Nonnull)userModel;

@end