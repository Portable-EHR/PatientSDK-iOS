//
// Created by Yves Le Borgne on 2023-01-31.
//

#import "EHRPersistableP.h"
#import "EHRUserRegistrationManifest.h"

@interface EHRUserRegistrationManifest () {
    NSInteger _instanceNumber;
    NSString  *_email;
    NSString  *_HCIN;
    NSString  *_HCINjurisdiction;
    NSString  *_mobilePhone;
}
@end

@implementation EHRUserRegistrationManifest

@synthesize email, HCIN, HCINjurisdiction, mobilePhone;

TRACE_ON

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    EHRUserRegistrationManifest *manifest = [[EHRUserRegistrationManifest alloc] init];
    manifest.email            = WantStringFromDic(dic, @"email");
    manifest.mobilePhone      = WantStringFromDic(dic, @"mobilePhone");
    manifest.HCINjurisdiction = WantStringFromDic(dic, @"HCINjurisdiction");
    manifest.HCIN             = WantStringFromDic(dic, @"HCIN");
    return manifest;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.email, dic, @"email");
    PutStringInDic(self.mobilePhone, dic, @"mobilePhone");
    PutStringInDic(self.HCINjurisdiction, dic, @"HCINjurisdiction");
    PutStringInDic(self.HCIN, dic, @"HCIN");
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
    _email            = nil;
    _mobilePhone      = nil;
    _HCIN             = nil;
    _HCINjurisdiction = nil;
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end