//
// Created by Yves Le Borgne on 2015-10-24.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "PatientModel.h"
#import "Patient.h"
#import "GEFileUtil.h"
#import "RecordsModel.h"

@implementation PatientModel

static NSString *_patientsDirectory;
static NSString *_patientModelFileName;

@synthesize recordsModel = _recordsModel;

TRACE_OFF

+ (void)initialize {
    _patientModelFileName = [[GEFileUtil sharedFileUtil] getPatientFileName];
    _patientsDirectory    = [[GEFileUtil sharedFileUtil] getPatientsDirectoryName];
}

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        _patient      = [[Patient alloc] init];
        _recordsModel = [[RecordsModel alloc] init];
        _isLoaded     = NO;
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

+ (PatientModel *)patientModelFor:(Patient *)patient {
    PatientModel *pm = [[PatientModel alloc] init];
    pm->_patient = patient;
    return pm;
}

#pragma mark - utility methods

- (NSString *)patientModelDirectory {
    return [_patientsDirectory stringByAppendingPathComponent:_patient.guid];
}

- (NSString *)patientModelFQN {
    return [[self patientModelDirectory] stringByAppendingPathComponent:_patientModelFileName];
}

#pragma mark - EHRPersistableP

+ (PatientModel *)objectWithJSON:(NSString *)jsonString {
    NSDictionary *dic = [NSDictionary dictionaryWithJSON:jsonString];
    return [PatientModel objectWithContentsOfDictionary:dic];
}

+ (PatientModel *)objectWithJSONdata:(NSData *)jsonData {
    NSDictionary *dic = [NSDictionary dictionaryWithJSONdata:jsonData];
    return [PatientModel objectWithContentsOfDictionary:dic];
}

- (NSData *)asJSONdata {
    NSDictionary *dic = [self asDictionary];
    return [dic asJSONdata];
}

- (NSString *)asJSON {
    NSDictionary *dic = [self asDictionary];
    return [dic asJSON];
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[_patient asDictionary] forKey:@"patient"];
    PutDateInDic(_lastRefreshed, dic, @"lastRefreshed");
    return dic;
}

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    PatientModel *nm = [[self alloc] init];
    nm->_patient       = [Patient objectWithContentsOfDictionary:[dic objectForKey:@"patient"]];
    nm->_lastRefreshed = WantDateFromDic(dic, @"lastRefreshed");
    return nm;
}

// persistence

- (BOOL)saveOnDevice:(BOOL)__unused cascade {
    return YES;
//    if ([[GEFileUtil sharedFileUtil] makePatientDirectoryFor:_patient.guid]) {
//        BOOL success = [[self asDictionary] writeToFile:[self patientModelFQN] atomically:YES];
//        if (!success) {
//            MPLOG(@"*** Unknown error writing to file [%@]", [self patientModelFQN]);
//        }
//        return success;
//    } else {
//        return NO;
//    }
}

+ (PatientModel *)readPatientWithGuid:(NSString *)guid __unused {
    NSString     *dir = _patientsDirectory;
    NSString     *fqn = [[dir stringByAppendingPathComponent:guid] stringByAppendingPathComponent:_patientModelFileName];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:fqn];
    PatientModel *pm  = [[PatientModel alloc] init];
    [pm loadWithContentsOfDictionary:dic];
    return pm;
}

- (BOOL)loadWithContentsOfDictionary:(NSDictionary *)dic {
    self->_lastRefreshed = WantDateFromDic(dic, @"lastRefreshed");
    id val;
    if ((val = [dic objectForKey:@"patient"])) self->_patient = [Patient objectWithContentsOfDictionary:val];
    _recordsModel = [RecordsModel recordsModelForPatient:_patient];
    _isLoaded = YES;
    return YES;
}

- (BOOL)readFromDevice:(BOOL)cascade {
    NSString     *dir = [[GEFileUtil sharedFileUtil] getPatientsDirectoryName];
    NSString     *fqn = [[dir stringByAppendingPathComponent:_patient.guid] stringByAppendingPathComponent:[[GEFileUtil sharedFileUtil] getPatientFileName]];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:fqn];
    if (cascade) {
        _recordsModel = [[RecordsModel alloc] init];
        return [_recordsModel readFromDevice:cascade];
    }
    return [self loadWithContentsOfDictionary:dic];
}

- (BOOL)eraseFromDevice:(BOOL)cascade __unused {
    if (cascade) {
        BOOL success = [[GEFileUtil sharedFileUtil] eraseItemWithFQN:[_patientsDirectory stringByAppendingPathComponent:_patient.guid]];
        if (success) {
            _recordsModel = [[RecordsModel alloc] init];
        }
        return success;
    } else {
        return [[GEFileUtil sharedFileUtil] eraseItemWithFQN:[self patientModelFQN]];
    }
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
    _patient = nil;
}

@end