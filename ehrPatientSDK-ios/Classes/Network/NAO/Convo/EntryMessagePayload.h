//
// Created by Yves Le Borgne on 2022-12-27.
//

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "EHRNetworkableP.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

@interface EntryMessagePayload : NSObject <EHRInstanceCounterP, EHRNetworkableP> {
    NSInteger _instanceNumber;
    NSString  *_text;
    NSString  *_freeTextReply;
    NSString  *_dateReply;
    NSString  *_dateTimeReply;
    NSDictionary   *_choiceReply;
    NSArray   *_attachments;
}

@property(nonatomic) NSString *text;
@property(nonatomic) NSArray  *attachments;
@property(nonatomic) NSString *freeTextReply;
@property(nonatomic) NSString *dateReply;
@property(nonatomic) NSString *dateTimeReply;
@property(nonatomic) NSDictionary  *choiceReply;
@end
