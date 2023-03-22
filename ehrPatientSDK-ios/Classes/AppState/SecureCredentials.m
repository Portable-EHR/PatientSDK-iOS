//
// Created by Yves Le Borgne on 2017-07-31.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "SecureCredentials.h"
#import "IBUser.h"
#import "IBUserEula.h"

@implementation SecureCredentials

TRACE_OFF

static SecureCredentials *_sharedInstance;

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC()
        GE_ALLOC_ECHO()
        _domain         = [[NSBundle mainBundle] bundleIdentifier];
        _credentialsKey = @"credentials";
        _keyChain       = [UICKeyChainStore keyChainStoreWithService:_domain accessGroup:nil];
        [self reload];
    } else {
        MPLOG(@"SecureCredentials :  super returned nil!");
    }
    return self;
}

+ (SecureCredentials *)sharedCredentials {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        @try {
            _sharedInstance = [[self alloc] init];
        } @catch (NSException *ex) {
            NSLog(@"Exception at %@", ex.callStackReturnAddresses);
        }
    });
    return _sharedInstance;
}

- (void)dealloc {
    _current = nil;
}

+ (id)objectWithContentsOfDictionary:(NSDictionary *)dic {
    SecureCredentials *sc  = [[self alloc] init];
    NSDictionary      *cur = WantDicFromDic(dic, @"current");
    if (cur) sc->_current = [UserCredentials objectWithContentsOfDictionary:cur];
    return sc;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutPersistableInDic(_current, dic, @"current");
    return dic;
}

/*
 *  business methods
 */

#pragma mark business methods

- (void)reload {

    NSData *data = [_keyChain dataForKey:_credentialsKey];
    if (data) {
        NSDictionary *dictionary = [NSDictionary dictionaryWithJSONdata:data];
        if (dictionary) {
            [self loadWithContentOfDictionary:dictionary];
        }
    } else {
        NSLog(@"SecureCredentials : reload -> empty data from keychain, creating new for Guest user");
        [self setupGuest];
        [self persist];
    }

}

- (void)persist {
    NSDictionary *dic = [self asDictionary];
    if (dic) {
        NSData *data = [dic asJSONdata];
        [_keyChain setData:data forKey:_credentialsKey];
        [_keyChain synchronize];
    }

    NSLog(@"SecureCredentials : persist -> \n%@", [dic asJSON]);

}

- (void)setCurrentUserCredentials:(UserCredentials *)current {
    if (current) {
        _current = [UserCredentials objectWithContentsOfDictionary:[current asDictionary]];
    } else {
        _current = nil;
    }
}

#pragma mark private stuff

- (void)loadWithContentOfDictionary:(NSDictionary *)dic {

    NSDictionary *cur = WantDicFromDic(dic, @"current");
    if (cur) _current = [UserCredentials objectWithContentsOfDictionary:cur];

}

- (void)setupGuest {
    IBUser       *guest  = [IBUser guest];
    _current.userApiKey       = guest.apiKey;
    _current.userGuid         = guest.guid;
    _current.appEula          = [[IBUserEula alloc] init];
    _current.hasConsentedEula = NO;
    _current.deviceGuid       = nil;
}

-(void) setupServer {
    EHRApiServer *server = [EHRApiServer serverForStackKey:kStackKey];
    _current.server=server;
}

@end
