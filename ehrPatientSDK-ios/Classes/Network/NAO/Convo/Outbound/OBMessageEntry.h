//
// Created by Yves Le Borgne on 2023-02-18.
//

#import <Foundation/Foundation.h>
#import "EHRNetworkableP.h"
#import "OBMessageEntryAttachment.h"

@interface OBMessageEntry : NSObject <EHRInstanceCounterP, EHRPersistableP> {

}

@property(nonatomic) NSString       *text;
@property(nonatomic) NSMutableArray *attachments;

@end