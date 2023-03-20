//
// Created by Yves Le Borgne on 2023-01-08.
//

#import "EntryPartipantPayload.h"

@interface EntryPartipantPayload () {
    NSInteger _instanceNumber;
}
@end

@implementation EntryPartipantPayload

TRACE_OFF

@synthesize role, targetParticipantGuid, action;


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
    EntryPartipantPayload *pep = [[self alloc] init];
    pep.action= WantStringFromDic(dic, @"action");
    pep.role= WantStringFromDic(dic, @"role");
    pep.targetParticipantGuid= WantStringFromDic(dic, @"targetParticipantGuid");
    return pep;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.role, dic, @"role");
    PutStringInDic(self.action, dic, @"action");
    PutStringInDic(self.targetParticipantGuid, dic, @"targetParticipantGuid");
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


-(BOOL) __unused isAddAction {
    if (!self.action) return false;
    return [self.action isEqualToString:@"add"];
}

-(BOOL) __unused isRemoveAction {
    if (!self.action) return false;
    return [self.action isEqualToString:@"remove"];
}


-(BOOL) __unused isAssignAction{
    if (!self.action) return false;
    return [self.action isEqualToString:@"assign"];
}

-(BOOL) __unused isPartipantRole {
    if (!self.role) return false;
    return [self.action isEqualToString:@"partipant"];
}

-(BOOL) __unused isAdminPartipantRole{
    if (!self.role) return false;
    return [self.action isEqualToString:@"admin"];
}

@end