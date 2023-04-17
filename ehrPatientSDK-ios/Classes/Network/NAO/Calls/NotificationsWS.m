//
// Created by Yves Le Borgne on 2023-01-02.
//

#import "NotificationsWS.h"
#import "PatientNotification.h"
#import "EHRRequests.h"
#import "PehrSDKConfig.h"
#import "Models.h"

@interface NotificationsWS () {
    NSInteger _instanceNumber;
}
@end

@implementation NotificationsWS

TRACE_ON

//region calls

- (EHRCall *)setSeen:(PatientNotification *)notification
           onSuccess:(SenderBlock)successBlock
             onError:(SenderBlock)errorBlock {
    NSMutableDictionary *params  = [@{@"guids": @[notification.guid]} mutableCopy];
    EHRServerRequest    *request = [EHRRequests requestWithRoute:@"/app/notification"
                                                         command:@"seen" parameters:params];
    return [EHRCall callWithRequest:request onSuccess:successBlock onError:errorBlock];
}

- (EHRCall *)getListCall:(NSDate *)since onSuccess:(SenderBlock)successBlock onError:(SenderBlock)errorBlock {
    NSString            *sinceAsString = NetworkDateFromDate(since);
    NSMutableDictionary *parameters    = [@{@"status": @"all", @"since": sinceAsString, @"type": @"all"} mutableCopy];
    EHRServerRequest    *request       = [EHRRequests requestWithRoute:@"/app/notification"
                                                               command:@"list" parameters:parameters];
    return [EHRCall callWithRequest:request onSuccess:successBlock onError:errorBlock];
}

//endregion

//region WF

- (void)pullSinceDate:(NSDate *)date onSuccess:(VoidBlock)successBlock onError:(VoidBlock)errorBlock {
    PehrSDKConfig *shared = [PehrSDKConfig shared];
    [shared.models.notifications readFromServerWithSuccess:successBlock andError:errorBlock];
}

- (void)pullForever:(VoidBlock)successBlock onError:(VoidBlock)errorBlock {
    VoidBlock datePullSuccess = ^{
        successBlock();
    };
    VoidBlock datePullError   = ^{
        errorBlock();
    };
    [self pullSinceDate:forever() onSuccess:datePullSuccess onError:datePullError];
}

- (void)archive:(PatientNotification *)notification onSuccess:(VoidBlock)successBlock onError:(SenderBlock)errorBlock {

    SenderBlock archiveSuccess = ^(EHRCall *theCall) {
        MPLOG(@"Archive notification %@ : SUCCESS", notification.guid);
        successBlock();
    };

    SenderBlock archiveError = ^(EHRCall *theCall) {
        MPLOG(@"Archive notification %@ : FAILED", notification.guid);
        errorBlock(theCall);
    };

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"guid"] = notification.guid;
    EHRServerRequest *request = [EHRRequests requestWithRoute:@"/app/notification"
                                                      command:@"archive"
                                                   parameters:params
    ];

    EHRCall *call = [EHRCall callWithRequest:request onSuccess:archiveSuccess onError:archiveError];
    [call start];
}

- (void)unarchive:(PatientNotification *)notification onSuccess:(VoidBlock)successBlock onError:(SenderBlock)errorBlock {

    SenderBlock unarchiveSuccess = ^(EHRCall *theCall) {
        MPLOG(@"Unarchived notification %@ : SUCCESS", notification.guid);
        successBlock();
    };

    SenderBlock unarchiveError = ^(EHRCall *theCall) {
        MPLOG(@"Unrchived notification %@ : FAILED", notification.guid);
        errorBlock(theCall);
    };

    NSMutableDictionary *params         = [NSMutableDictionary dictionary];
    params[@"guid"] = notification.guid;
    EHRServerRequest *request = [EHRRequests requestWithRoute:@"/app/notification"
                                                      command:@"unarchive"
                                                   parameters:params
    ];

    EHRCall *call = [EHRCall callWithRequest:request onSuccess:unarchiveSuccess onError:unarchiveError];
    [call start];
}




//endregion

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end