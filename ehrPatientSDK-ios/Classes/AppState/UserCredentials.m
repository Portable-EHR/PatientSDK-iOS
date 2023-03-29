//
// Created by Yves Le Borgne on 2017-07-31.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "UserCredentials.h"
#import "IBUserEula.h"
#import "IBUser.h"
#import "GERuntimeConstants.h"

@implementation UserCredentials

TRACE_OFF

@synthesize hasConsentedEula;

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
    _server=nil;
    _deviceGuid=nil;
    _userGuid=nil;
    _userApiKey=nil;
    _dismissedResearchConsent=NO;
    _isUserPasswordSet=NO;
}

+ (id)objectWithContentsOfDictionary:(NSDictionary *)dic {

    UserCredentials *uc = [[self alloc] init];

    uc->_deviceGuid = WantStringFromDic(dic, @"deviceGuid");
    uc->_userGuid = WantStringFromDic(dic, @"userGuid");
    uc->_userApiKey = WantStringFromDic(dic, @"userApiKey");
    NSDictionary *server = WantDicFromDic(dic, @"server");
    if (server) uc->_server= [EHRApiServer objectWithContentsOfDictionary:server];
    NSDictionary *ue = WantDicFromDic(dic, @"appEula");
    if (ue) uc->_appEula = [IBUserEula objectWithContentsOfDictionary:ue];
    uc->_dismissedResearchConsent = WantBoolFromDic(dic, @"dismissedResearchConsent");
    uc->_isUserPasswordSet = WantBoolFromDic(dic, @"isUserPasswordSet") ?: NO;
    return uc;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    PutStringInDic(_userApiKey, dic, @"userApiKey");
    PutStringInDic(_userGuid, dic, @"userGuid");
    PutStringInDic(_deviceGuid, dic, @"deviceGuid");
    PutPersistableInDic(_server, dic, @"server");
    PutPersistableInDic(_appEula, dic, @"appEula");
    PutBoolInDic(_dismissedResearchConsent, dic, @"dismissedResearchConsent");
    PutBoolInDic(_isUserPasswordSet, dic, @"isUserPasswordSet");

    return dic;
}

-(BOOL) __unused hasConsentedEula {
    if (!self.appEula) return NO;
    if (self.appEula.dateConsented) return YES;
    return NO;
}

-(BOOL) __unused hasDismissedResearchConsent {
    return _dismissedResearchConsent == true;
}

-(BOOL)isUserPasswordSet {
    return _isUserPasswordSet;
}

-(BOOL) __unused isGuest {
    IBUser * guest = [IBUser guest];
    if( [guest.guid isEqualToString:self.userGuid]) return YES;
    if ([guest.apiKey isEqualToString:self.userApiKey]) return YES;
    return NO;
}

@end
