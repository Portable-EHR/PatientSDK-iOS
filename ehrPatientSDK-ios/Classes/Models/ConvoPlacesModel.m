//
// Created by Yves Le Borgne on 2023-01-28.
//

#import "ConvoPlacesModel.h"

@interface ConvoPlacesModel(){
    NSInteger _instanceNumber;
}
@end

@implementation ConvoPlacesModel

TRACE_ON

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end