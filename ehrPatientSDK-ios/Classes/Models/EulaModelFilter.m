//
// Created by Yves Le Borgne on 2017-10-06.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "EHRPersistableP.h"
#import "EulaModelFilter.h"
#import "AppState.h"
#import "IBUserEula.h"
#import "EulaModel.h"
#import "UserModel.h"
#import "Patient.h"
#import "IBUser.h"

@implementation EulaModelFilter

@synthesize showConsentedEulas = _showConsentedEulas;
@synthesize showPendingEulas = _showPendingEulas;
@synthesize filterType = _filterType;
@dynamic sortedKeys;
@dynamic cursor;
@dynamic next;
@dynamic previous;
@dynamic numberOfUnseen;

TRACE_OFF

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();

        _sortedKeys      = [NSMutableArray array];
        _patientSelector = [NSMutableArray array];
        _cursorIndex     = 0;
        _appState        = [AppState sharedAppState];

        [[NSNotificationCenter defaultCenter]
                addObserver:self selector:@selector(refreshFilter)
                       name:kEulaModelRefreshNotification
                     object:nil
        ];

        [self setFilterType:All];
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kEulaModelRefreshNotification
                                                  object:nil
    ];

    _sortedKeys = nil;
}

#pragma mark - static configurations

+ (EulaModelFilter *)consentedEulasFilter __unused {
    EulaModelFilter *nf = [[EulaModelFilter alloc] init];
    [nf setFilterType:Consented];
    [nf resetPatientSelector];
    return nf;
}

+ (EulaModelFilter *)allEulasFilter __unused {
    EulaModelFilter *nf = [[EulaModelFilter alloc] init];
    [nf setFilterType:All];
    [nf resetPatientSelector];
    return nf;
}

+ (EulaModelFilter *)pendingEulasFilter __unused {
    EulaModelFilter *nf = [[EulaModelFilter alloc] init];
    [nf setFilterType:PendingConsent];
    [nf resetPatientSelector];
    return nf;
}

#pragma mark getters

- (NSArray *)sortedKeys __unused {
    return _sortedKeys;
}

- (NSInteger)numberOfUnseen __unused {
    NSInteger     _number = 0;
    for (NSString *key in _sortedKeys) {
        IBUserEula *service = [[AppState sharedAppState].eulaModel.allUserEulas objectForKey:key];
        if (service && !service.wasSeen) _number++;
    }
    return _number;
}

#pragma mark - setters

- (void)setFilterType:(EulaFilterType)filterType __unused {
    BOOL change = (filterType != _filterType);
    _filterType = filterType;
    switch (filterType) {

        case Consented:

            _showPendingEulas   = NO;
            _showConsentedEulas = YES;
            break;

        case PendingConsent:

            _showPendingEulas   = YES;
            _showConsentedEulas = NO;
            break;

        case All:
        default:

            _showPendingEulas   = YES;
            _showConsentedEulas = YES;
            break;
    }
    if (change) {
        [self refreshFilter];
    }
}

#pragma mark - private stuff, filter management

- (void)resetFilter {
    [_sortedKeys removeAllObjects];
    _cursorIndex = 0;
    [self resetPatientSelector];
}

- (void)refreshFilter {

    IBUserEula *oldCursor = self.cursor;

    _cursorIndex = 0;
    [_sortedKeys removeAllObjects];

    if ([AppState sharedAppState].eulaModel.allUserEulas.count == 0) {
        return;
    }

    [self resetPatientSelector];

    NSMutableArray *ar = [self matchingUserEUlas];

    if (ar.count == 0) {
        // no keepers whatsoever, get the fuck outa here
        return;
    }

    for (IBUserEula *not in ar) {
        [_sortedKeys addObject:not.eulaGuid];
    }

    if (oldCursor) {
        if ([ar containsObject:oldCursor]) {

            // lets locate the new (possibly) index of our cursor

            for (NSUInteger scan = 0; scan < ar.count; scan++) {
                NSString *key = [_sortedKeys objectAtIndex:scan];
                if ([key isEqualToString:oldCursor.eulaGuid]) {
                    _cursorIndex = scan;
                    return;
                }
            }
            // !! eeeek , should never get here
            MPLOG(@"*** Old cursor not found in sorted keys , reseting to top");
            _cursorIndex = 0;

        } else {
            // the refreshe flushed our old cursor , lets move to top
            _cursorIndex = 0;
        }
    } else {
        // did not hava a cursor before, lest move to top
        _cursorIndex = 0;
    }

}

- (NSMutableArray *)matchingUserEUlas {
    NSMutableArray *keepers = [NSMutableArray arrayWithArray:[[AppState sharedAppState].eulaModel.allUserEulas allValues]];
    if (_showConsentedEulas && _showPendingEulas) return keepers;
    if (_showConsentedEulas) return [self consentedOnly:keepers];
    if (_showPendingEulas) return [self pendingOnly:keepers];
    return keepers;
}

- (NSMutableArray *)consentedOnly:(NSArray *)in {
    NSMutableArray *keepers = [NSMutableArray array];
    for (IBUserEula *userEula in in) {
        if ([userEula wasConsented]) [keepers addObject:userEula];
    }
    return keepers;
}

