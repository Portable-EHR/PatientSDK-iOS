//
//  EHRServerRequest.m
//  patient
//
//  Created by Yves Le Borgne on 2015-09-30.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "EHRServerRequest.h"
#import "EHRApiServer.h"
#import "EHRGuid.h"
#import "IBDeviceInfo.h"
#import "SecureCredentials.h"
#import "UserCredentials.h"
#import "Version.h"
#import "PehrSDKConfig.h"

@implementation EHRServerRequest

TRACE_OFF

- (id)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        self.server     = [SecureCredentials sharedCredentials].current.server;
        self.command    = @"pingManualCall";
        self.apiKey     = @"patient01ApiKey";
        self.language   = PehrSDKConfig.shared.deviceLanguage;
        self.route      = @"/app/commands";
        self.trackingId = [EHRGuid guid];
        self.parameters = [NSMutableDictionary dictionary];
        self.deviceGuid = [SecureCredentials sharedCredentials].current.deviceGuid;
        self.appAlias   = [PehrSDKConfig.shared getAppAlias];
        self.appVersion = [PehrSDKConfig.shared getAppVersion];
        self.appGuid    = [PehrSDKConfig.shared getAppGuid];
    } else {
        MPLOG(@"*** Yelp ! super returned nil");
    }
    return self;
}

+ (EHRServerRequest *)serverRequestWithApiKey:(NSString *)apiKey {
    EHRServerRequest *rq = [[self alloc] init];
    rq.apiKey = apiKey;
    return rq;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic[@"language"]   = self.language;
    dic[@"apiKey"]     = self.apiKey;
    dic[@"command"]    = self.command;
    dic[@"route"]      = self.route;
    dic[@"parameters"] = self.parameters;
    dic[@"trackingId"] = self.trackingId;
    PutStringInDic(self.deviceGuid, dic, @"deviceGuid");
    PutStringInDic(self.appAlias, dic, @"appAlias");
    PutStringInDic(self.appGuid, dic, @"appGuid");
    PutStringInDic([self.appVersion description], dic, @"appVersion");
    return dic;
}

- (void)setParametersWithJSONstring:(NSString *)json __unused {
    NSDictionary *dic = [NSDictionary dictionaryWithJSON:json];
    self.parameters = [NSMutableDictionary dictionaryWithDictionary:dic];

}

- (NSString *)asJSON {
    NSError  *writeError = nil;
    NSData   *jsonData;
    NSString *jsonString;
    if (@available(iOS 13.0, *)) {
        jsonData = [NSJSONSerialization dataWithJSONObject:[self asDictionary]
                                                   options:NSJSONWritingPrettyPrinted + NSJSONWritingWithoutEscapingSlashes
                                                     error:&writeError];
        if (writeError) {
            TRACE(@"Write error : %@", [writeError description]);
        }
        jsonString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] stringByRemovingPercentEncoding];
    } else {
        // Fallback on earlier versions
        jsonData   = [NSJSONSerialization dataWithJSONObject:[self asDictionary]
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:&writeError];
        jsonString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] stringByRemovingPercentEncoding];
    }
    if (writeError) {
        TRACE(@"Write error : %@", [writeError description]);
    }

    return jsonString;
}

- (void)setLanguage:(NSString *)language {

    _language = language;

}

- (NSString *)language {
    return _language;
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end
