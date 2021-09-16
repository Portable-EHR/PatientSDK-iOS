//
// Created by Yves Le Borgne on 2015-10-26.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "RecordsModel.h"
#import "Patient.h"
#import "GEFileUtil.h"
#import "Record.h"

@implementation RecordsModel

@synthesize patient = _patient;
@synthesize records = _records;

TRACE_OFF

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        _lastRefreshed = [NSDate dateWithTimeIntervalSince1970:0];
        _records = [NSMutableDictionary dictionary];
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

+ (instancetype)recordsModelForPatient:(Patient *)patient {
    RecordsModel *rm = [[self alloc] init];
    rm->_patient = patient;
    return rm;
}

#pragma mark - utility stuff

- (NSString *)getFQN {
    if (!_patient) return nil;
    return [[GEFileUtil sharedFileUtil] getRecordsFQN:_patient.guid];
}

#pragma mark - EHRPersistableP

+ (RecordsModel *)objectWithJSON:(NSString *)jsonString {
    NSDictionary *dic = [NSDictionary dictionaryWithJSON:jsonString];
    return [RecordsModel objectWithContentsOfDictionary:dic];
}

+ (RecordsModel *)objectWithJSONdata:(NSData *)jsonData {
    NSDictionary *dic = [NSDictionary dictionaryWithJSONdata:jsonData];
    return [RecordsModel objectWithContentsOfDictionary:dic];
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
    NSMutableDictionary *recordsAsDic = [NSMutableDictionary dictionary];
    for (Record         *record in [_records allValues]) {
        [recordsAsDic setObject:[record asDictionary] forKey:record.guid];
    }
    [dic setObject:recordsAsDic forKey:@"records"];
    return dic;
}

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    RecordsModel *nm = [[self alloc] init];
    [nm loadWithContentsOfDictionary:dic];
    return nm;
}

- (BOOL)saveOnDevice:(BOOL)cascade {
    if (!_patient) return NO;
    return [[self asDictionary] writeToFile:[self getFQN] atomically:YES];
}

+ (RecordsModel *)readRecordsModelForPatientWithGuid:(NSString *)guid {
    NSString     *dir = [[GEFileUtil sharedFileUtil] getPatientsDirectoryName];
    NSString     *fqn = [[dir stringByAppendingPathComponent:guid] stringByAppendingPathComponent:[[GEFileUtil sharedFileUtil] getPatientFileName]];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:fqn];
    RecordsModel *pm  = [[RecordsModel alloc] init];
    [pm loadWithContentsOfDictionary:dic];
    return pm;
}

- (BOOL)loadWithContentsOfDictionary:(NSDictionary *)dic {
    self->_lastRefreshed = WantDateFromDic(dic, @"lastRefreshed");
    id val;
    if ((val = [dic objectForKey:@"patient"])) self->_patient = [Patient objectWithContentsOfDictionary:val];
    if ((val = [dic objectForKey:@"records"])) {
        self->_records = [NSMutableDictionary dictionary];
        for (NSDictionary *recordAsDictionary in [val allValues]) {
            Record *rec = [Record objectWithContentsOfDictionary:recordAsDictionary];
            [self->_records setObject:rec forKey:rec.guid];
        }
    }
    return YES;
}

#pragma mark - persistence stuff

- (BOOL)readFromDevice:(BOOL) __unused cascade {
    if (!_patient) return false;
    [_records removeAllObjects];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[self getFQN]];
    [self loadWithContentsOfDictionary:dic];
    return [self loadWithContentsOfDictionary:dic];
}

- (BOOL)eraseFromDevice:(BOOL)__unused cascade {
    return [[GEFileUtil sharedFileUtil] eraseItemWithFQN:[self getFQN]];
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
    _patient = nil;
}

@end