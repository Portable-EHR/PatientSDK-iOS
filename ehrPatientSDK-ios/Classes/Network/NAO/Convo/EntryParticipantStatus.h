//
// Created by Yves Le Borgne on 2022-12-27.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "EHRNetworkableP.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

typedef enum : NSInteger {
    EntryProgressSent     = 0,
    EntryProgressReceived = 1,
    EntryProgressRead     = 2,
    EntryProgressAcked    = 3,
    EntryProgressInvalid  = -1
} EntryProgress;

@interface EntryParticipantStatus : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
    NSString  *_participantId;
    NSString  *_entryId;
    NSString  *_status;
    NSDate    *_date;

}

@property(nonatomic) NSString      *participantId;
@property(nonatomic) NSString      *entryId;
@property(nonatomic) NSString      *status;
@property(nonatomic) NSDate        *date;
@property(nonatomic) EntryProgress progress;

- (BOOL)isSent __unused;
- (BOOL)isReceived __unused;
- (BOOL)isRead __unused;
- (BOOL)isAcknowledged __unused;

@end