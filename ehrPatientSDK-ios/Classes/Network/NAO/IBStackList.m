//
//  IBStackList.m
//  EHRPatientSDK
//
//  Created by Vinay on 2025-10-08.
//

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "IBStackList.h"
#import "GERuntimeConstants.h"
#import "IBStackName.h"

@implementation IBStackList


- (instancetype)init {
    if ((self = [super init])) {GE_ALLOC();GE_ALLOC_ECHO();
    } else {
        MPLOG(@"*** super returns nil!");
    }
    return self;
}

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)theDictionary {
    IBStackList *sl = [[IBStackList alloc] init];
    sl->_key                    = WantStringFromDic(theDictionary, @"key");
    if (theDictionary[@"name"]) sl->_name = [IBStackName objectWithContentsOfDictionary:theDictionary[@"name"]];
    sl->_oamp_host              = WantStringFromDic(theDictionary, @"oamp_host");
    return sl;
}

- (NSDictionary *)asDictionary {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.key, dic, @"key");
    PutStringInDic(self.oamp_host, dic, @"oamp_host");
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
