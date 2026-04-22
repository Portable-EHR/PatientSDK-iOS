//
//  IBCompensation.m
//  EHRPatientSDK
//
//  Created by Vinay on 2025-01-09.
//


#import "IBCompensation.h"
#import "GERuntimeConstants.h"
#import "CompensationEvents.h"

@implementation IBCompensation

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
    IBCompensation *compensation = [[IBCompensation alloc] init];
    compensation.guid = WantStringFromDic(theDictionary, @"guid");
    compensation.maximum = WantIntegerFromDic(theDictionary, @"maximum");
//    compensation.events  = WantArrayFromDic(theDictionary, @"events");
    
    NSArray  *eventAsDics = WantArrayFromDic(theDictionary, @"events");
    NSMutableArray *event      = [NSMutableArray array];
    
    if (nil != eventAsDics) {
        for (id element in eventAsDics) {
            [event addObject:[CompensationEvents objectWithContentsOfDictionary:element]];
        }
    }
    compensation.events = [NSArray arrayWithArray:event];
    
    
    return compensation;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.guid, dic, @"size");
    PutIntegerInDic(self.maximum, dic, @"size");
    
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


