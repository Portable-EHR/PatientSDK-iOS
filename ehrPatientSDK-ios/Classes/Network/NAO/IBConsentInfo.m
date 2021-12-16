//
//  IBConsentInfo.m
//  ehrPatientSDK-ios
//
//

#import <Foundation/Foundation.h>
#import "GEDeviceHardware.h"
#import "IBAppSummary.h"
#import "IBConsentInfo.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@implementation IBConsentInfo

@synthesize renderer = _renderer;
@synthesize text = _text;
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
    _renderer   = nil;
    _text    = nil;
}

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {

    IBConsentInfo *pa = [[self alloc] init];
    pa->_renderer                                        = WantStringFromDic(dic, @"renderer");
    pa->_text                                            = WantStringFromDic(dic, @"text");
    return pa;
}

- (NSDictionary *)asDictionary {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.renderer, dic, @"renderer");
    PutStringInDic(self.text, dic, @"text");
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
#pragma clang diagnostic pop
