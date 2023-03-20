//
// Created by Yves Le Borgne on 2023-01-04.
//

#import <Foundation/Foundation.h>
#import "GERuntimeConstants.h"
#import "EHRNetworkableP.h"
#import "EHRInstanceCounterP.h"
#import "EntryPartipantPayload.h"

@interface OBEntry : NSObject <EHRNetworkableP, EHRInstanceCounterP> {

}

+ (instancetype)default;
+ (instancetype)withParticipantPayload:(EntryPartipantPayload *)payload;

@property(nonatomic) NSString             *type;
@property(nonatomic) NSString             *audience;
@property(nonatomic) id <EHRPersistableP> payload;

@end