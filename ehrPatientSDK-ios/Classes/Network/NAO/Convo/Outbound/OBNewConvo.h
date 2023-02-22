//
// Created by Yves Le Borgne on 2023-02-17.
//

#import <Foundation/Foundation.h>
#import "OBEntry.h"

@class OBEntry;

@interface OBNewConvo : NSObject <EHRInstanceCounterP, EHRNetworkableP> {

}

@property(nonatomic) NSString *dispensary;
@property(nonatomic) NSString *entryPoint;
@property(nonatomic) NSString *title;
@property(nonatomic) OBEntry  *entry;

@end