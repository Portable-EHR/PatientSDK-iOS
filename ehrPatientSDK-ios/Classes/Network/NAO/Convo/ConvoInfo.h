//
// Created by Yves Le Borgne on 2022-12-31.
//

#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "EHRNetworkableP.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

@interface ConvoInfo : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
    NSString  *_guid;
    NSString  *_teaser;
    NSString  *_clientTitle;
    NSDate    *_lastUpdated;
}

@property(nonatomic) NSString *clientTitle;
@property(nonatomic) NSString *teaser;
@property(nonatomic) NSDate   *lastUpdated;
@property(nonatomic) NSString *guid;

@end