//
// Created by Yves Le Borgne on 2023-03-28.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "IBAppInfo.h"
#import "IBUser.h"
#import "IBDeviceInfo.h"
#import "SecureCredentials.h"
#import "IBConsent.h"
#import "NotificationsModel.h"
#import "EHRLibStateDelegate.h"

@interface EHRState : NSObject <EHRInstanceCounterP> {

}
@property(nonatomic) IBAppInfo                      *app;
@property(nonatomic) IBDeviceInfo                   *device;
@property(nonatomic) IBUser                         *user;
@property(nonatomic) SecureCredentials              *secureCredentials;
@property(nonatomic, weak) id <EHRLibStateDelegate> delegate;
- (void)setDelegate:(id <EHRLibStateDelegate>)delegate;

@end