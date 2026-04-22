//
// Created by Yves Le Borgne on 2016-03-08.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "IBPractitioner.h"
#import "IBContact.h"
#import "IBPractitionerPractice.h"
#import "GERuntimeConstants.h"

@implementation IBPractitioner
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
    IBPractitioner *ad = [[IBPractitioner alloc] init];
    ad.guid = WantStringFromDic(theDictionary, @"guid");
    id val = theDictionary[@"practices"];

    NSMutableArray *practices = [NSMutableArray array];
    if (val) {
        for (NSDictionary *dic in val) {
            TRACE(@"practice is %@",dic);
            [practices addObject:[IBPractitionerPractice objectWithContentsOfDictionary:dic]];
        }
    }
    ad.practices = practices;

    val = theDictionary[@"contact"];
    if (val) ad.contact = [IBContact objectWithContentsOfDictionary:val];
    val = theDictionary[@"userContact"];
    if (val) ad.userContact = [IBContact objectWithContentsOfDictionary:val];

    return ad;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.guid, dic, @"guid");
    if (self.contact) [dic setObject:[self.contact asDictionary] forKey:@"contact"];
    if (self.userContact) [dic setObject:[self.userContact asDictionary] forKey:@"userContact"];

    NSMutableArray              *practices = [NSMutableArray array];
    for (IBPractitionerPractice *practice in self.practices) {
        [practices addObject:[practice asDictionary]];
    }
    [dic setObject:practices forKey:@"practices"];

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