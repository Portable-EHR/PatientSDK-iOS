//
// Created by Yves Le Borgne on 2022-12-27.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "EHRNetworkableP.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

@interface Conversation : NSObject <EHRInstanceCounterP, EHRNetworkableP>  {
    NSInteger _instanceNumber;

    NSString *_id;
    NSString *_status;
    NSString *_location;
    NSString *_staffTitle;
    NSString *_clientTitle;

    NSArray *_participants;
    NSArray *_entries;

}

@property(nonatomic) NSString *staffTitle;
@property(nonatomic) NSString *clientTitle;
@property(nonatomic) NSString *id;
@property(nonatomic) NSString *status;
@property(nonatomic) NSString *location;
@property(nonatomic) NSArray  *participants;
@property(nonatomic) NSArray  *entries;

@end