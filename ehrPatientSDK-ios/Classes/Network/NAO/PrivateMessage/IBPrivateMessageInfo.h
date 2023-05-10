//
// Created by Yves Le Borgne on 2023-05-10.
//

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "EHRInstanceCounterP.h"

@interface IBPrivateMessageInfo : NSObject <EHRInstanceCounterP,EHRPersistableP> {
    NSInteger _instanceNumber;
}

@property (nonatomic) NSString *guid;
@property (nonatomic) NSString *source;
@property (nonatomic) NSDate *createdOn;
@property (nonatomic) NSDate *seenOn;
@property (nonatomic) NSString *author;
@property (nonatomic) NSDate *acknowledgedOn;

@property (readonly) BOOL isAcknowledged __unused;
@property (readonly) NSString* getAuthor __unused;


@end