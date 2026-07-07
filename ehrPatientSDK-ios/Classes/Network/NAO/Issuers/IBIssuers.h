//
//  IBIssuers.h
//  EHRPatientSDK
//
//  Created by Vinay on 2026-06-19.
//



#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRNetworkableP.h"
#import "IBDescription.h"

@interface IBIssuers : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
//    NSInteger _instanceNumber;
    NSString      *_kind;
    NSString      *_alias;
    NSString      *_issuer;
    NSString      *_country;
    NSString      *_state;
    NSString      *_guid;
    IBDescription *_issuerDescription;
}

@property(nonatomic) NSString *kind;
@property(nonatomic) NSString *alias;
@property(nonatomic) NSString *issuer;
@property(nonatomic) NSString *country;
@property(nonatomic) NSString *state;
@property(nonatomic) NSString *guid;
@property(nonatomic, strong) IBDescription *issuerDescription;
@end

