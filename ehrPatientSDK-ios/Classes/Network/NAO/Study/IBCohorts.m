//
//  IBCohorts.m
//  EHRPatientSDK
//
//  Created by Vinay on 2025-01-07.
//


#import "IBCohorts.h"
#import "GERuntimeConstants.h"

@implementation IBCohorts

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
    IBCohorts *cohorts = [[IBCohorts alloc] init];
    
//    if (dic[@"criteria"]) cohorts.cohortsCriteria = [IBCohortsCriteria objectWithContentsOfDictionary:dic[@"criteria"]];
    
    cohorts.size = WantStringFromDic(theDictionary, @"size");
//    cohorts.minimumAge = WantStringFromDic(theDictionary, @"minimumAge");
//    cohorts.maximumAge = WantStringFromDic(theDictionary, @"maximumAge");
    return cohorts;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    PutStringInDic(self.size, dic, @"size");
//    PutStringInDic(self.minimumAge, dic, @"minimumAge");
//    PutStringInDic(self.maximumAge, dic, @"maximumAge");
    
    
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


