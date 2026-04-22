//
//  IBConsentable.m
//  EHRPatientSDK
//
//  Created by Vinay on 2025-01-06.
//


#import "IBConsentable.h"
#import "GERuntimeConstants.h"

@implementation IBConsentable

@synthesize consent = _consent;

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
    IBConsentable *consent = [[IBConsentable alloc] init];
    consent.active                     = WantStringFromDic(theDictionary, @"active");
    consent.guid                       = WantStringFromDic(theDictionary, @"guid");
    consent.consent       = [IBConsentGranted objectWithContentsOfDictionary:theDictionary[@"consent"]];
    return consent;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    PutStringInDic(self.active, dic, @"active");
    PutStringInDic(self.guid, dic, @"guid");
    if (self.consent) dic[@"consent"]             = [self.consent asDictionary];
    return dic;
}

- (IBConsentGranted *)getGrantedConsent {
    return _consent;
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
    _consent                = nil;
}
@end


