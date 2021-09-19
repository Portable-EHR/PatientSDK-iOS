//
//  EHRServerRequest.h
//  patient
//
//  Created by Yves Le Borgne on 2015-09-30.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

@class EHRApiServer;

@interface EHRServerRequest : NSObject {
    NSString *_language;
    long     _instanceNumber;
}

@property(nonatomic) NSString     *language;
@property(nonatomic) NSString     *route;
@property(nonatomic) NSString     *apiKey;
@property(nonatomic) NSString     *command;
@property(nonatomic) NSString     *appAlias;
@property(nonatomic) NSString     *appGuid;
@property(nonatomic) Version      *appVersion;
@property(nonatomic) NSString     *trackingId;
@property(nonatomic) NSString     *deviceGuid;
@property(nonatomic) EHRApiServer *server;

+ (EHRServerRequest *)serverRequestWithApiKey:(NSString *)apiKey;

@property(nonatomic, strong) NSMutableDictionary *parameters;

- (void)setParametersWithJSONstring:(NSString *)json;

- (NSDictionary *)asDictionary;
- (NSString *)asJSON;

@end
