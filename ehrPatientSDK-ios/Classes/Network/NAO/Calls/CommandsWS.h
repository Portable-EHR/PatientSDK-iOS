//
// Created by Yves Le Borgne on 2022-12-28.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRCall.h"

@interface CommandsWS : NSObject <EHRInstanceCounterP> {
    NSInteger _instanceNumber;
}

- (EHRCall *)getAppInfoCallWithSuccessBlock:(SenderBlock) success
                                    onError:(SenderBlock) error
__attribute__((unused));

- (EHRCall *)getPingServerCallWithSuccessBlock:(SenderBlock) success
                                       onError:(SenderBlock) error
__attribute__((unused));

- (EHRCall *)getGetUserInfoCall:(SenderBlock)success
                     onError:(SenderBlock)error
__attribute__((unused));

@end
