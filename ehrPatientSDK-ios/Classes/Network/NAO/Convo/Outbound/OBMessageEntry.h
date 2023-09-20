//
// Created by Yves Le Borgne on 2023-02-18.
//

#import <Foundation/Foundation.h>
#import "EHRNetworkableP.h"
#import "OBMessageEntryAttachment.h"
#import "OBChoiceReplyEntry.h"

@interface OBMessageEntry : NSObject <EHRInstanceCounterP, EHRPersistableP> {

}

@property(nonatomic) NSString           *text;
@property(nonatomic) NSMutableArray     *attachments;
// Task Messages Reply Button Changes
@property(nonatomic) NSString           *freeTextReply;
@property(nonatomic) NSString           *dateReply;
@property(nonatomic) NSString           *dateTimeReply;
@property(nonatomic) OBChoiceReplyEntry *choiceReply;

@end
