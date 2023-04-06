//
//  IBConsent.m
//  ehrPatientSDK-ios
//
//

#import "IBConsent.h"
#import "GERuntimeConstants.h"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation IBConsent

@synthesize guid = _guid;
@synthesize alias = _alias;
@synthesize consentableElementType = _consentableElementType;
@synthesize activeFrom = _activeFrom;
@synthesize title = _title;
@synthesize descriptionText = _descriptionText;
@synthesize consent = _consent;
@synthesize active = _active;
@dynamic isEula;
@dynamic isCCRP;
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
    _guid                   = nil;
    _alias                  = nil;
    _consentableElementType = nil;
    _activeFrom             = nil;
    _title                  = nil;
    _descriptionText        = nil;
    _consent                = nil;
    _active                 = false;
}

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {

    IBConsent *pa = [[self alloc] init];
    pa->_guid                   = WantStringFromDic(dic, @"guid");
    pa->_alias                  = WantStringFromDic(dic, @"alias");
    pa->_consentableElementType = WantStringFromDic(dic, @"consentableElementType");
    pa->_activeFrom             = WantStringFromDic(dic, @"activeFrom");

    pa->_title           = [IBRenderableText objectWithContentsOfDictionary:dic[@"title"]];
    pa->_descriptionText = [IBRenderableText objectWithContentsOfDictionary:dic[@"description"]];
    pa->_consent         = [IBConsentGranted objectWithContentsOfDictionary:dic[@"consent"]];

    pa->_active = WantBoolFromDic(dic, @"active");

    return pa;
}

- (NSDictionary *)asDictionary {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.guid, dic, @"guid");
    PutStringInDic(self.alias, dic, @"alias");
    PutStringInDic(self.consentableElementType, dic, @"consentableElementType");
    PutStringInDic(self.activeFrom, dic, @"activeFrom");

    if (self.title) dic[@"title"]                 = [self.title asDictionary];
    if (self.descriptionText) dic[@"description"] = [self.descriptionText asDictionary];
    if (self.consent) dic[@"consent"]             = [self.consent asDictionary];

    PutBoolInDic(self.active, dic, @"active");
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

- (IBConsentGranted *)getGrantedConsent {
    return _consent;
}

//region API
-(BOOL)isEula {
    return [_consentableElementType isEqualToString:@"eula"];
}

-(BOOL) isCCRP {
    return [_consentableElementType isEqualToString:@"research_notifications"];
}
//endregion

@end

#pragma clang diagnostic pop
