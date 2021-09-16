//
// Created by Yves Le Borgne on 2015-11-16.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "ServicesModelFilter.h"
#import "AppState.h"
#import "UserModel.h"
#import "IBUser.h"
#import "Patient.h"
#import "IBService.h"
#import "ServicesModel.h"
#import "IBUserService.h"

@implementation ServicesModelFilter

@synthesize showSubscribedServices = _showSubscribedServices;
@synthesize showAllServices = _showAllServices;
@synthesize showRequireEulaServices = _showRequireEulaServices;
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
        _filterType              = AllServices;
        _showSubscribedServices  = YES;
        _showAllServices         = YES;
        _showRequireEulaServices = YES;
        _sortedKeys              = [NSMutableArray array];
        _patientSelector         = [NSMutableArray array];
        _cursorIndex             = 0;
        _appState                = [AppState sharedAppState];

        [[NSNotificationCenter defaultCenter]
                addObserver:self selector:@selector(refreshFilter)
                       name:kNotificationsModelRefreshNotification
                     object:nil
        ];

    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNotificationsModelRefreshNotification
                                                  object:nil
    ];

    _sortedKeys = nil;
}

#pragma mark - static configurations

+ (ServicesModelFilter *)subscribedServicesFilter __unused {
    ServicesModelFilter *nf = [[ServicesModelFilter alloc] init];
    [nf setFilterType:SubscribedServices];
    [nf resetPatientSelector];
    return nf;
}

+ (ServicesModelFilter *)allServicesFilter {
    ServicesModelFilter *nf = [[ServicesModelFilter alloc] init];
    [nf setFilterType:AllServices];
    [nf resetPatientSelector];
    return nf;
}

+ (ServicesModelFilter *)requireEulaServicesFilter {
    ServicesModelFilter *nf = [[ServicesModelFilter alloc] init];
    [nf setFilterType:RequireEulaServices];
    [nf resetPatientSelector];
    return nf;
}

+ (ServicesModelFilter *)availableServicesFilter {
    ServicesModelFilter *nf = [[ServicesModelFilter alloc] init];
    [nf setFilterType:AvailableServices];
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
        IBService *service = [[AppState sharedAppState].servicesModel.allServices objectForKey:key];
        if (service && !service.wasSeen) _number++;
    }
    return _number;
}

#pragma mark - setters

