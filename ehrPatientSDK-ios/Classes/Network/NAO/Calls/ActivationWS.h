//
// Created by Yves Le Borgne on 2023-01-31.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRLibRuntimeGlobals.h"

@interface ActivationWS : NSObject <EHRInstanceCounterP> {
}


-(void) setFirebaseDeviceToken:(NSString *)token onSuccess:(VoidBlock)successBlock onError:(VoidBlock)errorBlock;


@end