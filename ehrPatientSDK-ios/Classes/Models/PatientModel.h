//
// Created by Yves Le Borgne on 2015-10-24.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"

@class Patient;
@class RecordsModel;
@class ContactsModel;

@interface PatientModel : NSObject <EHRInstanceCounterP, EHRPersistableP> {
    NSInteger     _instanceNumber;
    NSDate        *_lastRefreshed;
    Patient       *_patient;
    RecordsModel  *_recordsModel;
    ContactsModel *_contactsModel;
    BOOL          _isLoaded;
}

@property(nonatomic, readonly) RecordsModel *recordsModel;

+ (PatientModel *)patientModelFor:(Patient *)patient;

- (BOOL)saveOnDevice:(BOOL)cascade;
- (BOOL)eraseFromDevice:(BOOL)cascade;
- (BOOL)readFromDevice:(BOOL)cascade;

@end