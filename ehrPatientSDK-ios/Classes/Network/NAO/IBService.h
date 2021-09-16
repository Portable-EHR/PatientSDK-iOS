//
// Created by Yves Le Borgne on 2017-03-17.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"

@class IBVersion;
@class IBAgentInfo;
@class IBUserService;

@interface IBService : NSObject <EHRInstanceCounterP, EHRPersistableP> {
    NSInteger _instanceNumber;

}

@property(nonatomic) NSString     *guid;
@property(nonatomic) NSString     *name;
@property(nonatomic) NSDate       *createdOn;
@property(nonatomic) NSDate       *lastUpdated;
@property(nonatomic) NSString     *serviceDescription;           /// fucking apple, have to rename the property server side fucking apple a marde
@property(nonatomic) NSString     *serviceDescriptionRenderer;   /// fucking apple, have to rename the property server side fucking apple a marde
@property(nonatomic) NSString     *summary;
@property(nonatomic) NSString     *alias;
@property(nonatomic) NSString     *infoUrl;
@property(nonatomic) NSString     *iconMediaGuid;
@property(nonatomic) NSString     *eula;
@property(nonatomic) NSString     *eulaRenderer;
@property(nonatomic) NSString     *parentServiceGuid;
@property(nonatomic) NSInteger    seq;
@property(nonatomic) NSString     *creationOrder;
@property(nonatomic) BOOL         active;
@property(nonatomic) IBVersion    *version;            // comes as a string 1.2.3 on the wire
@property(nonatomic) IBAgentInfo  *agentInfo;
@property(nonatomic) BOOL         subscriptionRequired;
@property(nonatomic) NSDictionary *capabilities;


// non-networked properties, must be persisted on device, and then
// tossed through a network update

@property(nonatomic) BOOL wasSeen;

@end