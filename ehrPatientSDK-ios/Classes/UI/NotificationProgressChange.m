//
// Created by Yves Le Borgne on 2016-03-04.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "NotificationProgressChange.h"
#import "PatientNotification.h"

@implementation NotificationProgressChange

TRACE_OFF

-(id) init {
    if ((self=[super init])){
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else{
        TRACE(@"*** Super returned nil !");
    }
    return self;
}

+(NotificationProgressChange *)notification:(PatientNotification *)seq to:(NSString *)progress {

    NotificationProgressChange *ch = [[self alloc] init];
    ch.notification=seq;
    ch.progress= progress;
    ch.date=[NSDate date];
    return ch;

}

-(NSDictionary *)asNetworkObject {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.notification.guid,dic,@"guid");
    PutStringInDic(self.progress,dic,@"progress");
    PutDateInDic(self.date,dic,@"date");
    return dic;
}


-(void) dealloc{

    GE_DEALLOC();
    GE_DEALLOC_ECHO();

}

@end