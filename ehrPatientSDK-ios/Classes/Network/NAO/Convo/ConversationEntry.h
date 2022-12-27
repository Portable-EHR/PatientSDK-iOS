//
// Created by Yves Le Borgne on 2022-12-27.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRNetworkableP.h"
#import "ConversationEntryPayload.h"
#import "ConversationEntryStatus.h"

@class ConversationEntryPayload;

@interface ConversationEntry : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger                _instanceNumber;
    NSString                 *_id;
    NSString                 *_from;
    NSString                 *_type;
    NSString                 *_audience;
    NSInteger                _attachmentCount;
    NSArray                  *_status;
    ConversationEntryPayload *_payload;
    NSDate                   *_createdOn;
}

@property(nonatomic) NSString                 *id;
@property(nonatomic) NSString                 *from;
@property(nonatomic) NSString                 *type;
@property(nonatomic) NSString                 *audience;
@property(nonatomic) NSArray                  *status;
@property(nonatomic) NSInteger                attachmentCount;
@property(nonatomic) ConversationEntryPayload *payload;
@property(nonatomic) NSDate                   *createdOn;

@end