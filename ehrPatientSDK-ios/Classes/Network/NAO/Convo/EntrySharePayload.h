//
// Created by Yves Le Borgne on 2023-02-25.
//

#import <Foundation/Foundation.h>
#import "EHRNetworkableP.h"

@interface EntrySharePayload : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
}

@property(nonatomic) NSString *id;
@property(nonatomic) NSString *text;
@property(nonatomic) NSString *type;

@property(nonatomic) BOOL isPrivateMessage;

@end