//
// Created by Yves Le Borgne on 2022-12-27.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "EHRNetworkableP.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

@interface ConversationParticipant : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
    NSString  *_guid;
    NSString  *_participantId;
    NSString  *_type;
    NSString  *_role;
    NSDate    *_addedOn;
    NSString  *_name;
    NSString  *_firstName;
    NSString  *_middleName;
    BOOL      _mySelf;
}

@property(nonatomic) NSString           *guid;
@property(nonatomic) NSString           *participantId;
@property(nonatomic) NSString           *type;
@property(nonatomic) NSString           *role;
@property(nonatomic) NSDate             *addedOn;
@property(nonatomic) NSString           *name;
@property(nonatomic) NSString           *middleName;
@property(nonatomic) NSString           *firstName;
@property(nonatomic) BOOL               mySelf;
@property(nonatomic, readonly) NSString *fullName;
@property(nonatomic, readonly) NSString *shortName;
@end