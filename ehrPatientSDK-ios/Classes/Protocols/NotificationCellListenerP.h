//
// Created by yvesleborg on 2020-03-12
//
// // Copyright (c) 2015-2020 Portable EHR inc. All rights reserved.
//

typedef enum : NSUInteger {
    NotificationCellDispositionPresentPayload,
    NotificationCellDispositionPresentHelp,
    NotificationCellDispositionArchive,
    NotificationCellDispositionUnarchive,
    NotificationCellDispositionDelete
} NotificationCellDisposition;

#import <Foundation/Foundation.h>

@class PatientNotification;

@protocol NotificationCellListenerP <NSObject>

-(void) disposeOf :(PatientNotification *) notification with:(NotificationCellDisposition) disposition;

@end