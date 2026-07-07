//
//  IBIssuers.m
//  EHRPatientSDK
//
//  Created by Vinay on 2026-06-19.
//

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "GERuntimeConstants.h"
#import "IBIssuers.h"
#import "IBDescription.h"
@implementation IBIssuers

- (instancetype)init {
    if ((self = [super init])) {GE_ALLOC();GE_ALLOC_ECHO();
    } else {
        MPLOG(@"*** super returns nil!");
    }
    return self;
}

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)theDictionary {
    IBIssuers *issuers = [[IBIssuers alloc] init];
    issuers->_kind                = WantStringFromDic(theDictionary, @"kind");
    issuers->_alias               = WantStringFromDic(theDictionary, @"alias");
    issuers->_issuer              = WantStringFromDic(theDictionary, @"issuer");
    issuers->_country             = WantStringFromDic(theDictionary, @"country");
    issuers->_state               = WantStringFromDic(theDictionary, @"state");
    issuers->_guid                = WantStringFromDic(theDictionary, @"guid");
    if (theDictionary[@"description"]) issuers->_issuerDescription = [IBDescription objectWithContentsOfDictionary:theDictionary[@"description"]];
    return issuers;
}

- (NSDictionary *)asDictionary {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.kind, dic, @"kind");
    PutStringInDic(self.alias, dic, @"alias");
    PutStringInDic(self.issuer, dic, @"issuer");
    PutStringInDic(self.country, dic, @"country");
    PutStringInDic(self.state, dic, @"state");
    PutStringInDic(self.guid, dic, @"guid");
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
    GE_DEALLOC();GE_DEALLOC_ECHO();
}



@end
