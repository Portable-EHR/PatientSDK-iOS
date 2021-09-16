//
// Created by Yves Le Borgne on 2017-10-06.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"

@class IBEula;
@class AppState;
@class IBUserEula;

typedef NS_ENUM(NSInteger, EulaFilterType) {
    All            = 1,
    Consented      = 2,
    PendingConsent = 3

};

@interface EulaModelFilter : NSObject <EHRInstanceCounterP, EHRPersistableP> {

    NSUInteger     _cursorIndex;
    NSInteger      _instanceNumber;
    BOOL           _showConsentedEulas,
                   _showPendingEulas;
    EulaFilterType _filterType;
    NSMutableArray *_sortedKeys;
    NSMutableArray *_patientSelector;
//    UserModel              *_userModel;
//    IBUser                   *_user;
    AppState       *_appState;

}

@property(nonatomic) BOOL                 showConsentedEulas;
@property(nonatomic) BOOL                 showPendingEulas;
@property(nonatomic) EulaFilterType       filterType;
@property(nonatomic, readonly) NSArray    *sortedKeys;
@property(nonatomic, readonly) IBUserEula *cursor;
@property(nonatomic, readonly) IBUserEula *next;
@property(nonatomic, readonly) IBUserEula *previous;
@property(nonatomic, readonly) NSInteger  numberOfUnseen;

- (BOOL)isAtTop;
- (BOOL)isAtBottom;
- (void)setCursorAtTop;
- (void)setCursorAtBottom;
- (void)setCursorAtUserEula:(IBUserEula *)userEula;
- (void)moveToPrevious;
- (void)moveToNext;
- (BOOL)isEmpty;

+ (EulaModelFilter *)consentedEulasFilter;
+ (EulaModelFilter *)allEulasFilter;
+ (EulaModelFilter *)pendingEulasFilter;

- (void)refreshFilter;
- (void)resetFilter;

@end