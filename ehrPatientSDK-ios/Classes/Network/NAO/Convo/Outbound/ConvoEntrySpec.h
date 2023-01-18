//
// Created by Yves Le Borgne on 2023-01-04.
//

#import <Foundation/Foundation.h>
#import "GERuntimeConstants.h"
#import "EHRNetworkableP.h"
#import "EHRInstanceCounterP.h"

@class ConvoEntryPayloadSpec;

@interface ConvoEntrySpec : NSObject <EHRNetworkableP, EHRInstanceCounterP> {

}

+ (instancetype)default;

@property(nonatomic) NSString              *type;
@property(nonatomic) NSString              *audience;
@property(nonatomic) NSInteger             attachmentCount;
@property(nonatomic) ConvoEntryPayloadSpec *payload;
@property(nonatomic) NSDate                *createdOn;

@end