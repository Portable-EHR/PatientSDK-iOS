//
// Created by Yves Le Borgne on 2023-01-02.
//

#import <Foundation/Foundation.h>
#import "GERuntimeConstants.h"
#import "IBDeviceInfo.h"
#import "SecureCredentials.h"
#import "EHRCall.h"
#import "EHRServerResponse.h"

@class PatientNotification;

@interface NotificationsWS : NSObject <EHRInstanceCounterP> {

}

//region calls

-(EHRCall*) getListCall:(NSDate*) since onSuccess:(SenderBlock) successBlock onError:(SenderBlock) errorBlock;

- (EHRCall *)__unused  setSeen:(PatientNotification *)
        notification onSuccess:(SenderBlock)successBlock
                       onError:(SenderBlock)errorBlock;

//endregion

//region WF


-(void) pullSinceDate:(NSDate*) date onSuccess:(VoidBlock) successBlock onError:(VoidBlock) errorBlock ;

-(void) pullForever:(VoidBlock) successBlock onError:(VoidBlock) errorBlock;


//endregion

@end