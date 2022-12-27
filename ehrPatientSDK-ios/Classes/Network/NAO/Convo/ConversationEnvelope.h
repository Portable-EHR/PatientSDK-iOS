//
// Created by Yves Le Borgne on 2022-12-27.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRNetworkableP.h"

@interface ConversationEnvelope : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
    NSString  *_guid;
    NSString  *_status;
    NSString  *_location;
    NSString  *_staffTitle;
    NSString  *_clientTitle;
    NSString  *_teaser;
    NSDate    *_lastUpdated;
}

@property(nonatomic) NSString *guid;
@property(nonatomic) NSString *status;
@property(nonatomic) NSString *location;
@property(nonatomic) NSString *staffTitle;
@property(nonatomic) NSString *clientTitle;
@property(nonatomic) NSString *teaser;
@property(nonatomic) NSDate   *lastUpdated;

@end