//
// Created by Yves Le Borgne on 2017-10-06.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "EHRPersistableP.h"
#import "EulaModel.h"
#import "AppState.h"
#import "EulaModelFilter.h"
#import "IBUserEula.h"
#import "GEFileUtil.h"
#import "EHRServerRequest.h"
#import "SecureCredentials.h"
#import "UserCredentials.h"
#import "EHRCall.h"
#import "EHRRequestStatus.h"
#import "EHRServerResponse.h"

@implementation EulaModel

@synthesize allUserEulas = _allUserEulas;
@synthesize allEulasFilter = _allEulasFilter;
@synthesize consentedEulasFilter = _consentedEulasFilter;
@synthesize pendingEulasFilter = _pendingEulasFilter;

@dynamic hasPendingEulas, numberOfPendingEulas, requiresAction;

TRACE_OFF

static NSString *_eulasFileFQN;
static AppState *_appState;

+ (void)initialize {
    _eulasFileFQN = [[GEFileUtil sharedFileUtil] getEulasFQN];
}

- (id)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();

        _allEulasFilter       = [EulaModelFilter allEulasFilter];
        _consentedEulasFilter = [EulaModelFilter consentedEulasFilter];
        _pendingEulasFilter   = [EulaModelFilter pendingEulasFilter];
        _allUserEulas         = [NSMutableDictionary dictionary];
        _appState             = [AppState sharedAppState];
        _lastRefreshed        = [NSDate dateWithTimeIntervalSince1970:0];
        _lastUpdated          = [NSDate dateWithTimeIntervalSince1970:0];
        _lastSeen             = [NSDate dateWithTimeIntervalSince1970:0];
    } else {
        MPLOGERROR(@"*** Yelp ! super returned nil!");
    }
    return self;

}

- (void)refreshFilters {
    [_allEulasFilter refreshFilter];
    [_consentedEulasFilter refreshFilter];
    [_pendingEulasFilter refreshFilter];
}

- (void)resetFilters {
    [_allEulasFilter resetFilter];
    [_consentedEulasFilter resetFilter];
    [_pendingEulasFilter resetFilter];
}

