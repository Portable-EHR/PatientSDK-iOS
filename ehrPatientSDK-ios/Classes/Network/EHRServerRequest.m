//
//  EHRServerRequest.m
//  patient
//
//  Created by Yves Le Borgne on 2015-09-30.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "EHRServerRequest.h"
#import "EHRApiServer.h"
#import "AppState.h"
#import "EHRGuid.h"
#import "IBDeviceInfo.h"
#import "SecureCredentials.h"
#import "UserCredentials.h"
#import "Version.h"

@implementation EHRServerRequest

TRACE_OFF

- (id)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        self.server     = [SecureCredentials sharedCredentials].current.server;
        self.command    = @"pingManualCall";
        self.apiKey     = @"patient01ApiKey";
        self.language   = [AppState sharedAppState].deviceLanguage;
        self.route      = @"/app/commands";
        self.trackingId = [EHRGuid guid];
        self.parameters = [NSMutableDictionary dictionary];
        self.deviceGuid = [SecureCredentials sharedCredentials].current.deviceGuid;
        self.appAlias   = kAppAlias;
        self.appVersion = kAppVersion;
        self.appGuid    = kAppGuid;
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
    [dic setObject:self.language forKey:@"language"];
    [dic setObject:self.apiKey forKey:@"apiKey"];
    [dic setObject:self.command forKey:@"command"];
    [dic setObject:self.route forKey:@"route"];
    [dic setObject:self.parameters forKey:@"parameters"];
    [dic setObject:self.trackingId forKey:@"trackingId"];
    PutStringInDic(self.deviceGuid, dic, @"deviceGuid");
    PutStringInDic(self.appAlias, dic, @"appAlias");
    PutStringInDic(self.appGuid, dic, @"appGuid");
    PutStringInDic([self.appVersion description], dic, @"appVersion");
    return dic;
}

- (void)setParametersWithJSONstring:(NSString *)json {
    NSDictionary *dic = [NSDictionary dictionaryWithJSON:json];
    self.parameters = [NSMutableDictionary dictionaryWithDictionary:dic];

}

- (NSString *)asJSON {
    NSError *writeError = nil;
    NSData  *jsonData   = [NSJSONSerialization dataWithJSONObject:[self asDictionary]
                                                          options:NSJSONWritingPrettyPrinted + NSJSONWritingWithoutEscapingSlashes
                                                            error:&writeError];
    if (writeError) {
        TRACE(@"Write error : %@", [writeError description]);
    }
    NSString *jsonString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] stringByRemovingPercentEncoding];
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
