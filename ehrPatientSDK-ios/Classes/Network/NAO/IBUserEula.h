//
// Created by Yves Le Borgne on 2017-09-29.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRNetworkableP.h"
#import "EHRInstanceCounterP.h"
#import "Version.h"

@class IBEula;

@interface IBUserEula : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;

}

@property(nonatomic) NSDate   *dateSeen;
@property(nonatomic) NSDate   *dateConsented;
@property(nonatomic) NSString *userGuid;
@property(nonatomic) NSString *eulaGuid;
@property(nonatomic) NSString *patientGuid;
@property(nonatomic) NSString *scope;
@property(nonatomic) NSString *aboutGuid;
@property (nonatomic) Version *eulaVersion;

// non persistable

@property (nonatomic) IBEula *eula;

// dynamic (inferred) properties

@property (nonatomic, readonly) BOOL wasSeen;
@property (nonatomic, readonly) BOOL wasConsented;

-(void) refreshWith:(IBUserEula *) other;


@end