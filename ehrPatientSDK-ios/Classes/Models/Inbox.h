//
// Created by Yves Le Borgne on 2019-08-31.
// Copyright (c) 2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Inbox : NSObject {

    NSInteger _instanceNumber;
    NSString * _pobox;
    NSDictionary *_allNotifications;
    NSDictionary *_inboxNotifications;

}


-(void) refreshContent;

@end