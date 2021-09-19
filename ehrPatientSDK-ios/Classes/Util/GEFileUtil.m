//
//  GEFileUtil.m
//
//
//  Created by Yves Le Borgne on 11-07-20.
//  Copyright 2010-2017 Shiva Technologies inc. All rights reserved.
//

#import "GEFileUtil.h"
#import "GEDeviceHardware.h"
#import "GEMacros.h"

@interface GEFileUtil (Private)

- (NSString *)getPropertiesBundlePath:(NSString *)plistName;

- (BOOL)initAppOnDevice;

@end

static NSString *const FOLDER_LIBRARY = @"Library";

static NSString *const FILE_APP_STATE     = @"appState.plist";
static NSString *const FILE_NOTIFICATIONS = @"notificationsModel.plist";
static NSString *const FILE_SERVICES      = @"servicesModel.plist";
static NSString *const FILE_EULAS         = @"eulaModel.plist";
static NSString *const FILE_USER          = @"userModel.plist";
static NSString *const FILE_PATIENT       = @"patientModel.plist";
static NSString *const FILE_RECORDS       = @"recordsModel.plist";
static NSString *const FILE_CONTACTS      = @"contactsModel.plist";

@implementation GEFileUtil

static GEFileUtil *_fileUtilInstance = nil;

TRACE_OFF

- (id)init {

    self = [super init];
    if (self) {

        GE_ALLOC();

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _documentDir = paths[0];
        paths        = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        _libraryDir  = paths[0];

        if ([[GEDeviceHardware platformString] isEqualToString:@"Simulator"]) {
            _documentDir = @"/usr/local/media/PortableEHR.patient/iOS/Documents";
            _libraryDir  = @"/usr/local/media/PortableEHR.patient/iOS/Library";
        }
        _resourcesDir = [_libraryDir stringByAppendingPathComponent:@"resources"];
        _patientsDir  = [_libraryDir stringByAppendingPathComponent:@"patients"];
        _usersDir     = [_libraryDir stringByAppendingPathComponent:@"users"];

        [self initAppOnDevice];

    } else {
        TRACE(@"*** super returned nil !");
    }
    return self;

}

+ (GEFileUtil *)sharedFileUtil {

    static dispatch_once_t once;
    static GEFileUtil      *_fileUtilInstance;
    dispatch_once(&once, ^{
        _fileUtilInstance = [[GEFileUtil alloc] init];

    });
    return _fileUtilInstance;

}

- (BOOL)fileExists:(NSString *)filePath {

    NSString *path  = filePath;
    BOOL     exists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    TRACE(@"Looking for file %@ , exists=%@", [path lastPathComponent], NSStringFromBool(exists));
    return exists;
}

- (NSString *)getAppResourcesPath {

    return _resourcesDir;
}

- (NSString *)getLibraryPath {
    return _libraryDir;
}

- (NSString *)getDocumentsPath {
    return _documentDir;
}

- (NSString *)getUserResourcesPath {
    return [_libraryDir stringByAppendingPathComponent:@"resources"];
}

- (NSString *)getUserPatientsPath {
    return [_libraryDir stringByAppendingPathComponent:@"patients"];

}

- (BOOL)makedDirectory:(NSString *)path {
    return YES;
//    MPLOG(@"[makeDirectory] : %@",path);
//    if ([self fileExists:path]) {
//        return YES;
//    }
//    NSError *error;
//    [[NSFileManager defaultManager]
//            createDirectoryAtPath:path
//      withIntermediateDirectories:YES
//                       attributes:nil error:&error];
//    if (error) {
//        MPLOG(@"*** Error while creating directory [%@]", path);
//        MPLOG(@"%@", [error description]);
//    }
//    return nil == error;
}

- (BOOL)makeUserPatientsDirectory {
    return YES;
//    NSError *error;
//    [[NSFileManager defaultManager]
//            createDirectoryAtPath:[self getUserPatientsPath]
//      withIntermediateDirectories:YES
//                       attributes:nil error:&error];
//    if (error) {
//        MPLOG(@"*** Error while creating directory [%@]", [self getUserPatientsPath]);
//        MPLOG(@"%@", [error description]);
//    }
//    return nil == error;
}

- (BOOL)makeUsersDirectory {
    return YES;
//    NSError *error;
//    [[NSFileManager defaultManager]
//            createDirectoryAtPath:[self getUsersDirectoryPath]
//      withIntermediateDirectories:YES
//                       attributes:nil error:&error];
//    if (error) {
//        MPLOG(@"*** Error while creating directory [%@]", [self getUsersDirectoryPath]);
//        MPLOG(@"%@", [error description]);
//    }
//    return nil == error;
}

