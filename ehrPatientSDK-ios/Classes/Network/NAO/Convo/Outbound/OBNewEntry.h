//
// Created by Yves Le Borgne on 2023-01-05.
//

#import <Foundation/Foundation.h>
#import "GERuntimeConstants.h"
#import "EHRNetworkableP.h"
#import "EHRInstanceCounterP.h"
#import "OBEntry.h"
#import "Conversation.h"

@interface OBNewEntry : NSObject <EHRNetworkableP, EHRInstanceCounterP> {

}

+(instancetype) defaultForConvo:(Conversation*) conversation __attribute__((unused));

@property(nonatomic) NSString *id;
@property(nonatomic) OBEntry  *entry;

@end