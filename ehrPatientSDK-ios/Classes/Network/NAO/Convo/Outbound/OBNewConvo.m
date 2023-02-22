//
// Created by Yves Le Borgne on 2023-02-17.
//

#import "OBNewConvo.h"

@interface OBNewConvo(){
    NSInteger _instanceNumber;
}
@end

@implementation OBNewConvo






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

+ (id)objectWithContentsOfDictionary:(NSDictionary *)dic {
    OBNewConvo *oc = [[self alloc] init];
    oc.dispensary= WantStringFromDic(dic, @"dispensary");
    oc.entryPoint = WantStringFromDic(dic, @"entryPoint");
    oc.title = WantStringFromDic(dic, @"title");
    NSDictionary *entryAsDic = WantDicFromDic(dic, @"entry");
    if (entryAsDic) {
        oc.entry=[OBEntry objectWithContentsOfDictionary:entryAsDic];
    }
    return oc;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.dispensary, dic, @"dispensary");
    PutStringInDic(self.entryPoint, dic, @"entryPoint");
    PutStringInDic(self.title, dic, @"title");
    PutPersistableInDic(self.entry, dic, @"entry");
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

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end