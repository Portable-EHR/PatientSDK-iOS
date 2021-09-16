//
// Created by Yves Le Borgne on 2016-03-08.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "EHRNetworkableP.h"

@class IBContact;
@class IBPractitionerJurisdiction;
@class IBPractitionerPractice;

// IBPractitioner faces the OBPractitioner class, server side.

@interface IBPractitioner : NSObject <EHRInstanceCounterP,EHRPersistableP> {

    NSInteger _instanceNumber;

}
@property (nonatomic) NSString * guid;
@property (nonatomic) IBContact *contact;
@property (nonatomic) IBContact *userContact;
@property (nonatomic) NSArray<IBPractitionerPractice *> * practices;

@end