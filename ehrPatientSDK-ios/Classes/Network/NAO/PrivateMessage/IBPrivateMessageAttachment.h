//
//  IBPrivateMessageAttachment.h
//  EHRPatientSDK
//
//  Created by Vinay on 2023-10-30.
//

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "EHRInstanceCounterP.h"

@interface IBPrivateMessageAttachment : NSObject <EHRInstanceCounterP, EHRPersistableP> {
    NSInteger _instanceNumber;
}

@property(nonatomic) NSString *b64;
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *mimeType;
@property(nonatomic) NSDate *date;

- (NSData *)decodedDocument;
@end
