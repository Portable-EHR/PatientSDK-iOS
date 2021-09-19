//
// Created by Yves Le Borgne on 2016-03-04.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"

@class PatientNotification;

@interface NotificationProgressChange : NSObject <EHRInstanceCounterP>{
    NSInteger _instanceNumber;

}
@property(nonatomic) PatientNotification *notification;
@property(nonatomic) NSDate   *date;
@property(nonatomic) NSString *progress;  // seen|acknowledged|archived

+(NotificationProgressChange *)notification:(PatientNotification *)seq to:(NSString *)progress;
-(NSDictionary *) asNetworkObject;

@end