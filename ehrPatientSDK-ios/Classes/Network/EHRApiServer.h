//
// Created by Yves Le Borgne on 2015-10-01.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"

@interface EHRApiServer : NSObject <EHRInstanceCounterP, EHRPersistableP> {
    NSInteger _instanceNumber;
}

@property(nonatomic) NSString           *routePrefix;
@property(nonatomic) NSString           *scheme;
@property(nonatomic) NSInteger          port;
@property(nonatomic) NSString           *serverDNSname;
@property(nonatomic) NSString           *host;
@property(nonatomic, readonly) NSString *oampURL;

+ (EHRApiServer *)defaultApiServer;
+ (EHRApiServer *)serverForHost:(NSString *)host;
+(EHRApiServer *) serverForStackKey:(NSString *) stackKey;

- (NSURL *)urlForRoute:(NSString *)route;

@end