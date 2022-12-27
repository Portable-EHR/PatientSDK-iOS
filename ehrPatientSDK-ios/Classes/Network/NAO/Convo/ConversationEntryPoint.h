//
// Created by Yves Le Borgne on 2022-12-27.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "EHRNetworkableP.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

@interface ConversationEntryPoint : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
    NSString  *_id;
    NSString  *_name;
    NSString  *_descriptionText;
}
@property(nonatomic) NSString *id;
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *descriptionText;
@end