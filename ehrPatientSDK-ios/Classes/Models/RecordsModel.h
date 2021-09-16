//
// Created by Yves Le Borgne on 2015-10-26.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"

@class Patient;

@interface RecordsModel : NSObject <EHRInstanceCounterP, EHRPersistableP> {
    NSInteger           _instanceNumber;
    Patient             *_patient;
    NSMutableDictionary *_records;
    NSDate              *_lastRefreshed;
}

+ (instancetype)recordsModelForPatient:(Patient *)patient;

@property(nonatomic) Patient                *patient;
@property(nonatomic, readonly) NSDictionary *records;

- (BOOL)readFromDevice:(BOOL)cascade;
- (BOOL)saveOnDevice:(BOOL)cascade;
- (BOOL)eraseFromDevice:(BOOL)cascade;

@end