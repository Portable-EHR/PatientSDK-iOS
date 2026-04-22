//
// Created by Yves Le Borgne on 2015-11-16.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "EHRInstanceCounterP.h"

@class UserModel;
@class AppState;
@class IBUser;
@class IBMessageContent;
@class IBMessageDistribution;
@class IBService;

typedef NS_ENUM(NSInteger, ServicesFilterType) {
    SubscribedServices  = 1,
    AllServices         = 2,
    RequireEulaServices = 3,
    AvailableServices   = 4
};

@interface ServicesModelFilter : NSObject <EHRInstanceCounterP, EHRPersistableP> {

    NSUInteger         _cursorIndex;
    NSInteger          _instanceNumber;
    BOOL               _showAllServices,
                       _showAvailableServices,
                       _showSubscribedServices,
                       _showRequireEulaServices;
    ServicesFilterType _filterType;
    NSMutableArray     *_sortedKeys;
    NSMutableArray *_patientSelector;
//    UserModel              *_userModel;
//    IBUser                   *_user;

}

@property(nonatomic) BOOL                showAllServices;
@property(nonatomic) BOOL                showSubscribedServices;
@property(nonatomic) BOOL                showRequireEulaServices;
@property(nonatomic) BOOL                showAvailableServices;
@property(nonatomic) ServicesFilterType  filterType;
@property(nonatomic, readonly) NSArray   *sortedKeys;
@property(nonatomic, readonly) IBService *cursor;
@property(nonatomic, readonly) IBService *next;
@property(nonatomic, readonly) IBService *previous;
@property(nonatomic, readonly) NSInteger numberOfUnseen;

- (BOOL)isAtTop;
- (BOOL)isAtBottom;
- (void)setCursorAtTop;
- (void)setCursorAtBottom;
- (void)setCursorAtService:(IBService *)service;
- (void)moveToPrevious;
- (void)moveToNext;
- (BOOL)isEmpty;

+ (ServicesModelFilter *)subscribedServicesFilter;
+ (ServicesModelFilter *)allServicesFilter;
+ (ServicesModelFilter *)requireEulaServicesFilter;
+ (ServicesModelFilter *)availableServicesFilter;

- (void)refreshFilter;
- (void)resetFilter;

@end
