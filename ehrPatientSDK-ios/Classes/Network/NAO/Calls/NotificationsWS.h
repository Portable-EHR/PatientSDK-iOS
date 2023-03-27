//
// Created by Yves Le Borgne on 2023-01-02.
//

#import <Foundation/Foundation.h>
#import "GERuntimeConstants.h"

@class EHRCall;
@class PatientNotification;

@interface NotificationsWS : NSObject <EHRInstanceCounterP> {

}

- (EHRCall *)__unused  setSeen:(PatientNotification *)
        notification onSuccess:(SenderBlock)successBlock
                       onError:(SenderBlock)errorBlock;

@end