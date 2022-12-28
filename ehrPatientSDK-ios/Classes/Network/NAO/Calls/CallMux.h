//
// Created by Yves Le Borgne on 2022-12-28.
//

#import <Foundation/Foundation.h>
#import "GERuntimeConstants.h"
#import "EHRInstanceCounterP.h"

#import "AppCallMux.h"

@class AppCallMux;

@interface CallMux : NSObject <EHRInstanceCounterP> {
    NSInteger _instanceNumber;
}

@property(nonatomic) AppCallMux *app;

@end