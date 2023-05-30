//
// Created by Yves Le Borgne on 2023-04-07.
//

#import "ConsentsModel.h"
#import "IBConsent.h"
#import "PehrSDKConfig.h"

@interface ConsentsModel () {
    NSMutableDictionary *_consents;
}
@end

@implementation ConsentsModel

//region API
- (NSArray <IBConsent *> *)allConsents {
    return [_consents allValues];
}

- (IBConsent *_Nullable)consentWithGuid:(NSString *)guid {
    return _consents[guid];
}

- (NSInteger)count {
    return [_consents count];
}

- (IBConsent *_Nullable)getEula {
    for (IBConsent *consent in [_consents allValues]) {
        if (consent.isEula) return consent;
    }
    return nil;
}

- (IBConsent *_Nullable)getCCRP {
    for (IBConsent *consent in [_consents allValues]) {
        if (consent.isCCRP) return consent;
    }
    return nil;
}

- (void)populateWithConsents:(NSArray<IBConsent *> *)pulledConsents {
    TRACE(@"populateWithConsents");
    [_consents removeAllObjects];
    for (IBConsent *consent in pulledConsents) {
        _consents[consent.guid] = consent;
        if (consent.isCCRP) {
            TRACE(@"Got CCRP : %@\n", [consent asDictionary]);
        }
    }
    [PehrSDKConfig.shared.state.delegate onConsentsUpdate];

}

//endregion


TRACE_ON

+ (instancetype)instance {

    static dispatch_once_t once;
    static ConsentsModel   *_instance;
    dispatch_once(&once, ^{
        _instance = [[ConsentsModel alloc] init];
        _instance->_consents = [NSMutableDictionary dictionary];
    });
    return _instance;

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
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end