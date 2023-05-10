//
// Created by Yves Le Borgne on 2023-05-10.
//

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "EHRInstanceCounterP.h"

@interface IBPrivateMessageAttachment : NSObject <EHRInstanceCounterP,EHRPersistableP> {
    NSInteger _instanceNumber;
}

@property (nonatomic) NSString *b64;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *mimeType;

-(NSData*) decodedDocument;
@end