//
// Created by Yves Le Borgne on 2017-07-31.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "EHRInstanceCounterP.h"
#import "EHRApiServer.h"

@class IBUserEula;

@interface UserCredentials : NSObject <EHRPersistableP, EHRInstanceCounterP> {

    NSInteger _instanceNumber;

}
@property(nonatomic) EHRApiServer *server;
@property(nonatomic) NSString     *deviceGuid;
@property(nonatomic) NSString     *userGuid;
@property(nonatomic) NSString     *userApiKey;
@property(nonatomic) IBUserEula   *appEula;
@property(nonatomic) BOOL         hasConsentedEula;


-(BOOL) isGuest;

@end