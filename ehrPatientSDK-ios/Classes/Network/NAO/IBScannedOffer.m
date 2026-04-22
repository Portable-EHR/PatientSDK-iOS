//
// Created by Yves Le Borgne on 2023-04-05.
//

#import "IBScannedOffer.h"

@implementation IBScannedOffer

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
    _scanReasonCode = nil;
    _scannedHost    = nil;
    _scanReasonCode = nil;
}

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {

    IBScannedOffer *pa = [[self alloc] init];
    pa.scannedCode    = WantStringFromDic(dic, @"scannedCode");
    pa.scannedHost    = WantStringFromDic(dic, @"scannedHost");
    pa.scanReasonCode = WantStringFromDic(dic, @"scanReasonCode");
    return pa;
}

- (NSDictionary *)asDictionary {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.scannedHost, dic, @"scannedHost");
    PutStringInDic(self.scannedCode, dic, @"scannedCode");
    PutStringInDic(self.scanReasonCode, dic, @"scanReasonCode");
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

@end