- (void)setFilterType:(ServicesFilterType)filterType __unused {
    BOOL change = (filterType != _filterType);
    _filterType = filterType;
    switch (filterType) {
        case AvailableServices:

            _showAllServices         = NO;
            _showRequireEulaServices = NO;
            _showAvailableServices   = YES;
            _showSubscribedServices  = NO;
            break;
        case SubscribedServices:

            _showAvailableServices   = NO;
            _showSubscribedServices  = YES;
            _showAllServices         = NO;
            _showRequireEulaServices = NO;
            break;

        case RequireEulaServices:

            _showAvailableServices   = NO;
            _showSubscribedServices  = NO;
            _showAllServices         = NO;
            _showRequireEulaServices = YES;
            break;

        case AllServices:
        default:

            _showAvailableServices   = NO;
            _showSubscribedServices  = NO;
            _showAllServices         = YES;
            _showRequireEulaServices = NO;

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

    IBService *oldCursor = self.cursor;

    _cursorIndex = 0;
    [_sortedKeys removeAllObjects];

    if ([AppState sharedAppState].servicesModel.allServices.count == 0) {
        return;
    }

    [self resetPatientSelector];

//    NSMutableArray *ar = [NSMutableArray array];
//    for (IBService *service in [[AppState sharedAppState].servicesModel.availableServices allValues]) {
//        BOOL keeper = YES;
//
//        // retain only the services for the patients of interest
//
//        if (self.showSubscribedServices) {
//            keeper = NO;
//            if (!_appState.userModel.isGuest) {
//                keeper = YES;
//            }
//        }
//
//        if (keeper && self.showRequireEulaServices) {
//            IBUser               *user = _appState.userModel.user;
//            for (IBUserService *userService in user.userServiceModel) {
//                if ([userService.serviceGuid isEqualToString:service.guid]) {
//                    if (![userService.state isEqualToString:@"pendingEula"]) {
//                        keeper = NO;
//                        break;
//                    }
//                }
//            }
//        }
//
//        if (keeper) {
//            TRACE(@"%lu : keeping service with creationOrder %@", (unsigned long) self.filterType, service.creationOrder);
//            [ar addObject:service];
//        }
//    }
    NSMutableArray *ar = [self matchingServices];

    if (ar.count == 0) {
        // no keepers whatsoever, get the fuck outa here
        return;
    }

    [ar sortUsingComparator:^NSComparisonResult(IBService *obj1, IBService *obj2) {
        return [obj1.creationOrder compare:obj2.creationOrder]; // from first to last created service (cuz dependancies)
    }];

    for (IBService *not in ar) {
        [_sortedKeys addObject:not.creationOrder];
    }

    if (oldCursor) {
        if ([ar containsObject:oldCursor]) {

            // lets locate the new (possibly) index of our cursor

            for (NSUInteger scan = 0; scan < ar.count; scan++) {
                NSString *key = [_sortedKeys objectAtIndex:scan];
                if ([key isEqualToString:oldCursor.creationOrder]) {
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

- (NSMutableArray *)matchingServices {
    NSMutableArray *keepers = [NSMutableArray arrayWithArray:[[AppState sharedAppState].servicesModel.allServices allValues]] ;
    if (_showAllServices) return keepers;
    if (_showAvailableServices) {
        return [self availableOnly:keepers];
    }
    if (_showSubscribedServices) {
        return [self subscribedOnly:keepers];
    }
    if (_showRequireEulaServices) {
        return [self requireEulaOnly:keepers];
    }
    return keepers;
}

- (NSMutableArray *)availableOnly:(NSArray *)in {
    NSMutableArray *keepers = [NSMutableArray array];
    for (IBService *service in in) {
        if (![_appState.userModel.user hasService:service]) {
            [keepers addObject:service];
        }
    }
    return keepers;
}

- (NSMutableArray *)subscribedOnly:(NSArray *)in {
    NSMutableArray *keepers = [NSMutableArray array];
    for (IBService *service in in) {
        if ([_appState.userModel.user hasService:service]) {
            [keepers addObject:service];
        }
    }
    return keepers;
}

- (NSMutableArray *)requireEulaOnly:(NSArray *)in {
    NSMutableArray *keepers = [NSMutableArray array];
    NSArray        *subs    = [self subscribedOnly:in];
    for (IBService *service in subs) {
        IBUserService *userService = [_appState.userModel.user userServiceOfService:service];
        if (userService && !userService.isEulaAccepted) {
            [keepers addObject:service];
        }
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

- (void)setCursorAtService:(IBService *)service {
    if (!service) return;
    if (_sortedKeys.count > 0) {
        if ([_sortedKeys containsObject:service.creationOrder]) {
            _cursorIndex = [_sortedKeys indexOfObject:service.creationOrder];
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

- (IBService *)cursor __unused {
    if (_sortedKeys.count == 0) return nil;

    if (_cursorIndex == 0) return [self serviceAtIndex:0];

    if (_cursorIndex <= _sortedKeys.count - 1) {
        return [self serviceAtIndex:_cursorIndex];
    } else {
        return nil;
    }
}

- (IBService *)next __unused {
    if (_sortedKeys.count == 0) return nil;                 // no next, empty set
    if (_cursorIndex == _sortedKeys.count - 1) return nil;  // no next, we are on last
    return [self serviceAtIndex:(_cursorIndex + 1)];
}

- (IBService *)previous __unused {
    if (_sortedKeys.count == 0) return nil;
    if (_cursorIndex >= 1) return [self serviceAtIndex:(_cursorIndex - 1)];
    return nil;
}

- (IBService *)serviceAtIndex:(NSUInteger)index {
    NSDictionary *allNotifications = [AppState sharedAppState].servicesModel.allServices;

    if (index >= _sortedKeys.count) {
        MPLOG(@"*** cursorIndex not in sync with notifications model!");
        return nil;
    }

    NSString  *key    = [_sortedKeys objectAtIndex:index];
    IBService *_notif = [allNotifications objectForKey:key];
    if (_notif) {
        return _notif;
    } else {
        MPLOG(@"*** sortedKeys holds key[%@] for a notification not present in  notifications model!",key);
        return nil;
    }

}

- (void)resetPatientSelector {
    [_patientSelector removeAllObjects];
    IBUser *_user = [AppState sharedAppState].userModel.user;
    switch (_filterType) {
        case AllServices:
            for (Patient *patient in [_user.patients allValues]) {
                [_patientSelector addObject:patient.guid];
            }
            break;
        case SubscribedServices:

            if (_user.patient) [_patientSelector addObject:_user.patient.guid];
            for (Patient *patient in [_user.patients allValues]) {
                [_patientSelector addObject:patient.guid];
            }
            for (Patient *patient in [_user.proxies allValues]) {
                [_patientSelector addObject:patient.guid];
            }
            break;
        default:break;
    }
}

#pragma mark - persistence

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    ServicesModelFilter *pa = [[self alloc] init];
    pa->_showSubscribedServices = WantBoolFromDic(dic, @"showSubscribedServices");
    pa->_showAllServices        = WantBoolFromDic(dic, @"showAllEulas");
    pa->_filterType             = (ServicesFilterType) WantIntegerFromDic(dic, @"filterType");
    return pa;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutBoolInDic(self.showAllServices, dic, @"showAllEulas");
    PutBoolInDic(self.showSubscribedServices, dic, @"showSubscribedServices");
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