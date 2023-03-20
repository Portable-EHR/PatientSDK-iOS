//
// Created by Yves Le Borgne on 2023-01-30.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "IBDeviceInfo.h"
#import "IBAppInfo.h"
#import "IBUser.h"
#import "SecureCredentials.h"

@interface EHRLibState : NSObject <EHRInstanceCounterP> {

}

@property(nonatomic) IBAppInfo         *app;
@property(nonatomic) IBDeviceInfo      *device;
@property(nonatomic) IBUser            *user;
@property(nonatomic) SecureCredentials *secureCredentials;

-(void) resumeWithCurrentUser;
@end