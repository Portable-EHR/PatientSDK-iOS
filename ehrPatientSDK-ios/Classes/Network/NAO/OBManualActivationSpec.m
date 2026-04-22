//
// Created by Yves Le Borgne on 2023-04-05.
//

#import "OBManualActivationSpec.h"

@implementation OBManualActivationSpec

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

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

+ (id)objectWithContentsOfDictionary:(NSDictionary *)dic {
    OBManualActivationSpec *spec = [[self alloc] init];
    spec.HCIN = WantStringFromDic(dic, @"HCIN");
    spec.HCINjurisdiction = WantStringFromDic(dic, @"HCINjurisdiction");
    spec.mobilePhone = WantStringFromDic(dic, @"mobilePhone");
    spec.email = WantStringFromDic(dic, @"email");
    return nil;
}

- (NSDictionary *)asDictionary {
    return [self asMutableDictionary];
}

-(NSMutableDictionary*) asMutableDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    PutStringInDic(self.HCIN, dictionary, @"HCIN");
    PutStringInDic(self.HCINjurisdiction, dictionary, @"HCINjurisdiction");
    PutStringInDic(self.mobilePhone, dictionary, @"mobilePhone");
    PutStringInDic(self.email, dictionary, @"email");
    return dictionary;
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

@end