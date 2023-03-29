//
// Created by Yves Le Borgne on 2017-08-21.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "IBUserService.h"
#import "GERuntimeConstants.h"

@implementation IBUserService

TRACE_OFF

@dynamic isEulaAccepted, isEulaSeen;

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
}

+ (id)objectWithJSON:(NSString *)jsonString {
    return nil;
}

+ (id)objectWithJSONdata:(NSData *)jsonData {
    return nil;
}

- (NSData *)asJSONdata {
    return nil;
}

- (NSString *)asJSON {
    return nil;
}

+ (id)objectWithContentsOfDictionary:(NSDictionary *)dic {

    IBUserService *userService = [[IBUserService alloc] init];
    userService.serviceGuid            = WantStringFromDic(dic, @"serviceGuid");
    userService.healthCareProviderGuid = WantStringFromDic(dic, @"healthCareProviderGuid");
    userService.state                  = WantStringFromDic(dic, @"state");
    userService.createdOn              = WantDateFromDic(dic, @"createdOn");
    userService.lastUpdated            = WantDateFromDic(dic, @"lastUpdated");
    userService.dateEulaAccepted       = WantDateFromDic(dic, @"dateEulaAccepted");
    userService.dateEulaSeen           = WantDateFromDic(dic, @"dateEulaSeen");
    return userService;

}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.serviceGuid, dic, @"serviceGuid");
    PutStringInDic(self.healthCareProviderGuid, dic, @"healthCareProviderGuid");
    PutStringInDic(self.state, dic, @"state");
    PutDateInDic(self.createdOn, dic, @"createdOn");
    PutDateInDic(self.lastUpdated, dic, @"lastUpdated");
    PutDateInDic(self.dateEulaAccepted, dic, @"dateEulaAccepted");
    PutDateInDic(self.dateEulaSeen, dic, @"dateEulaSeen");

    return dic;
}

#pragma mark -
#pragma mark - business methods

- (BOOL)isEulaAccepted {
    if (_dateEulaAccepted) return YES;
    if ([_state isEqualToString:@"pendingEula"]) return NO;
    if ([_state isEqualToString:@"active"]) return YES;

    MPLOGERROR(@"*** Server consistency error on userService [%@] :   ", _state);
    return NO;
}

- (BOOL)isEulaSeen {
    if (_dateEulaSeen) return YES;
    return NO;
}

@end