- (BOOL)makeUserDirectoryForUserWithGuid:(NSString *)userGuid {

    if (!userGuid) {
        MPLOG(@"*** Cant make patient directory for nil user guid");
        return NO;
    }
    if ([self makeUsersDirectory]) {
        NSString *userPath = [[self getUsersDirectoryPath] stringByAppendingPathComponent:userGuid];
        NSError  *error;
        [[NSFileManager defaultManager]
                createDirectoryAtPath:userPath
          withIntermediateDirectories:YES
                           attributes:nil error:&error];
        if (error) {
            MPLOG(@"*** Error while creating directory [%@]", userPath);
            MPLOG(@"%@", [error description]);
        }
        return nil == error;
    } else {
        MPLOG(@"*** Could not create patients directory");
        return NO;
    }

}

- (BOOL)makePatientDirectoryFor:(NSString *)patientGuid {
    return YES;

//    if (!patientGuid) {
//        MPLOG(@"*** Cant make patient directory for nil patient");
//        return NO;
//    }
//    if ([self makeUserPatientsDirectory]) {
//        NSString *patientPath = [[self getUserPatientsPath] stringByAppendingPathComponent:patientGuid];
//        NSError  *error;
//        [[NSFileManager defaultManager]
//                createDirectoryAtPath:patientPath
//          withIntermediateDirectories:YES
//                           attributes:nil error:&error];
//        if (error) {
//            MPLOG(@"*** Error while creating directory [%@]", [self getUserPatientsPath]);
//            MPLOG(@"%@", [error description]);
//        }
//        return nil == error;
//    } else {
//        MPLOG(@"*** Could not create patients directory");
//        return NO;
//    }
}

- (BOOL)makeUserResourcesDirectory {
    NSError *error;
    [[NSFileManager defaultManager]
            createDirectoryAtPath:[self getUserResourcesPath]
      withIntermediateDirectories:YES
                       attributes:nil error:&error];
    if (error) {
        MPLOG(@"*** Error while creating directory [%@]", [self getUserResourcesPath]);
        MPLOG(@"%@", [error description]);
    }
    return nil == error;
}

#pragma mark specs files and locations

- (NSString *)getPathInBundleForFile:(NSString *)fileName {

    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *path       = [mainBundle pathForResource:fileName ofType:nil];
    return path;
}

// confidential stuff


- (NSString *)getPropertiesBundlePath:(NSString *)plistName {

    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *dialogPath = [mainBundle pathForResource:plistName ofType:@"plist"];
    return dialogPath;
}

- (BOOL)initAppOnDevice {

    return YES;
    // create required directories in the IBUser Document
    // space

//    [[NSFileManager defaultManager]
//            createDirectoryAtPath:_libraryDir withIntermediateDirectories:YES attributes:nil error:NULL];
//
//    [[NSFileManager defaultManager]
//            createDirectoryAtPath:_documentDir withIntermediateDirectories:YES attributes:nil error:NULL];
//
//    [[NSFileManager defaultManager]
//            createDirectoryAtPath:_resourcesDir withIntermediateDirectories:YES attributes:nil error:NULL];
//
//    [[NSFileManager defaultManager]
//            createDirectoryAtPath:_patientsDir withIntermediateDirectories:YES attributes:nil error:NULL];
//
//    [[NSFileManager defaultManager]
//            createDirectoryAtPath:_usersDir withIntermediateDirectories:YES attributes:nil error:NULL];
//
//    TRACE(@"Directories initialized at %@", _libraryDir);
//
//    return YES;
}

#pragma mark - Application files

- (NSString *)getAppStateFileName {
    return FILE_APP_STATE;
}

- (NSString *)getAppStatePath {
    return _libraryDir;
}

- (NSString *)getAppStateFQN {
    return [[self getAppStatePath] stringByAppendingPathComponent:[self getAppStateFileName]];
}

- (NSString *)getNotificationsFileName {
    return FILE_NOTIFICATIONS;
}

- (NSString *)getServicesFileName {
    return FILE_SERVICES;
}


- (NSString *)getEulasFileName {
    return FILE_EULAS;
}

- (NSString *)getNotificationsPath {
    return _libraryDir;
}

- (NSString *)getServicesPath {
    return _libraryDir;
}

- (NSString *)getEulasPath {
    return _libraryDir;
}

- (NSString *)getNotificationsFQN {
    return [[self getNotificationsPath] stringByAppendingPathComponent:[self getNotificationsFileName]];
}

