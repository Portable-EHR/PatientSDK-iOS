//
// Created by Yves Le Borgne on 2022-12-27.
//

#import <Foundation/Foundation.h>

@interface ConversationEntryStatus : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
    NSString  *_participantId;
    NSString  *_entryId;
    NSString  *_status;
    NSDate    *_date;

}

@property(nonatomic) NSString *participantId;
@property(nonatomic) NSString *entryId;
@property(nonatomic) NSString *status;
@property(nonatomic) NSDate   *date;

@end