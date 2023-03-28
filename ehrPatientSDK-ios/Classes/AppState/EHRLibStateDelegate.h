//
// Created by Yves Le Borgne on 2023-03-02.
//

#import <Foundation/Foundation.h>

@class UserModel;

@protocol EHRLibStateDelegate <NSObject>

-(void) onDeviceInitialized;
-(void) onAppInfoUpdate;
-(void) onUserInfoUpdate;
-(void) onNotificationsModelUpdate;
-(void) onConsentsUpdate;


@end