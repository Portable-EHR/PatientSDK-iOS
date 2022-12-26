//
// Created by Yves Le Borgne on 2017-03-17.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "ServicesModel.h"
#import "ServicesModelFilter.h"
#import "GEFileUtil.h"
#import "AppState.h"
#import "UserModel.h"
#import "UserDeviceSettings.h"
#import "IBService.h"
#import "IBUserService.h"
#import "IBVersion.h"
//#import "EHRCall.h"
//#import "EHRServerResponse.h"
//#import "EHRRequestStatus.h"
//#import "EHRServerRequest.h"
//#import "SecureCredentials.h"
//#import "UserCredentials.h"
#import "IBUser.h"

@implementation ServicesModel

@synthesize subscribedServicesFilter = _subscribedServicesFilter;
@synthesize availableServicesFilter = _availableServicesFilter;

@dynamic hasUnseenChanges, numberOfUnseenChanges, numberOfUnAckedServices, requiresAction;

TRACE_OFF

static NSString *_servicesFileFQN;
static AppState *_appState;

+ (void)initialize {
    _servicesFileFQN = [[GEFileUtil sharedFileUtil] getServicesFQN];
}

- (id)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();

        _allServicesFilter        = [ServicesModelFilter allServicesFilter];
        _subscribedServicesFilter = [ServicesModelFilter subscribedServicesFilter];
        _availableServicesFilter  = [ServicesModelFilter availableServicesFilter];

        _allServices   = [NSMutableDictionary dictionary];
        _appState      = [AppState sharedAppState];
        _lastRefreshed = [NSDate dateWithTimeIntervalSince1970:0];
        _lastUpdated   = [NSDate dateWithTimeIntervalSince1970:0];
        _lastSeen      = [NSDate dateWithTimeIntervalSince1970:0];
    } else {
        MPLOGERROR(@"*** Yelp ! super returned nil!");
    }
    return self;

}

- (void)refreshFilters {
    [_allServicesFilter refreshFilter];
    [_subscribedServicesFilter refreshFilter];
    [_availableServicesFilter refreshFilter];
}

- (void)resetFilters {
    [_allServicesFilter resetFilter];
    [_subscribedServicesFilter resetFilter];
    [_availableServicesFilter resetFilter];
}

