//
//  IBDispensaryInf.m
//  EHRPatientSDK
//
//  Created by Vinay on 2025-01-07.
//


#import "IBDispensaryInf.h"
#import "GERuntimeConstants.h"

@implementation IBDispensaryInf

TRACE_OFF

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        MPLOG(@"*** super returns nil!");
    }
    return self;
}

#pragma mark - EHRPersistableP

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)theDictionary {
    IBDispensaryInf *disp = [[IBDispensaryInf alloc] init];
    disp.name                     = WantStringFromDic(theDictionary, @"name");
    disp.landPhone                     = WantStringFromDic(theDictionary, @"landPhone");
    disp.url                     = WantStringFromDic(theDictionary, @"url");

    return disp;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    PutStringInDic(self.name, dic, @"name");
    PutStringInDic(self.landPhone, dic, @"landPhone");
    PutStringInDic(self.url, dic, @"url");
    
    return dic;
}

+ (instancetype)objectWithJSON:(NSString *)jsonString {
    NSDictionary *dic = [NSDictionary dictionaryWithJSON:jsonString];
    return [self objectWithContentsOfDictionary:dic];
}

+ (instancetype)objectWithJSONdata:(NSData *)jsonData {
    NSDictionary *dic = [NSDictionary dictionaryWithJSONdata:jsonData];
    return [self objectWithContentsOfDictionary:dic];
}

- (NSString *)asJSON {
    return [[self asDictionary] asJSON];
}

- (NSData *)asJSONdata {
    return [[self asDictionary] asJSONdata];
}


- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}
@end
