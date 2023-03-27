//
// Created by Yves Le Borgne on 2023-01-27.
//



#import <Foundation/Foundation.h>

typedef void(^VoidBlock)(void);
typedef void(^SenderBlock)(id call);
__unused typedef void(^NSErrorBlock)(NSError *);


@class PehrSDKConfig;
extern PehrSDKConfig* EHRLib;

@interface EHRLibRuntime : NSObject {

}

@end
