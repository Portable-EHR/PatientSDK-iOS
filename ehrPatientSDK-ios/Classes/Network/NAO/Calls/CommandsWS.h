//
// Created by Yves Le Borgne on 2022-12-28.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "IBDeviceInfo.h"
#import "IBAppInfo.h"
#import "AppState.h"
#import "EHRCall.h"


@interface CommandsWS : NSObject <EHRInstanceCounterP> {
    NSInteger _instanceNumber;
}

- (EHRCall *)getAppInfoCallWithSuccessBlock:(SenderBlock)success
                                    onError:(SenderBlock)error
__attribute__((unused));

- (EHRCall *)getPingServerCallWithSuccessBlock:(SenderBlock)success
                                       onError:(SenderBlock)error
__attribute__((unused));

- (EHRCall *)getGetUserInfoCall:(SenderBlock)success
                        onError:(SenderBlock)error
__attribute__((unused));


//region WF notation

-(void) getAppInfo:(VoidBlock)successBlock onError:(VoidBlock) errorBlock;
-(void) getUserInfo:(VoidBlock) successBlock onError:(VoidBlock) errorBlock;
-(void) pullUserData:(VoidBlock) successBlock onError:(VoidBlock) errorBlock;


@end
