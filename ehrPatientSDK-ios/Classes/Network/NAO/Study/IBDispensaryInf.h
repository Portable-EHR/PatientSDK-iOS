//
//  IBDispensaryInf.h
//  EHRPatientSDK
//
//  Created by Vinay on 2025-01-07.
//

#ifndef IBDispensaryInf_h
#define IBDispensaryInf_h

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "EHRInstanceCounterP.h"

@interface IBDispensaryInf : NSObject <EHRInstanceCounterP,EHRPersistableP> {
    NSInteger _instanceNumber;
}

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *landPhone;
@property (nonatomic) NSString *url;

@end


#endif /* IBDispensaryInf_h */
