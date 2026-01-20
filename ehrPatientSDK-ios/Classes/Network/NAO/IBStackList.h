//
//  IBStackList.h
//  EHRPatientSDK
//
//  Created by Vinay on 2025-10-08.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRNetworkableP.h"
#import "IBStackName.h"

@interface IBStackList : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
    NSString    *_key;
    IBStackName *_name;
    NSString    *_oamp_scheme;
    NSString    *_oamp_host;
    NSInteger   _oamp_port;
}

@property(nonatomic) NSString *key;
@property(nonatomic) IBStackName *name;
@property(nonatomic) NSString *oamp_scheme;
@property(nonatomic) NSString *oamp_host;
@property(nonatomic) NSInteger oamp_port;
@end

