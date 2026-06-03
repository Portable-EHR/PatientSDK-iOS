//
//  IBStackName.m
//  EHRPatientSDK
//
//  Created by Vinay on 2025-10-13.
//

#import <Foundation/Foundation.h>
#import "EHRPersistableP.h"
#import "IBStackName.h"
#import "GERuntimeConstants.h"

@implementation IBStackName


- (instancetype)init {
    if ((self = [super init])) {GE_ALLOC();GE_ALLOC_ECHO();
    } else {
        MPLOG(@"*** super returns nil!");
    }
    return self;
}

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)theDictionary {
    IBStackName *sn = [[IBStackName alloc] init];
    sn.en                    = WantStringFromDic(theDictionary, @"en");
    sn.es                    = WantStringFromDic(theDictionary, @"es");
    sn.fr                    = WantStringFromDic(theDictionary, @"fr");
    sn.de                    = WantStringFromDic(theDictionary, @"de");
    return sn;
}

- (NSDictionary *)asDictionary {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.en, dic, @"en");
    PutStringInDic(self.es, dic, @"es");
    PutStringInDic(self.fr, dic, @"fr");
    PutStringInDic(self.de, dic, @"de");
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

