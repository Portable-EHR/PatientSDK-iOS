//
// Created by Yves Le Borgne on 2015-10-07.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "EHRPersistableP.h"
#import "IBAddress.h"
#import "GEMacros.h"
#import "GERuntimeConstants.h"

@implementation IBAddress

TRACE_OFF

-(instancetype) init {
    if ((self = [super init])){
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        MPLOG(@"*** super returns nil!");
    }
    return self;
}

+(instancetype)objectWithContentsOfDictionary:(NSDictionary *)theDictionary {
    IBAddress *ct = [[IBAddress alloc] init];
    id        val = nil;
    if((val = [theDictionary objectForKey:@"street1"])) ct.street1=val;
    if((val = [theDictionary objectForKey:@"street2"])) ct.street2=val;
    if((val = [theDictionary objectForKey:@"city"])) ct.city=val;
    if((val = [theDictionary objectForKey:@"state"])) ct.state=val;
    if((val = [theDictionary objectForKey:@"zip"])) ct.zip=val;
    if((val = [theDictionary objectForKey:@"country"])) ct.country=val;
    return ct;
}

-(NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.street1) [dic setObject:self.street1 forKey:@"street1"];
    if(self.street2) [dic setObject:self.street1 forKey:@"street1"];
    if(self.city) [dic setObject:self.street1 forKey:@"street1"];
    if(self.state) [dic setObject:self.street1 forKey:@"street1"];
    if(self.zip) [dic setObject:self.street1 forKey:@"street1"];
    if(self.country) [dic setObject:self.street1 forKey:@"street1"];
    if(self.street1) [dic setObject:self.street1 forKey:@"street1"];
    return dic;
}

+(instancetype)objectWithJSON:(NSString *)jsonString {
    NSDictionary *dic = [NSDictionary dictionaryWithJSON:jsonString];
    return [self objectWithContentsOfDictionary:dic];
}

+(instancetype)objectWithJSONdata:(NSData *)jsonData {
    NSDictionary *dic = [NSDictionary dictionaryWithJSONdata:jsonData];
    return [self objectWithContentsOfDictionary:dic];
}

-(NSString*)asJSON {
    return [[self asDictionary] asJSON];
}

-(NSData *)asJSONdata {
    return [[self asDictionary] asJSONdata];
}



-(void) dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end
