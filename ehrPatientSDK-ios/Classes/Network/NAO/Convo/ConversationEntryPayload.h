//
// Created by Yves Le Borgne on 2022-12-27.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRNetworkableP.h"

@interface ConversationEntryPayload : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
    NSString  *_text;
    NSArray   *_attachments;
}

@property(nonatomic) NSString *text;
@property(nonatomic) NSArray  *attachments;

@end