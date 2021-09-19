//
// Created by Yves Le Borgne on 2016-03-04.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "MessageDistributionProgressChange.h"
#import "PatientNotification.h"
#import "IBMessageDistribution.h"

@implementation MessageDistributionProgressChange

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

+(MessageDistributionProgressChange *)messageDistribution:(IBMessageDistribution *)seq to:(NSString *)progress {

    MessageDistributionProgressChange *ch = [[self alloc] init];
    ch.messageDistribution=seq;
    ch.progress= progress;
    ch.date=[NSDate date];
    return ch;

}

-(NSDictionary *)asNetworkObject {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.messageDistribution.guid,dic,@"guid");
    PutStringInDic(self.progress,dic,@"progress");
    PutDateInDic(self.date,dic,@"date");
    return dic;
}


-(void) dealloc{

    GE_DEALLOC();
    GE_DEALLOC_ECHO();

}

@end