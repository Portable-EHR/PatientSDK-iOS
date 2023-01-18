//
// Created by Yves Le Borgne on 2023-01-05.
//

#import <Foundation/Foundation.h>
#import "GERuntimeConstants.h"
#import "EHRNetworkableP.h"
#import "EHRInstanceCounterP.h"

@class ConvoEntrySpec;
@class Conversation;

@interface ConvoEntryAddSpec : NSObject <EHRNetworkableP, EHRInstanceCounterP> {

}

+(instancetype) defaultForConvo:(Conversation*) conversation __attribute__((unused));

@property(nonatomic) NSString *id;
@property(nonatomic) ConvoEntrySpec *entry;

@end