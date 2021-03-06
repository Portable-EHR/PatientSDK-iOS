//
// Created by Yves Le Borgne on 2017-07-31.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"

@class UserCredentials;
@class UICKeyChainStore;

@interface SecureCredentials : NSObject <EHRInstanceCounterP, EHRPersistableP> {
    NSInteger        _instanceNumber;
    UICKeyChainStore *_keyChain;
    NSString         *_domain;
    NSString         *_credentialsKey;
}

+ (SecureCredentials *)sharedCredentials;

@property(nonatomic, readonly) UserCredentials *current;

- (void)setCurrentUserCredentials:(UserCredentials *)current;

- (void)reload;
- (void)persist;
- (void)setupGuest;
- (void)setupServer;

@end