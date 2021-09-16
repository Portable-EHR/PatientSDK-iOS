//
// Created by Yves Le Borgne on 2015-10-24.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "UserModel.h"
#import "IBUser.h"
#import "GEFileUtil.h"
#import "Patient.h"
#import "NotificationsModel.h"
#import "PatientModel.h"
#import "UserDeviceSettings.h"
#import "MessagesModel.h"
#import "ServicesModel.h"

@implementation UserModel

static NSString   *_fileName = @"userModel.plist";
static NSString   *_usersDirectory;
static GEFileUtil *_fileUtils;

@synthesize user = _user;
@synthesize notificationsModel = _notificationsModel;
@synthesize servicesModel = _servicesModel;
@synthesize messagesModel = _messagesModel;
@synthesize patientModels = _patientModels;
@synthesize deviceSettings = _deviceSettings;
@dynamic isGuest;
TRACE_OFF

+ (void)initialize {
    _fileUtils      = [GEFileUtil sharedFileUtil];
    _usersDirectory = [_fileUtils getUsersDirectoryPath];
    [_fileUtils createFolderAtPath:_usersDirectory];

}

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        _lastRefreshed      = [NSDate dateWithTimeIntervalSince1970:0];
        _notificationsModel = [[NotificationsModel alloc] init];
        _servicesModel      = [[ServicesModel alloc] init];
        _messagesModel      = [[MessagesModel alloc] init];
        _patientModels      = [NSMutableDictionary dictionary];
        _deviceSettings     = [[UserDeviceSettings alloc] init];
    } else {
        TRACE(@"*** super returned nil!");

    }
    return self;
}

+ (UserModel *)guest {
    UserModel *guest = [[self alloc] init];
    IBUser    *gu    = [IBUser guest];
    guest->_user = gu;
    return guest;
}

+ (UserModel *)userModelFor:(IBUser *)user {

    UserModel *us = [[self alloc] init];
    us->_user = user;

    if (user.patient) {
        PatientModel *pm = [PatientModel patientModelFor:user.patient];
        [us->_patientModels setObject:pm forKey:user.patient.guid];
    }

    if (user.proxies.count > 0) {
        for (Patient *pa in [user.proxies allValues]) {
            PatientModel *pm = [PatientModel patientModelFor:pa];
            [us->_patientModels setObject:pm forKey:pa.guid];
        }
    }

    if (user.visits.count > 0) {
        for (Patient *pa in [user.visits allValues]) {
            PatientModel *pm = [PatientModel patientModelFor:pa];
            [us->_patientModels setObject:pm forKey:pa.guid];
        }
    }

    if (user.userServiceModel) {

    }

    return us;
}

#pragma mark - model stuff

- (BOOL)isGuest {
    return [self.user.role isEqualToString:@"guest"];
}

- (BOOL)isResponderForPatientWithGuid:(NSString *)guid __unused {
    if ([self isUserForPatientWithGuid:guid]) return YES;
    if ([self isProxyResponderForPatientWithGuid:guid]) return YES;
    return NO;
}

- (BOOL)isUserForPatientWithGuid:(NSString *)guid __unused {
    if (self.user.patient && [self.user.patient.guid isEqualToString:guid]) return YES;
    return NO;
}

- (BOOL)hasPatientWithGuid:(NSString *)guid __unused {
    for (Patient *p in [self.user.patients allValues]) {
        if ([p.guid isEqualToString:guid]) return YES;
    }
    return NO;
}

- (BOOL)isProxyResponderForPatientWithGuid:(NSString *)guid __unused {
    for (Patient *p in [self.user.proxies allValues]) {
        if ([p.guid isEqualToString:guid]) return YES;
    }
    return NO;
}

- (BOOL)hasVisitWithGuid:(NSString *)guid __unused {
    for (Patient *p in [self.user.visits allValues]) {
        if ([p.guid isEqualToString:guid]) return YES;
    }
    return NO;
}

#pragma mark - EHRPersistableP

+ (UserModel *)objectWithJSON:(NSString *)jsonString {
    NSDictionary *dic = [NSDictionary dictionaryWithJSON:jsonString];
    return [UserModel objectWithContentsOfDictionary:dic];
}

+ (UserModel *)objectWithJSONdata:(NSData *)jsonData {
    NSDictionary *dic = [NSDictionary dictionaryWithJSONdata:jsonData];
    return [UserModel objectWithContentsOfDictionary:dic];
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
    [dic setObject:[_user asDictionary] forKey:@"user"];
    PutDateInDic(_lastRefreshed, dic, @"lastRefreshed");
    if (self.deviceSettings) [dic setObject:[self.deviceSettings asDictionary] forKey:@"deviceSettings"];
    return dic;
}

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    UserModel *nm = [[self alloc] init];
    nm->_user          = [IBUser objectWithContentsOfDictionary:[dic objectForKey:@"user"]];
    nm->_lastRefreshed = WantDateFromDic(dic, @"lastRefreshed");

    id val;
    if ((val = [dic objectForKey:@"deviceSettings"])) {
        nm.deviceSettings = [UserDeviceSettings objectWithContentsOfDictionary:val];
    } else {
        nm.deviceSettings = [[UserDeviceSettings alloc] init];
    }

    return nm;
}

// persistence

- (BOOL)saveOnDevice __unused {
    return [self saveOnDevice:NO];
}

