//
// Created by Yves Le Borgne on 2023-01-02.
//

#import "NotificationsWS.h"
#import "EHRCall.h"
#import "PatientNotification.h"
#import "EHRRequests.h"

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

-(EHRCall*) getListCall:(NSDate*) since onSuccess:(SenderBlock) successBlock onError:(SenderBlock) errorBlock{
    NSString *sinceAsString = NetworkDateFromDate(since);
    NSMutableDictionary *parameters = [@{@"status": @"all", @"since": sinceAsString, @"type": @"all"} mutableCopy];
    EHRServerRequest    *request = [EHRRequests requestWithRoute:@"/app/notification"
                                                         command:@"list" parameters:parameters];
    return [EHRCall callWithRequest:request onSuccess:successBlock onError:errorBlock];
}

//endregion

//region WF

//- (void)pullSinceDate:(NSDate *)date onSuccess:(VoidBlock)successBlock onError:(VoidBlock)errorBlock {
//    [[AppState sharedAppState].userModel.notificationsModel readFromServerWithSuccess:<#(VoidBlock)successBlock#> andError:<#(VoidBlock)errorBlock#>];
//}

- (void)pullForever:(VoidBlock)successBlock onError:(VoidBlock)errorBlock {
    VoidBlock datePullSuccess = ^{
        successBlock();
    };
    VoidBlock datePullError = ^{
        errorBlock();
    };
    [self pullSinceDate:forever() onSuccess:datePullSuccess onError:datePullError];
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