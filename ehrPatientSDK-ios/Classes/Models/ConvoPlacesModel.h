//
// Created by Yves Le Borgne on 2023-01-28.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"

@interface ConvoPlacesModel : NSObject <EHRInstanceCounterP> {

}

@property(nonatomic, readonly) NSDictionary *dispensaries;
@property(nonatomic, readonly) NSDictionary *entryPoints;

- (void)refresh:(VoidBlock)successBlock onError:(VoidBlock)errorBlock;

@end