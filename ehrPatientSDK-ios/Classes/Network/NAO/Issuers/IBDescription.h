//
//  IBDescription.h
//  EHRPatientSDK
//
//  Created by Vinay on 2026-06-22.
//

#ifndef IBDescription_h
#define IBDescription_h

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRNetworkableP.h"

@interface IBDescription : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
}

@property(nonatomic) NSString *en;
@property(nonatomic) NSString *es;
@property(nonatomic) NSString *fr;
@property(nonatomic) NSString *de;
@end

#endif /* IBDescription_h */
