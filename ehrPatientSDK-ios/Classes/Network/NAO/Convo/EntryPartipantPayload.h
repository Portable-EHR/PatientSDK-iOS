//
// Created by Yves Le Borgne on 2023-01-08.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "EHRNetworkableP.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

@interface EntryPartipantPayload : NSObject <EHRInstanceCounterP, EHRNetworkableP> {

}

@property(nonatomic) NSString *targetParticipantGuid;
@property(nonatomic) NSString *role;
@property(nonatomic) NSString *action;

@property(nonatomic, readonly) BOOL isAddAction;
@property(nonatomic, readonly) BOOL isRemoveAction;
@property(nonatomic, readonly) BOOL isAssignAction;
@property (nonatomic, readonly) BOOL isAdminPartipantRole;
@property  (nonatomic, readonly) BOOL isPartipantRole ;
@end