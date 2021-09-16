//
//  GEFileUtil.h
//  Max Power
//
//  Created by Yves Le Borgne on 11-07-20.
//  // Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"

/*
 *    -home
 *    -home/appState.plist                      // the current app state (userModel, notificationModel, patientModel, etc ...
 *    -home/users                               // a folder containing device users's space
 *    -home/users/guid                          // a folder with users'guid as name
 *    -home/users/guid/userModel.plist          // the userModel for the user
 *    -home/users/guid/resources                // the users's resources
 *    -home/patients                            // folder container for patients
 *    -home/patients/guid                       // one folder per patient, with patient's guid as name
 *    -home/patients/guid/patientModel.plist    // the patient model
 *    -home/patients/guid/resources             // the patient's resources
 *    -home/resources                           // the app's resources
 */

@interface GEFileUtil : NSObject <EHRInstanceCounterP> {

    @private
    __strong NSString
            *_documentDir,
            *_libraryDir,
            *_patientsDir,
            *_usersDir,
            *_resourcesDir;

    NSInteger
            _instanceNumber;

}

+ (GEFileUtil *)sharedFileUtil;

- (BOOL)resetDevice;

- (NSString *)getAppResourcesPath;
- (NSString *)getDocumentsPath;
- (NSString *)getLibraryPath;
- (NSString *)getUserPatientsPath;
- (NSString *)getUserResourcesPath;

- (BOOL)makeUserPatientsDirectory;
- (BOOL)makePatientDirectoryFor:(NSString *)patientGuid;
- (BOOL)makeUserResourcesDirectory;
- (BOOL)makedDirectory:(NSString *)path;

- (NSString *)getAppStateFileName;
- (NSString *)getAppStatePath;
- (NSString *)getAppStateFQN;

- (NSString *)getNotificationsFileName;
- (NSString *)getNotificationsPath;
- (NSString *)getNotificationsFQN;

- (NSString *)getServicesFileName;
- (NSString *)getServicesPath;
- (NSString *)getServicesFQN;

- (NSString *)getEulasFileName;
- (NSString *)getEulasPath;
- (NSString *)getEulasFQN;

- (NSString *)getUsersDirectoryPath;
- (NSString *)getUserFileName;
- (NSString *)getUserPath;
- (NSString *)getUserFQN;

- (NSString *)getPatientFileName;
- (NSString *)getPatientsDirectoryName;

- (NSString *)getRecordsFileName;
- (NSString *)getRecordsDirectoryName:(NSString *)patientGuid;
- (NSString *)getRecordsFQN:(NSString *)patientGuid;

- (BOOL)fileExists:(NSString *)path;
- (BOOL)eraseItemWithFQN:(NSString *)fqn;
- (BOOL)createFolderAtPath:(NSString *)path;

- (NSString *)getPathInBundleForFile:(NSString *)fileName;

@end