- (BOOL)saveOnDevice:(BOOL)cascade {
    return YES;
//    NSString *fqName = [self getFQName];
//    [[GEFileUtil sharedFileUtil] makedDirectory:[self getUserDirectory]];
//    BOOL status = [[self asDictionary] writeToFile:fqName atomically:YES];
//    if (status) {
//        if (cascade) {
//            if (self.notificationsModel) status = [self.notificationsModel saveOnDevice];
//            if (status) {
//                if (self.patientModels.count > 0) {
//                    for (PatientModel *pm in [self.patientModels allValues]) {
//                        status = [pm saveOnDevice:cascade];
//                        if (!status) break;
//                    }
//                }
//            } else {
//                MPLOG(@"*** An error occured while saving user model cascade]");
//            }
//        }
//    } else {
//        MPLOG(@"*** Unknown error while writing file [%@]", fqName);
//    }
//    return status;
}

- (NSString *)getUserDirectory {
    if (self.user.guid) {
        return [_usersDirectory stringByAppendingPathComponent:self.user.guid];
    } else {
        return [_usersDirectory stringByAppendingPathComponent:@"unknownUser"];
    }
}

+ (NSString *)getUserDirectory:(NSString *)guid {
    return [_usersDirectory stringByAppendingPathComponent:guid];
}

- (NSString *)getFQName {
    return [[self getUserDirectory] stringByAppendingPathComponent:_fileName];
}

+ (NSString *)getFQNameForGuid:(NSString *)guid {
    return [[UserModel getUserDirectory:guid] stringByAppendingPathComponent:_fileName];

}

+ (UserModel *)readFromDevice:(NSString *)guid cascade:(BOOL)doCascade {

    MPLOG(@"Reading with doCascade %@", NSStringFromBool(doCascade));

    NSString     *fileName = [UserModel getFQNameForGuid:guid];
    NSDictionary *dic      = [NSDictionary dictionaryWithContentsOfFile:fileName];
    UserModel    *um       = [self objectWithContentsOfDictionary:dic];

    if (doCascade) {
        um->_notificationsModel = [NotificationsModel readFromDevice];
        if (um.user.patient) {
            PatientModel *pm = [PatientModel patientModelFor:um.user.patient];
            [pm readFromDevice:doCascade];
            [um->_patientModels setObject:pm forKey:um.user.patient.guid];
        }

        if (um.user.proxies.count > 0) {
            for (Patient *pa in [um.user.proxies allValues]) {
                PatientModel *pm = [PatientModel patientModelFor:pa];
                [pm readFromDevice:doCascade];
                [um->_patientModels setObject:pm forKey:pa.guid];
            }
        }

        if (um.user.visits.count > 0) {
            for (Patient *pa in [um.user.proxies allValues]) {
                PatientModel *pm = [PatientModel patientModelFor:pa];
                [pm readFromDevice:doCascade];
                [um->_patientModels setObject:pm forKey:pa.guid];
            }
        }

    }

    return um;
}

- (void)readNotificationsModelFromDevice {
    self->_notificationsModel = [NotificationsModel readFromDevice];
    [_notificationsModel refreshFilters];
}

- (BOOL)eraseFromDevice:(BOOL)cascade {
    if (cascade) {
        [self.notificationsModel eraseFromDevice:NO]; // dont propagate, we will do brutal delete below
        self->_notificationsModel = [[NotificationsModel alloc] init];
        [self->_patientModels removeAllObjects];
        [[GEFileUtil sharedFileUtil] eraseItemWithFQN:[[GEFileUtil sharedFileUtil] getUserResourcesPath]];
        [[GEFileUtil sharedFileUtil] eraseItemWithFQN:[[GEFileUtil sharedFileUtil] getUserPatientsPath]];
    }
    // clanout patients

    return [[GEFileUtil sharedFileUtil] eraseItemWithFQN:_usersDirectory];
}

- (void)updateUserInfo:(IBUser *)newInfo {
    [self updateUserInfo:newInfo save:YES];
}

- (void)updateUserInfo:(IBUser *)newInfo save:(BOOL)saveIt {
    IBUser *old = self.user;

    if (![newInfo.status isEqualToString:@"active"]) {
        MPLOG(@"Received a user model status of [%@], bailing out and deactivating the device.", newInfo.status);
        dispatch_async(dispatch_get_main_queue(), ^{
            MPLOG(@"Posting user deactivated event.");
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserDeactivatedNotification object:nil userInfo:nil];
        });
        return;
    }

    if (newInfo.apiKey) old.apiKey                          = newInfo.apiKey;
    if (newInfo.guid) old.guid                              = newInfo.guid;
    if (newInfo.role) old.role                              = newInfo.role;
    if (newInfo.patient) old.patient                        = newInfo.patient;
    if (newInfo.contact) old.contact                        = newInfo.contact;
    if (newInfo.healthCareProviders)old.healthCareProviders = newInfo.healthCareProviders;
    if (newInfo.status) old.status                          = newInfo.status;
    if (newInfo.patients) old.patients                      = newInfo.patients;
    if (newInfo.practitioners) old.practitioners            = newInfo.practitioners;
    if (newInfo.proxies) old.proxies                        = newInfo.proxies;
    if (newInfo.userServiceModel) old.userServiceModel      = newInfo.userServiceModel;
    if (newInfo.visits) old.visits                          = newInfo.visits;
    old.emailVerified  = newInfo.emailVerified;
    old.mobileVerified = newInfo.mobileVerified;
    old.identityVerified=newInfo.identityVerified;

    if (saveIt) {
        BOOL result = self.saveOnDevice;
        MPLOG(@"Saved user model with result %@", NSStringFromBool(result));
    }
}

/**
 * Implement EHRModelSequencerP
 */

- (void)pause {
}

- (void)setInterval:(float)intervalInSeconds {

}

- (void)resume {
}

- (void)refreshNow {
}

/**
 * dealloc, cleanup, and shit
 */

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();

    _deviceSettings     = nil;
    _user               = nil;
    _notificationsModel = nil;
    _messagesModel      = nil;
    _lastRefreshed      = nil;
    [_patientModels removeAllObjects];
    _patientModels = nil;
}

@end