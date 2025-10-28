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
    
}

@property(nonatomic) NSString *key;
@property(nonatomic) IBStackName *name;
@end

