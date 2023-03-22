//
// Created by Yves Le Borgne on 2015-10-06.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "GEMacros.h"

@implementation NSDictionary (JSON)
+ (id)dictionaryWithJSONdata:(NSData *)jsonData {

    NSError      *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) {
        MPLOG(@"*** Error encountered while deserializing JSON from server : %@", error.description);
    }
    return dic;

}

+ (id)dictionaryWithJSON:(NSString *)jsonString {
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSDictionary dictionaryWithJSONdata:data];
}

- (NSData *)asJSONdata {
    NSError *error;
    NSData *jsonData;
    if (@available(iOS 13.0, *)) {
        jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                            options:NSJSONWritingPrettyPrinted+ NSJSONWritingWithoutEscapingSlashes
                                                              error:&error];
        

    } else {
        // Fallback on earlier versions
        
        jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:&error];
    }
    if (error) {
        MPLOG(@"*** Error while converting to JSON data : %@", error.localizedDescription);
        return nil;
    } else {
        
        return jsonData;
    }
}

- (NSString *)asJSON {

    NSData *jsonData = [self asJSONdata];

    if (!jsonData) {
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
