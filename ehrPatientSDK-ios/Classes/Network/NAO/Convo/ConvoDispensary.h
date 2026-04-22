//
// Created by Yves Le Borgne on 2023-02-01.
//

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "EHRInstanceCounterP.h"

@interface ConvoDispensary : NSObject <EHRInstanceCounterP, EHRPersistableP> {

}

@property(nonatomic) NSString            *name;
@property(nonatomic) NSString            *guid;
@property(nonatomic) NSMutableDictionary *entryPoints;

@end