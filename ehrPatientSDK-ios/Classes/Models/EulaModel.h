//
// Created by Yves Le Borgne on 2017-10-06.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

@class AppState;
@class EulaModelFilter;
@class IBUserEula;

@interface EulaModel : NSObject <EHRInstanceCounterP, EHRPersistableP> {
    NSInteger           _instanceNumber;
    NSDate              *_lastUpdated;
    NSDate              *_lastRefreshed;
    NSDate              *_lastSeen;
    NSMutableDictionary *_allUserEulas;
    EulaModelFilter     *_allEulasFilter;
    EulaModelFilter     *_consentedEulasFilter;
    EulaModelFilter *_pendingEulasFilter;
    AppState        *_appState;
    VoidBlock       _refreshSuccessBlock,
                    _refreshFailedBlock;
    BOOL                _isRefreshing;

}

@property(nonatomic) NSDate                    *lastUpdated;
@property(nonatomic) NSDate                    *lastRefreshed;
@property(nonatomic) NSDate                    *lastSeen;
@property(nonatomic, readonly) NSDictionary    *allUserEulas;
@property(nonatomic) EulaModelFilter           *consentedEulasFilter;
@property(nonatomic) EulaModelFilter           *pendingEulasFilter;
@property(nonatomic) EulaModelFilter           *allEulasFilter;
@property(nonatomic, readonly) BOOL            hasPendingEulas;
@property(nonatomic, readonly) NSInteger       numberOfPendingEulas;
@property(nonatomic, readonly) BOOL            requiresAction;

- (BOOL)__unused containsEula:(IBUserEula *)userEula;
- (BOOL)saveOnDevice;
- (BOOL)eraseFromDevice:(BOOL)cascade;
+ (EulaModel *)readFromDevice;
- (void)reloadFromDevice;

- (IBUserEula *)userEulaWithGuid:(NSString *)guid;

- (void)refreshFilters;
- (void)refreshFromServer;
- (void)refreshFromServerWithSuccess:(VoidBlock)successBlock andError:(VoidBlock)errorBlock;


// display support props

@property(nonatomic, readonly) NSInteger numberOfUnseen;


- (void)populateWithServices:(NSArray *)services;
- (void)resetFilters;

@end
