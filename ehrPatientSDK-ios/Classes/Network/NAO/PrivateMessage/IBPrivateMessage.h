//
// Created by Yves Le Borgne on 2023-05-10.
//

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "EHRInstanceCounterP.h"

@class IBPrivateMessageAttachment;

@interface IBPrivateMessage : NSObject <EHRInstanceCounterP, EHRPersistableP> {
    NSInteger _instanceNumber;
}

@property(nonatomic) NSString *subject;
@property(nonatomic) NSString *from;
@property(nonatomic) NSString *patient;
@property(nonatomic) NSString *to;
@property(nonatomic) NSDate   *date;
@property(nonatomic) NSString *message;
@property(nonatomic) NSString *source;
@property(nonatomic) NSString *sourceShortName;
@property(nonatomic) NSArray<IBPrivateMessageAttachment *> *attachments;

@end