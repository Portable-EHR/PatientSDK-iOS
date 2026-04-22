//
// Created by Yves Le Borgne on 2023-01-08.
//

#import "EntryStatusChangePayload.h"
#import "GERuntimeConstants.h"

@interface EntryStatusChangePayload () {
    NSInteger _instanceNumber;
}
@end

@implementation EntryStatusChangePayload

TRACE_OFF

@synthesize fromStatus;
@synthesize toStatus;
@synthesize wasOpened;
@synthesize wasClosed;

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

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    EntryStatusChangePayload *escp = [[self alloc] init];
    escp.fromStatus = WantStringFromDic(dic, @"fromStatus");
    escp.toStatus   = WantStringFromDic(dic, @"toStatus");
    return escp;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.fromStatus, dic, @"fromStatus");
    PutStringInDic(self.toStatus, dic, @"toStatus");
    return dic;
}

- (NSString *)asJSON {
    return [[self asDictionary] asJSON];
}

- (NSData *)asJSONdata {
    return [[self asDictionary] asJSONdata];
}

+ (instancetype)objectWithJSONdata:(NSData *)jsonData {
    NSDictionary *dic = [NSDictionary dictionaryWithJSONdata:jsonData];
    return [self objectWithContentsOfDictionary:dic];
}

+ (instancetype)objectWithJSON:(NSString *)jsonString {
    NSDictionary *dic = [NSDictionary dictionaryWithJSON:jsonString];
    return [self objectWithContentsOfDictionary:dic];
}

-(BOOL)wasOpened {
    return [self.toStatus isEqualToString:@"open"];
}
-(BOOL)wasClosed {
    return [self.toStatus isEqualToString:@"closed"];
}

@end