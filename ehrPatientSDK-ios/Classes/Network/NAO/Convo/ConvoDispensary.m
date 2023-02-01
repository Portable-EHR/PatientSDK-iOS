//
// Created by Yves Le Borgne on 2023-02-01.
//

#import "ConvoDispensary.h"

@interface ConvoDispensary () {
    NSInteger _instanceNumber;
    NSString  *_guid;
    NSString  *_name;
}
@end

@implementation ConvoDispensary

@synthesize name = _name;
@synthesize guid = _guid;

+ (id)objectWithContentsOfDictionary:(NSDictionary *)dic {
    ConvoDispensary *cd = [[self alloc] init];
    cd.name = WantStringFromDic(dic, @"name");
    cd.guid = WantStringFromDic(dic, @"guid");
    return cd;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    PutStringInDic(self.name, dictionary, @"name");
    PutStringInDic(self.guid, dictionary, @"guid");
    return dictionary;
}

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
    _name = nil;
    _guid = nil;
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end