//
// Created by Yves Le Borgne on 2016-03-08.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "EHRInstanceCounterP.h"

@interface IBPractitionerJurisdiction : NSObject   <EHRInstanceCounterP, EHRPersistableP>
{
    NSInteger _instanceNumber;
}
@property (nonatomic) NSString *desc;                   // should be description , but alas, obje-C hoags the term
@property (nonatomic) NSString *issuer;
@property (nonatomic) NSString *practitionerType;
@end