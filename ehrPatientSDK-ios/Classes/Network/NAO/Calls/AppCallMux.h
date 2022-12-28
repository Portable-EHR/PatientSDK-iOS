//
// Created by Yves Le Borgne on 2022-12-28.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRCall.h"

@interface AppCallMux : NSObject < EHRPersistableP, EHRInstanceCounterP> {
    NSInteger _instanceNumber;
}


-(EHRCall *) __unused getAppInfoCall;


@end