- (NSString *)getServicesFQN {
    return [[self getServicesPath] stringByAppendingPathComponent:[self getServicesFileName]];
}

- (NSString *)getEulasFQN {
    return [[self getEulasPath] stringByAppendingPathComponent:[self getEulasFileName]];
}

- (NSString *)getUserFileName {
    return FILE_USER;
}

- (NSString *)getUserPath {
    return _libraryDir;
}

- (NSString *)getUserFQN {
    return [[self getUserPath] stringByAppendingPathComponent:[self getUserFileName]];

}

- (NSString *)getPatientFileName {
    return FILE_PATIENT;
}

- (NSString *)getUsersDirectoryPath {
    return [_libraryDir stringByAppendingPathComponent:@"users"];
}

- (NSString *)getPatientsDirectoryName {
    return [_libraryDir stringByAppendingPathComponent:@"patients"];
}

// records model
// _libraryDir/patients/patientGuid/recordsModel.plist

- (NSString *)getRecordsFileName {
    return FILE_RECORDS;
}

- (NSString *)getContactsFileName {
    return FILE_CONTACTS;
}

- (NSString *)getRecordsDirectoryName:(NSString *)patientGuid; {
    return [[_libraryDir stringByAppendingPathComponent:@"patients"] stringByAppendingPathComponent:patientGuid];
}

- (NSString *)getRecordsFQN:(NSString *)patientGuid {
    return [[self getRecordsDirectoryName:patientGuid] stringByAppendingPathComponent:[self getRecordsFileName]];
}

- (NSString *)getContactsFQN:(NSString *)patientGuid {
    return [[self getRecordsDirectoryName:patientGuid] stringByAppendingPathComponent:[self getRecordsFileName]];
}

#pragma mark - file related methods

- (BOOL)createFolderAtPath:(NSString *)path {
    return YES;
//    NSError *error;
//    [[NSFileManager defaultManager] createDirectoryAtPath:path
//                              withIntermediateDirectories:YES
//                                               attributes:nil
//                                                    error:&error];
//    if (error) {
//        MPLOG(@"Error while creating path [%@]\nError : %@", path, error.description);
//    }
//    return (nil == error);
}

- (BOOL)eraseItemWithFQN:(NSString *)fqn {

    return YES;

//    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:fqn];
//    if (!exists) {
//        TRACE(@"*** Attempting to delete unexistant file [%@]", fqn);
//        TRACE(@"    returning success.");
//        return YES;
//    }
//
//    NSError *error;
//    [[NSFileManager defaultManager] removeItemAtPath:fqn error:&error];
//
//    if (error) {
//        MPLOG(@"*** Error deleting item [%@]", fqn);
//        MPLOG(@"%@", [error description]);
//    }
//    return !error;
}

- (BOOL)resetDevice {

//    NSFileManager *fm = [NSFileManager defaultManager];
//    NSError       *error;
//    [fm removeItemAtPath:_usersDir error:&error];
//
//    if (error) {
//        TRACE(@"*** Error to remove [%@] from devices\n%@", _usersDir, error.debugDescription);
//        error = nil;
//    }
//    [fm removeItemAtPath:_patientsDir error:&error];
//
//    if (error) {
//        TRACE(@"*** Error to remove [%@] from devices\n%@", _patientsDir, error.debugDescription);
//        error = nil;
//    }
//
//    [fm removeItemAtPath:_resourcesDir error:&error];
//    if (error) {
//        TRACE(@"*** Error to remove [%@] from devices\n%@", _resourcesDir, error.debugDescription);
//        error = nil;
//    }
//
//    [fm removeItemAtPath:[_libraryDir stringByAppendingPathComponent:@"appState.plist"] error:&error];
//    if (error) {
//        MPLOG(@"*** Error to remove [%@] from devices\n%@", @"appState.plist", error.debugDescription);
//        error = nil;
//    }
//
//    for (NSString *file in [fm contentsOfDirectoryAtPath:_libraryDir error:&error]) {
//        if ([file isEqualToString:@"Caches"] || [file isEqualToString:@"Preferences"]) {
//            MPLOG(@"Skipping %@", file);
//            continue;
//        }
//        MPLOG(@"Removing %@", file);
//        [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", _libraryDir, file] error:&error];
//        if (error) {
//            MPLOG(@"*** Error while removing file [%@] from devices\n%@", file, error.debugDescription);
//            error = nil;
//        }
//    }

    return YES;
}

- (void)dealloc {

    GE_DEALLOC();
    GE_DEALLOC_ECHO()

}

@end
