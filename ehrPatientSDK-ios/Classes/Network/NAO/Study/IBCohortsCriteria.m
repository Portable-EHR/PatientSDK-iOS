//
//  IBCohortsCriteria.m
//  EHRPatientSDK
//
//  Created by Vinay on 2025-01-07.
//

#import "IBCohortsCriteria.h"
#import "GERuntimeConstants.h"

@implementation IBCohortsCriteria

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
    IBCohortsCriteria *criteria = [[IBCohortsCriteria alloc] init];
    criteria.gender = WantStringFromDic(theDictionary, @"gender");
    criteria.minimumAge = WantStringFromDic(theDictionary, @"minimumAge");
    criteria.maximumAge = WantStringFromDic(theDictionary, @"maximumAge");
    return criteria;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    PutStringInDic(self.gender, dic, @"gender");
    PutStringInDic(self.minimumAge, dic, @"minimumAge");
    PutStringInDic(self.maximumAge, dic, @"maximumAge");
    
    
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



