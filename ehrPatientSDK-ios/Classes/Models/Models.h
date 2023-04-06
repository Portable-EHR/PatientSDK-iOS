//
// Created by Yves Le Borgne on 2023-01-28.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "Conversation.h"
#import "IBConsent.h"
@class ConvoPlacesModel;
@class EulaModel;
@class NotificationsModel;
@class UserModel;

@interface Models : NSObject <EHRInstanceCounterP> {

}

@property(nonatomic) NSArray <IBConsent *> *_Nonnull consents;

- (ConvoPlacesModel *_Nullable)conversationPlaces;
- (EulaModel *_Nonnull)eula;
- (NotificationsModel *_Nonnull)notifications;
- (UserModel *_Nonnull)userModel;
- (NSArray <IBConsent *> *_Nonnull)consents;

-(IBConsent* _Nullable) getEulaConsent __unused;
-(IBConsent* _Nullable) getCCRP __unused;

@end