//
// Created by Yves Le Borgne on 2022-12-27.
//

#import "ConversationEntryPoint.h"

@implementation ConversationEntryPoint

TRACE_OFF

-(instancetype) init {
    if ((self = [super init])){
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        MPLOG(@"*** super returns nil!");
    }
    return self;
}


+ (id)objectWithJSON:(NSString *)jsonString {
    return nil;
}

+ (id)objectWithJSONdata:(NSData *)jsonData {
    return nil;
}

- (NSData *)asJSONdata {
    return nil;
}

- (NSString *)asJSON {
    return nil;
}

+ (id)objectWithContentsOfDictionary:(NSDictionary *)dic {
    return nil;
}

- (NSDictionary *)asDictionary {
    return nil;
}

-(void) dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end