- (void)populateWithServices:(NSArray *)services {

    [self resetFilters];
    for (NSDictionary *serviceAsDic in services) {
        IBUserEula *service = [IBUserEula objectWithContentsOfDictionary:serviceAsDic];
        _allUserEulas[service.eulaGuid] = service; // replace
    }

    [self resetFilters];
    [self refreshFilters];
    self.lastRefreshed = [NSDate date];
    self.lastUpdated   = [NSDate date];
    [self saveOnDevice];
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

//**************************************************************************************//
//  helpers, dynamic properties                                                         //
//**************************************************************************************//

- (BOOL)requiresAction __unused {
    return ([self numberOfPendingEulas] > 0);
}

- (NSInteger)numberOfPendingEulas {
    return [_pendingEulasFilter.sortedKeys count];
}

- (BOOL)hasPendingEulas __unused {
    return [self numberOfPendingEulas] > 0;
}

- (BOOL)containsEula:(IBUserEula *)usereula {
    return (_allUserEulas[usereula.eulaGuid] != nil);
}

//**************************************************************************************//
//  helpers, business methods                                                           //
//**************************************************************************************//

- (IBUserEula *)userEulaWithGuid:(NSString *)guid __unused {
    return _allUserEulas[guid];
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

    if (_isRefreshing) return;

    if (![AppState sharedAppState].isAppUsable) {
        TRACE(@"**** App is not usable, not reading from server.");
        _isRefreshing = NO;
        if (_refreshSuccessBlock) {
            _refreshSuccessBlock();
            _refreshSuccessBlock = nil;
            _refreshFailedBlock  = nil;
        }
        return;
    }

    _isRefreshing = YES;
    [_allEulasFilter refreshFilter];


    // now go talk to mama

    EHRServerRequest *userInfoRequest = [[EHRServerRequest alloc] init];
    userInfoRequest.server     = [SecureCredentials sharedCredentials].current.server;
    userInfoRequest.route      = @"/app/user/eula";
    userInfoRequest.command    = @"get";
    userInfoRequest.apiKey     = [SecureCredentials sharedCredentials].current.userApiKey;
    userInfoRequest.parameters = [NSMutableDictionary dictionary];

    EHRCall *userInfoCall = [EHRCall callWithRequest:userInfoRequest
                                           onSuccess:^(EHRCall *call) {
                                               MPLOG(@"Received user info ");

                                               id val = call.serverResponse.responseContent[@"eulas"];
                                               if (val) {
//                                                   TRACE(@"Received services \n%@", val);
                                                   TRACE(@"Received services ");
                                                   [self->_appState.eulaModel populateWithServices:val];
                                               }
                                               if (self->_refreshSuccessBlock) {
                                                   self->_refreshSuccessBlock();
                                               }
                                               self->_refreshFailedBlock  = nil;
                                               self->_refreshSuccessBlock = nil;
                                           }
                                             onError:^(EHRCall *call) {
                                                 MPLOGERROR(@"error when refrewhing user info !");
                                                 MPLOGERROR(@"Got requestStatus [%@]", call.serverResponse.requestStatus.asDictionary);
                                                 if (self->_refreshFailedBlock) {
                                                     self->_refreshFailedBlock();
                                                 }
                                                 self->_refreshFailedBlock  = nil;
                                                 self->_refreshSuccessBlock = nil;

                                             }
    ];

    userInfoCall.timeOut         = 15.0f;
    userInfoCall.maximumAttempts = 1;
    [userInfoCall setOnStart:^() {
    }];
    [userInfoCall setOnEnd:^() {
        self->_isRefreshing = NO;
    }];
    [userInfoCall start];

}

//**************************************************************************************//
//  EHRPersistableP                                                                     //
//**************************************************************************************//

+ (id)objectWithContentsOfDictionary:(NSDictionary *)dic {
    EulaModel *sm = [[self alloc] init];
    sm.lastRefreshed = WantDateFromDic(dic, @"lastRefreshed");
    sm.lastUpdated   = WantDateFromDic(dic, @"lastUpdated");
    sm.lastSeen      = WantDateFromDic(dic, @"lastSeen");
    if (!sm.lastSeen) sm.lastSeen = [NSDate dateWithTimeIntervalSince1970:0];

    id val = dic[@"userEulas"]; // this would be a NSDictionary keyed on creationOrder (see IBService)
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
    for (IBUserEula     *service in [_allUserEulas allValues]) {
        dick[service.eulaGuid] = [service asDictionary];
    }

    dic[@"userEulas"] = dick;
    return dic;
}

- (BOOL)saveOnDevice {
    return YES;
}

+ (EulaModel *)readFromDevice {
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:_eulasFileFQN];
    EulaModel    *nm  = [self objectWithContentsOfDictionary:dic];
    [nm setAllFilters];
    [nm refreshFilters];
    return nm;
}

- (void)reloadFromDevice __unused {

    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:_eulasFileFQN];
    [self loadFromDic:dic];
    [self setAllFilters];
    [self refreshFilters];

}

- (void)loadFromDic:(NSDictionary *)dic {
    [self->_allUserEulas removeAllObjects];

    NSDictionary      *nots = dic[@"serviceGuids"];
    for (NSDictionary *pnAsDic in [nots allValues]) {
        IBUserEula *pn = [IBUserEula objectWithContentsOfDictionary:pnAsDic];
        self->_allUserEulas[pn.eulaGuid] = pn;
    }
    self->_lastRefreshed = WantDateFromDic(dic, @"lastRefreshed");
    [self refreshFilters];
}

- (BOOL)eraseFromDevice:(BOOL)__unused cascade {

    // keep the 'core' version honest
    [_allUserEulas removeAllObjects];
    [self resetFilters];
    // wipe the device's ass with a silk cloth (sez the merovingian)
    return [[GEFileUtil sharedFileUtil] eraseItemWithFQN:_eulasFileFQN];

}

- (void)setAllFilters {

}

@end
