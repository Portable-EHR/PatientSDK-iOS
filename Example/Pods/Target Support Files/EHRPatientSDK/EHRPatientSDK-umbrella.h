#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AppPreferences.h"
#import "AppState.h"
#import "PersistenceManager.h"
#import "SecureCredentials.h"
#import "ServiceSettings.h"
#import "UICKeyChainStore.h"
#import "UserCredentials.h"
#import "ContactsModel.h"
#import "EulaModel.h"
#import "EulaModelFilter.h"
#import "Inbox.h"
#import "MessagesModel.h"
#import "NotificationsModel.h"
#import "NotificationsModelFilter.h"
#import "PatientModel.h"
#import "RecordsModel.h"
#import "ServicesModel.h"
#import "ServicesModelFilter.h"
#import "UserModel.h"
#import "EHRApiServer.h"
#import "EHRCall.h"
#import "EHRReachability.h"
#import "EHRRequestStatus.h"
#import "EHRServerRequest.h"
#import "EHRServerResponse.h"
#import "AccessOffer.h"
#import "AccessRequest.h"
#import "AccessState.h"
#import "OfferedPrivateMessage.h"
#import "IBAddress.h"
#import "IBAgentInfo.h"
#import "IBAnnotation.h"
#import "IBAppInfo.h"
#import "IBAppointment.h"
#import "IBAppSummary.h"
#import "IBCapability.h"
#import "IBConsent.h"
#import "IBConsentGranted.h"
#import "IBConsentInfo.h"
#import "IBContact.h"
#import "IBDeviceInfo.h"
#import "IBDispensaryInfo.h"
#import "IBEula.h"
#import "IBHealthCareProvider.h"
#import "IBLab.h"
#import "IBLabRequest.h"
#import "IBLabRequestPDFDocument.h"
#import "IBLabRequestTextDocument.h"
#import "IBLabResult.h"
#import "IBLabResultPDFDocument.h"
#import "IBLabResultTextDocument.h"
#import "IBMedia.h"
#import "IBMediaInfo.h"
#import "IBMessageContent.h"
#import "IBMessageDistribution.h"
#import "IBPatientContact.h"
#import "IBPatientInfo.h"
#import "IBPractitioner.h"
#import "IBPractitionerJurisdiction.h"
#import "IBPractitionerPractice.h"
#import "IBService.h"
#import "IBTelex.h"
#import "IBTelexInfo.h"
#import "IBUser.h"
#import "IBUserCapability.h"
#import "IBUserEula.h"
#import "IBUserInfo.h"
#import "IBUserService.h"
#import "IBVersion.h"
#import "HCIN.h"
#import "InsuranceNumber.h"
#import "PIN.h"
#import "SIN.h"
#import "Patient.h"
#import "PatientHealthSummary.h"
#import "PatientInfo.h"
#import "PatientNotification.h"
#import "FactorsRequired.h"
#import "Record.h"
#import "UserDeviceSettings.h"
#import "EHRInstanceCounterP.h"
#import "EHRModelSequencerP.h"
#import "EHRNetworkableP.h"
#import "EHRPersistableP.h"
#import "NotificationCellListenerP.h"
#import "ScannerP.h"
#import "AuthSequencer.h"
#import "MessageDistributionProgressChange.h"
#import "NotificationProgressChange.h"
#import "AppSignature.h"
#import "DateUtil.h"
#import "EHRGuid.h"
#import "GEDeviceHardware.h"
#import "GEFileUtil.h"
#import "GEMacros.h"
#import "GERuntimeConstants.h"
#import "GETimeUtil.h"
#import "MathUtil.h"
#import "NSDictionary+JSON.h"
#import "PehrSDKConfig.h"
#import "UIView+EHR.h"
#import "Version.h"

FOUNDATION_EXPORT double EHRPatientSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char EHRPatientSDKVersionString[];

