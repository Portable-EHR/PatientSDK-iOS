//
// Created by Yves Le Borgne on 2022-12-28.
//

#import <Foundation/Foundation.h>
#import "GERuntimeConstants.h"
#import "EHRCall.h"

@class EHRCall;

@interface ConvoCallMux : NSObject<EHRInstanceCounterP> {
    NSInteger _instanceNumber;
}

- (EHRCall *) __unused  getAddConvoEntryCall;
- (EHRCall *) __unused  getCreateConvoCall;
- (EHRCall *) __unused  getSetConvoDetailCall;
- (EHRCall *) __unused  getConvoDispensariesCall;
- (EHRCall *) __unused  getConvoEntriesCall;
- (EHRCall *) __unused  getConvoEnvelopesCall;
- (EHRCall *) __unused  getEntryAttachmentCall;
- (EHRCall *) __unused  getEntryPointsCall;



@end
