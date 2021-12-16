//
//  IBConsentGranted.m
//  ehrPatientSDK-ios
//
//

#import <Foundation/Foundation.h>
#import "GEDeviceHardware.h"
#import "IBAppSummary.h"
#import "IBConsentGranted.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@implementation IBConsentGranted

@synthesize guid = _guid;
@synthesize user_guid = _user_guid;
@synthesize patient_guid = _patient_guid;
@synthesize givenOn = _givenOn;
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
    _guid   = nil;
    _user_guid   = nil;
    _patient_guid   = nil;
    _givenOn    = nil;
}

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {

    IBConsentGranted *pa = [[self alloc] init];
    pa->_guid                                               = WantStringFromDic(dic, @"guid");
    pa->_user_guid                                          = WantStringFromDic(dic, @"user_guid");
    pa->_patient_guid                                       = WantStringFromDic(dic, @"patient_guid");
    pa->_givenOn                                            = WantStringFromDic(dic, @"givenOn");
    return pa;
}

- (NSDictionary *)asDictionary {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.guid, dic, @"guid");
    PutStringInDic(self.user_guid, dic, @"user_guid");
    PutStringInDic(self.patient_guid, dic, @"patient_guid");
    PutStringInDic(self.givenOn, dic, @"givenOn");
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
