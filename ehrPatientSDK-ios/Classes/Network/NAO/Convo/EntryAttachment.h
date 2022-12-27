//
// Created by Yves Le Borgne on 2022-12-27.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRNetworkableP.h"

@interface EntryAttachment : NSObject <EHRInstanceCounterP,EHRNetworkableP> {
    NSInteger _instanceNumber;
}
@end