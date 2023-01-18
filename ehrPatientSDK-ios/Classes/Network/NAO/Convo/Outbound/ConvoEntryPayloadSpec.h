//
// Created by Yves Le Borgne on 2023-01-04.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import "GERuntimeConstants.h"
#import "EHRNetworkableP.h"
#import "EHRInstanceCounterP.h"

@interface ConvoEntryPayloadSpec : NSObject <EHRNetworkableP, EHRInstanceCounterP> {

}

+ (instancetype)default __attribute__((unused));

@property(nonatomic) NSString *text;
@end