//
// Created by Yves Le Borgne on 2016-03-04.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"

@class PatientNotification;
@class IBMessageDistribution;

@interface MessageDistributionProgressChange : NSObject <EHRInstanceCounterP> {
    NSInteger _instanceNumber;

}
@property(nonatomic) IBMessageDistribution *messageDistribution;
@property(nonatomic) NSDate                *date;
@property(nonatomic) NSString              *progress;  // seen|acked|archived

+ (MessageDistributionProgressChange *)messageDistribution:(IBMessageDistribution *)seq to:(NSString *)progress;
- (NSDictionary *)asNetworkObject;

@end