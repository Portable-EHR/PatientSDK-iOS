//
// Created by Yves Le Borgne on 2023-01-28.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "Conversation.h"
#import "IBConsent.h"
#import "ConsentsModel.h"

@class ConvoPlacesModel;
@class EulaModel;
@class NotificationsModel;
@class UserModel;
@class ConsentsModel;

@interface Models : NSObject <EHRInstanceCounterP> {

}

@property(nonatomic, readonly) ConsentsModel *_Nonnull consentsModel;
- (ConvoPlacesModel *_Nullable)conversationPlaces;
- (EulaModel *_Nonnull)eula;
- (NotificationsModel *_Nonnull)notifications;
- (UserModel *_Nonnull)userModel;

@end