//
// Created by Yves Le Borgne on 2017-03-17.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"

@class ServicesModelFilter;
@class AppState;
@class IBService;

@interface ServicesModel : NSObject <EHRInstanceCounterP, EHRPersistableP> {
    NSInteger _instanceNumber;

    NSDate              *_lastUpdated;
    NSDate              *_lastRefreshed;
    NSDate              *_lastSeen;
    NSMutableDictionary *_allServices;
    ServicesModelFilter *_allServicesFilter;
    ServicesModelFilter *_subscribedServicesFilter;
    ServicesModelFilter *_availableServicesFilter;
    AppState            *_appState;
    VoidBlock           _refreshSuccessBlock,
                        _refreshFailedBlock;
    BOOL                _isRefreshing;

}

@property(nonatomic) NSDate                        *lastUpdated;
@property(nonatomic) NSDate                        *lastRefreshed;
@property(nonatomic) NSDate                        *lastSeen;
@property(nonatomic, readonly) NSDictionary        *allServices;
@property(nonatomic, readonly) ServicesModelFilter *allServicesFilter;
@property(nonatomic) ServicesModelFilter           *subscribedServicesFilter;
@property(nonatomic) ServicesModelFilter           *availableServicesFilter;
@property(nonatomic, readonly) BOOL                hasUnseenChanges;
@property(nonatomic, readonly) NSInteger           numberOfUnseenChanges;
@property(nonatomic, readonly) NSInteger           numberOfUnAckedServices;
@property(nonatomic, readonly) BOOL                requiresAction;

- (BOOL) __unused containsService:(IBService *)service;
- (BOOL)saveOnDevice;
- (BOOL)eraseFromDevice:(BOOL)cascade;
+ (ServicesModel *)readFromDevice;
- (void)reloadFromDevice;

- (IBService *)serviceWithGuid:(NSString *)guid;

- (void)refreshFilters;
- (void)refreshFromServer;
- (void)refreshFromServerWithSuccess:(VoidBlock)successBlock andError:(VoidBlock)errorBlock;

//- (void)readFromServer;
//- (void)readFromServerWithSuccess:(VoidBlock)successBlock andError:(VoidBlock)errorBlock;

// display support props

@property(nonatomic, readonly) NSInteger numberOfUnseen;

- (void)setSubscribedServicesFilter:(ServicesModelFilter *)subscribedFilter;

- (void)populateWithServices:(NSArray *)services;
- (void)resetFilters;

@end
