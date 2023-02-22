//
// Created by Yves Le Borgne on 2023-02-18.
//

#import <Foundation/Foundation.h>
#import "EHRNetworkableP.h"

@interface OBMessageEntryAttachment : NSObject <EHRInstanceCounterP, EHRNetworkableP> {

}

+(instancetype) name:(NSString*) humanName mimeType:(NSString*) mimeType data:(NSData*) data;
+(instancetype) name:(NSString*) humanName mimeType:(NSString*) mimeType b64:(NSString*) data;

@property(nonatomic) NSString *mimeType;
@property(nonatomic) NSString *b64;
@property(nonatomic) NSString *name;
@end