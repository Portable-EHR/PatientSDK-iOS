//
// Created by Yves Le Borgne on 2022-12-27.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "EHRNetworkableP.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"
#import "EntryMessagePayload.h"
#import "EntryParticipantStatus.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wignored-attributes"
@class EntryMessagePayload;

@interface ConversationEntry : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger                         _instanceNumber;
    NSString                          *_id;
    NSString                          *_from;
    NSString                          *_type;
    NSString                          *_audience;
    NSInteger                         _attachmentCount;
    NSArray<EntryParticipantStatus *> *_status;
    EntryMessagePayload               *_messageEntryPayload;
    NSDate                            *_createdOn;
}

@property(nonatomic) NSString                          *id;
@property(nonatomic) NSString                          *from;
@property(nonatomic) NSString                          *type;
@property(nonatomic) NSString                          *audience __unused;
@property(nonatomic) NSArray<EntryParticipantStatus *> *status;
@property(nonatomic) NSInteger                         attachmentCount __unused;
@property(nonatomic) id                                payload __unused;
@property(nonatomic) NSDate                            *createdOn;
@property(nonatomic, readonly) BOOL                    isMessageType;
@property(nonatomic, readonly) BOOL                    isParticipantType;
@property(nonatomic, readonly) BOOL                    isMoveType;
@property(nonatomic, readonly) BOOL                    isStatusChangeType;
@property(nonatomic, readonly) BOOL                    isShareType __unused;

@end

#pragma clang diagnostic pop