- (NSMutableArray *)pendingOnly:(NSArray *)in {
    NSMutableArray *keepers = [NSMutableArray array];
    for (IBUserEula *userEula in in) {
        if (![userEula wasConsented]) [keepers addObject:userEula];
    }
    return keepers;
}


- (BOOL)isAtBottom __unused {
    if (_sortedKeys.count > 0) {
        return _cursorIndex == (_sortedKeys.count - 1);
    }
    return true;
}

- (BOOL)isAtTop __unused {
    if (_sortedKeys.count > 0) {
        return _cursorIndex == 0;
    }
    return true;
}

- (BOOL)isEmpty __unused {
    return (_sortedKeys.count == 0);
}

- (void)setCursorAtTop __unused {

    _cursorIndex = 0;
}

- (void)setCursorAtBottom __unused {
    if (_sortedKeys.count > 0) {
        _cursorIndex = _sortedKeys.count - 1;
    } else {
        _cursorIndex = 0;
    }
}

- (void)setCursorAtUserEula:(IBUserEula *)userEula __unused {
    if (!userEula) return;
    if (_sortedKeys.count > 0) {
        if ([_sortedKeys containsObject:userEula.eulaGuid]) {
            _cursorIndex = [_sortedKeys indexOfObject:userEula.eulaGuid];
        } else {
            // at top
            _cursorIndex = 0;
        }
    } else {
        _cursorIndex = 0;
    }
}

- (void)moveToNext __unused {
    if (_sortedKeys.count == 0) return;
    if (_cursorIndex < (_sortedKeys.count - 1)) _cursorIndex++;
}

- (void)moveToPrevious __unused {
    if (_sortedKeys.count == 0) return;
    if (_cursorIndex > 0) {
        _cursorIndex--;
    }
}

- (IBUserEula *)cursor __unused {
    if (_sortedKeys.count == 0) return nil;

    if (_cursorIndex == 0) return [self userEulaAtIndex:0];

    if (_cursorIndex <= _sortedKeys.count - 1) {
        return [self userEulaAtIndex:_cursorIndex];
    } else {
        return nil;
    }
}

- (IBUserEula *)next __unused {
    if (_sortedKeys.count == 0) return nil;                 // no next, empty set
    if (_cursorIndex == _sortedKeys.count - 1) return nil;  // no next, we are on last
    return [self userEulaAtIndex:(_cursorIndex + 1)];
}

- (IBUserEula *)previous __unused {
    if (_sortedKeys.count == 0) return nil;
    if (_cursorIndex >= 1) return [self userEulaAtIndex:(_cursorIndex - 1)];
    return nil;
}

- (IBUserEula *)userEulaAtIndex:(NSUInteger)index {
    NSDictionary *allUserEulas = [AppState sharedAppState].eulaModel.allUserEulas;

    if (index >= _sortedKeys.count) {
        MPLOG(@"*** cursorIndex not in sync with notifications model!");
        return nil;
    }

    NSString  *key    = [_sortedKeys objectAtIndex:index];
    IBUserEula *_notif = [allUserEulas objectForKey:key];
    if (_notif) {
        return _notif;
    } else {
        MPLOG(@"*** sortedKeys holds key for a euserEula not present in  eula model!");
        return nil;
    }

}

- (void)resetPatientSelector {
    [_patientSelector removeAllObjects];
    IBUser *_user = [AppState sharedAppState].userModel.user;

    switch (_filterType) {
        case All:
            for (Patient *patient in [_user.patients allValues]) {
                [_patientSelector addObject:patient.guid];
            }
            break;
        case Consented:

            if (_user.patient) [_patientSelector addObject:_user.patient.guid];
            for (Patient *patient in [_user.patients allValues]) {
                [_patientSelector addObject:patient.guid];
            }
            for (Patient *patient in [_user.proxies allValues]) {
                [_patientSelector addObject:patient.guid];
            }
            break;

        case PendingConsent:

            break;
        default:

            break;
    }
}

#pragma mark - persistence

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    EulaModelFilter *pa = [[self alloc] init];
    pa->_showPendingEulas = WantBoolFromDic(dic, @"showPendingEulas");
    pa->_showConsentedEulas        = WantBoolFromDic(dic, @"showConsentedEulas");
    pa->_filterType             = (EulaFilterType) WantIntegerFromDic(dic, @"filterType");
    return pa;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutBoolInDic(self.showConsentedEulas, dic, @"showConsentedEulas");
    PutBoolInDic(self.showPendingEulas, dic, @"showPendingEulas");
    PutIntegerInDic(self.filterType, dic, @"filterType");
    return dic;
}

- (NSString *)asJSON {
    return [[self asDictionary] asJSON];
}

- (NSData *)asJSONdata {
    return [[self asDictionary] asJSONdata];
}

+ (instancetype)objectWithJSONdata:(NSData *)jsonData {
    NSDictionary *dic = [NSDictionary dictionaryWithJSONdata:jsonData];
    return [self objectWithContentsOfDictionary:dic];
}

+ (instancetype)objectWithJSON:(NSString *)jsonString {
    NSDictionary *dic = [NSDictionary dictionaryWithJSON:jsonString];
    return [self objectWithContentsOfDictionary:dic];
}

@end