- (void)populateWithServices:(NSArray *)services {

//    MPLOG(@"*** CRUFT *** : ignored, this service model is on its way out !");

    [self resetFilters];
    for (NSDictionary *serviceAsDic in services) {
        IBService *oldService = nil;
        IBService *service    = [IBService objectWithContentsOfDictionary:serviceAsDic];
        BOOL      wasSeen     = false;
        if ((oldService = _allServices[service.creationOrder])) {
            if ([oldService.version.description isEqualToString:service.version.description]) {
                wasSeen = oldService.wasSeen;
            }
            service.wasSeen = wasSeen;
            _allServices[service.creationOrder] = service; // replace
        } else {
            // new service is added here
            _allServices[service.creationOrder] = service; // add
        }
    }

    [self resetFilters];
    [self refreshFilters];
    self.lastRefreshed = [NSDate date];
    // compute last updated

    NSDate *lastUpdated = self.lastUpdated;
    if (!lastUpdated) lastUpdated = [NSDate dateWithTimeIntervalSince1970:0];
    for (IBService *service in [_allServices allValues]) {
        if ([service.lastUpdated compare:lastUpdated] > 0) {
            lastUpdated = service.lastUpdated;
        }
    }
    self.lastUpdated = lastUpdated;
    [self saveOnDevice];
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

//**************************************************************************************//
//  helpers, dynamic properties                                                         //
//**************************************************************************************//

- (BOOL)requiresAction {
    return ([self numberOfUnAckedServices] > 0);
}

- (NSInteger)numberOfUnAckedServices {
    IBUser             *user   = _appState.userModel.user;
    NSInteger          unAcked = 0;
    for (IBUserService *strawman in user.userServiceModel) {
        if ([strawman.state isEqualToString:@"pendingEula"]) {
            unAcked++;
        }
    }
    return unAcked;
}

- (BOOL)hasUnseenChanges __unused {
    return [self numberOfUnseenChanges] > 0;
}

- (NSInteger)numberOfUnseenChanges {
    NSInteger      number = 0;
    for (IBService *service in [_allServices allValues]) {
        if (!service.wasSeen) number++;
    }
    return number;
}

- (BOOL)containsService:(IBService *)service {
    for (IBService *strawman in [_allServices allValues]) {
        if ([strawman.guid isEqualToString:service.guid]) return YES;
    }
    return NO;
}

//**************************************************************************************//
//  helpers, business methods                                                           //
//**************************************************************************************//


/**
 *
 * @param guid
 * @return IBserive|nil
 */
- (IBService *)serviceWithGuid:(NSString *)guid __unused {
    for (IBService *strawman in [_allServices allValues]) {
        if ([strawman.guid isEqualToString:guid]) return strawman;
    }
    return nil;
}

//**************************************************************************************//
//  EHRPersistableP                                                                     //
//**************************************************************************************//


- (void)refreshFromServerWithSuccess:(VoidBlock)successBlock andError:(VoidBlock)errorBlock  __unused {

    TRACE_KILLROY

    _refreshSuccessBlock = [successBlock copy];
    _refreshFailedBlock  = [errorBlock copy];
    [self refreshFromServer];

}

- (void)refreshFromServer {

    TRACE_KILLROY

    TRACE(@"Service model refresh is crufted ");
    _isRefreshing = NO;
    if (_refreshSuccessBlock) {
        _refreshSuccessBlock();
        _refreshSuccessBlock = nil;
        _refreshFailedBlock  = nil;
    }
    return;

//    if (_isRefreshing) return;
//
//    if (![AppState sharedAppState].isAppUsable) {
//        TRACE(@"**** App is not usable, not reading from server.");
//        _isRefreshing = NO;
//        if (_refreshSuccessBlock) {
//            _refreshSuccessBlock();
//            _refreshSuccessBlock = nil;
//            _refreshFailedBlock  = nil;
//        }
//        return;
//    }
//
//    _isRefreshing = YES;
//    [_allServicesFilter refreshFilter];
//
//
//    // now go talk to mama
//
//    EHRServerRequest *userInfoRequest = [[EHRServerRequest alloc] init];
//    userInfoRequest.server     = [SecureCredentials sharedCredentials].current.server;
//    userInfoRequest.route      = @"/app/commands";
//    userInfoRequest.command    = @"userinfo";
//    userInfoRequest.apiKey     = [SecureCredentials sharedCredentials].current.userApiKey;
//    userInfoRequest.parameters = [NSMutableDictionary dictionaryWithObject:@"get"
//                                                                    forKey:@"action"];
//
//    double  start         = CACurrentMediaTime();
//    EHRCall *userInfoCall = [EHRCall callWithRequest:userInfoRequest
//                                           onSuccess:^(EHRCall *call) {
//                                               TRACE(@"Received services info ");
////                                               double successEnd = CACurrentMediaTime();
////                                               double delta = successEnd-start;
////                                               TRACE(@"Roundtrip pass : %f",delta);
//                                               id val = [call.serverResponse.responseContent objectForKey:@"services"];
//                                               if (val) {
//                                                   TRACE(@"Received services ");
//                                                   [_appState.servicesModel populateWithServices:[val allValues]];
//                                               }
//                                               if (_refreshSuccessBlock) {
//                                                   _refreshSuccessBlock();
//                                               }
//                                               _refreshFailedBlock  = nil;
//                                               _refreshSuccessBlock = nil;
//                                           }
//                                             onError:^(EHRCall *call) {
//                                                 MPLOGERROR(@"error when refrewhing user info !");
//                                                 MPLOGERROR(@"Got requestStatus [%@]", call.serverResponse.requestStatus.asDictionary);
//                                                 double successEnd    = CACurrentMediaTime();
//                                                 double delta         = successEnd - start;
//                                                 MPLOGERROR(@"Roundtrip fail : %f", delta);
//                                                 if (_refreshFailedBlock) {
//                                                     _refreshFailedBlock();
//                                                 }
//                                                 _refreshFailedBlock  = nil;
//                                                 _refreshSuccessBlock = nil;
//
//                                             }
//    ];
//
//    userInfoCall.timeOut         = 15.0f;
//    userInfoCall.maximumAttempts = 3;
//    [userInfoCall setOnStart:^() {
//    }];
//    [userInfoCall setOnEnd:^() {
//        _isRefreshing = NO;
//    }];
//    [userInfoCall start];

}

//**************************************************************************************//
//  EHRPersistableP                                                                     //
//**************************************************************************************//

+ (id)objectWithContentsOfDictionary:(NSDictionary *)dic {
    ServicesModel *sm = [[self alloc] init];
    sm.lastRefreshed = WantDateFromDic(dic, @"lastRefreshed");
    sm.lastUpdated   = WantDateFromDic(dic, @"lastUpdated");
    sm.lastSeen      = WantDateFromDic(dic, @"lastSeen");
    if (!sm.lastSeen) sm.lastSeen = [NSDate dateWithTimeIntervalSince1970:0];

    id val = dic[@"services"]; // this would be a NSDictionary keyed on creationOrder (see IBService)
    if (val) {
        [sm populateWithServices:[val allValues]];
    }
    return sm;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (!self.lastSeen) self.lastSeen = [NSDate dateWithTimeIntervalSince1970:0];

    PutDateInDic(self.lastUpdated, dic, @"lastUpdated");
    PutDateInDic(self.lastRefreshed, dic, @"lastRefreshed");
    PutDateInDic(self.lastSeen, dic, @"lastSeen");

    NSMutableDictionary *dick = [NSMutableDictionary dictionary];
    for (IBService      *service in [_allServices allValues]) {
        dick[service.creationOrder] = [service asDictionary];
    }

    dic[@"services"] = dick;
    return dic;
}

- (BOOL)saveOnDevice {
    return YES;
//    NSDictionary *dictionary = [self asDictionary];
//    BOOL         status      = [dictionary writeToFile:_servicesFileFQN atomically:YES];
//    if (!status) {
//        MPLOG(@"*** Unknown error while Saving [%@]", _servicesFileFQN);
//    }
//    return status;
}

+ (ServicesModel *)readFromDevice {
    NSDictionary  *dic = [NSDictionary dictionaryWithContentsOfFile:_servicesFileFQN];
    ServicesModel *nm  = [self objectWithContentsOfDictionary:dic];
    [nm setAllFilters];
    [nm refreshFilters];
    return nm;
}

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
- (void)reloadFromDevice {

    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:_servicesFileFQN];
    [self loadFromDic:dic];
    [self setAllFilters];
    [self refreshFilters];

}
#pragma clang diagnostic pop

- (void)loadFromDic:(NSDictionary *)dic {
    [self->_allServices removeAllObjects];

    NSDictionary      *nots = dic[@"serviceGuids"];
    for (NSDictionary *pnAsDic in [nots allValues]) {
        IBService *pn = [IBService objectWithContentsOfDictionary:pnAsDic];
        self->_allServices[pn.guid] = pn;
    }
    self->_lastRefreshed = WantDateFromDic(dic, @"lastRefreshed");
    [self refreshFilters];
}

- (BOOL)eraseFromDevice:(BOOL)__unused cascade {

    // keep the 'core' version honest
    [_allServices removeAllObjects];
    [self resetFilters];
    // wipe the device's ass with a silk cloth (sez the merovingian)
    return [[GEFileUtil sharedFileUtil] eraseItemWithFQN:_servicesFileFQN];

}

- (void)setAllFilters {

    [self setSubscribedServicesFilter:_appState.userModel.deviceSettings.subscribedServicesFilter];

}

@end
