//
// Created by Yves Le Borgne on 2022-12-28.
//

#import "ConvoCallMux.h"

@implementation ConvoCallMux

TRACE_OFF

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

//region calls

- (EHRCall *) __unused  getAddConvoEntryCall{
    return nil;
}

- (EHRCall *) __unused  getCreateConvoCall{
    return nil;
}

- (EHRCall *) __unused  getSetConvoDetailCall{
    return nil;
}

- (EHRCall *) __unused  getConvoDispensariesCall{
    return nil;
}

- (EHRCall *) __unused  getConvoEntriesCall{
    return nil;
}

- (EHRCall *) __unused  getConvoEnvelopesCall{
    return nil;
}

- (EHRCall *) __unused  getEntryAttachmentCall{
    return nil;
}

- (EHRCall *) __unused  getEntryPointsCall{
    return nil;
}



//endregion



- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end