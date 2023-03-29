//
// Created by Yves Le Borgne on 2017-09-29.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "IBUserEula.h"
#import "Version.h"
#import "GERuntimeConstants.h"

@implementation IBUserEula

@dynamic wasSeen, wasConsented;

// todo : clunky ?  magic number inherited from server side (defined in DAO\Eula.php)


TRACE_OFF

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        self.scope = @"app";              // default scope , fixes a mess in app
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    IBUserEula *pa = [[self alloc] init];
    pa.dateSeen      = WantDateFromDic(dic, @"dateSeen");
    pa.dateConsented = WantDateFromDic(dic, @"dateConsented");
    pa.userGuid      = WantStringFromDic(dic, @"userGuid");
    pa.patientGuid   = WantStringFromDic(dic, @"patientGuid");
    pa.scope         = WantStringFromDic(dic, @"scope");
    pa.aboutGuid     = WantStringFromDic(dic, @"aboutGuid");
    pa.eulaGuid      = WantStringFromDic(dic, @"eulaGuid");
    id val = [dic objectForKey:@"eulaVersion"];
    if (val) pa.eulaVersion = [Version versionWithString:val];
    if (!pa.scope) pa.scope = @"app";
    return pa;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutDateInDic(self.dateConsented, dic, @"dateConsented");
    PutDateInDic(self.dateSeen, dic, @"dateSeen");
    PutStringInDic(self.userGuid, dic, @"userGuid");
    PutStringInDic(self.eulaGuid, dic, @"eulaGuid");
    PutStringInDic(self.patientGuid, dic, @"patientGuid");
    PutStringInDic(self.scope, dic, @"scope");
    PutStringInDic(self.aboutGuid, dic, @"aboutGuid");
    PutStringInDic(self.eulaVersion.description, dic, @"eulaVersion");
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

- (BOOL)wasSeen {
    return (_dateSeen != nil);
}

- (BOOL)wasConsented {
    return (_dateConsented != nil);
}

-(void)refreshWith:(IBUserEula *)other {
    if (!other) return;
    if ([other.eulaVersion.toString isEqualToString:self.eulaVersion.toString]) return;

    self.eulaVersion=other.eulaVersion;
    self.dateConsented=other.dateConsented;
    self.dateSeen=other.dateSeen;
    self.scope=other.scope;
    self.aboutGuid=other.aboutGuid;
    self.userGuid=other.userGuid;
    self.patientGuid=other.patientGuid;

}

@end
