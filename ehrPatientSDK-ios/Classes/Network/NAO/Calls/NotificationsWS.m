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

- (EHRCall *)setSeen:(PatientNotification *)notification
           onSuccess:(SenderBlock)successBlock
             onError:(SenderBlock)errorBlock {
    NSMutableDictionary *params  = [@{@"guids": @[notification.guid]} mutableCopy];
    EHRServerRequest    *request = [EHRRequests requestWithRoute:@"/app/notification"
                                                         command:@"seen" parameters:params];
    return [EHRCall callWithRequest:request onSuccess:successBlock onError:errorBlock];
}

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