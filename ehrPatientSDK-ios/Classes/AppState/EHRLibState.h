//
// Created by Yves Le Borgne on 2023-01-30.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"

@class IBAppInfo;
@class IBDeviceInfo;
@class IBUser;

@interface EHRLibState : NSObject <EHRInstanceCounterP> {

}


@property(nonatomic) IBAppInfo    *app;
@property(nonatomic) IBDeviceInfo *device;
@property(nonatomic) IBUser       *user;

@end