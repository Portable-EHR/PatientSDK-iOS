//
//  EntryAnnouncementPayload.m
//  EHRPatientSDK
//
//  Created by Vinay on 2024-05-27.
//

#import <Foundation/Foundation.h>
#import "EntryAnnouncementPayload.h"
#import "GERuntimeConstants.h"
#import "EntryAttachment.h"

@implementation EntryAnnouncementPayload

@synthesize text = _text;

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

- (NSArray *)attachments {
    return _attachments;
}

- (void)setAttachments:(NSArray *)attachments {
    _attachments = attachments;
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

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    EntryAnnouncementPayload *eap = [[EntryAnnouncementPayload alloc] init];
    eap->_text = WantStringFromDic(dic, @"text");
    
    NSArray        *attsAsDics = WantArrayFromDic(dic, @"attachments");
    NSMutableArray *atts       = [NSMutableArray array];
    if (nil != attsAsDics) {
        for (id element in attsAsDics) {
            [atts addObject:[EntryAttachment objectWithContentsOfDictionary:element]];
        }
    }
    eap.attachments = [NSArray arrayWithArray:atts];
    return eap;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.text, dic, @"text");
    
    NSMutableArray            *atts = [NSMutableArray array];
    for (id <EHRNetworkableP> element in self.attachments) {
        [atts addObject:[element asDictionary]];
    }
    dic[@"attachments"] = [NSArray arrayWithArray:atts];
    
    return dic;
}

- (void)dealloc {
    _attachments = nil;
    _text        = nil;

    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end

