//
//  IBStudy.m
//  EHRPatientSDK
//
//  Created by Vinay on 2025-01-03.
//


#import "IBStudy.h"
#import "GERuntimeConstants.h"

@implementation IBStudy

//@synthesize cohorts = _cohorts;
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
    IBStudy *study = [[IBStudy alloc] init];
    
    study.plannedStart               = WantStringFromDic(theDictionary, @"plannedStart");
    study.plannedCompletion          = WantStringFromDic(theDictionary, @"plannedCompletion");
    study.plannedVisits              = WantIntegerFromDic(theDictionary, @"plannedVisits");
    study.title                      = WantStringFromDic(theDictionary, @"title");
    study.progress                   = WantStringFromDic(theDictionary, @"progress");
    study.guid                       = WantStringFromDic(theDictionary, @"guid");
    
//    NSArray        *cohortsAsDics = WantArrayFromDic(theDictionary, @"cohorts");
//    NSMutableArray *cohorts       = [NSMutableArray array];
//    
//    if (nil != cohortsAsDics) {
//        for (id element in cohortsAsDics) {
//            [cohorts addObject:[IBCohorts objectWithContentsOfDictionary:element]];
//        }
//    }
//    
//    study.cohorts                    = [NSArray arrayWithArray:cohorts];
    
     study.cohorts = WantArrayFromDic(theDictionary, @"cohorts");
//    study.compensation = WantDicFromDic(theDictionary, @"compensation");
    
//    study.compensation               = WantDicFromDic(theDictionary, @"compensation");
    
    
    if (theDictionary[@"compensation"]) study.compensation = [IBCompensation objectWithContentsOfDictionary:theDictionary[@"compensation"]];
    
    return study;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    PutStringInDic(self.plannedStart, dic, @"plannedStart");
    PutStringInDic(self.plannedCompletion, dic, @"plannedCompletion");
    PutIntegerInDic(self.plannedVisits, dic, @"plannedVisits");
    PutStringInDic(self.title, dic, @"title");
    PutStringInDic(self.progress, dic, @"progress");
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
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}
@end


