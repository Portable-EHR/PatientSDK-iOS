//
// Created by Yves Le Borgne on 2023-05-10.
//

#import "IBPrivateMessage.h"
#import "GERuntimeConstants.h"
#import "IBPrivateMessageAttachment.h"

@implementation IBPrivateMessage
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
    IBPrivateMessage *ad      = [[IBPrivateMessage alloc] init];
    NSString         *message = WantStringFromDic(theDictionary, @"messageB64");
    TRACE(@"%@", message);

    if (message) {
        NSData *nsdataFromBase64String = [[NSData alloc] initWithBase64EncodedString:message options:NSDataBase64DecodingIgnoreUnknownCharacters];
        ad.message = [[NSString alloc] initWithData:nsdataFromBase64String
                                           encoding:NSUTF8StringEncoding];
    }

    NSMutableArray* atts = [NSMutableArray array];

    NSArray *sourceAtts = WantArrayFromDic(theDictionary, @"attachments");
    if (sourceAtts && sourceAtts.count > 0) {

        for (id att in sourceAtts) {
            NSDictionary *sourceAtt = att;
            [atts addObject:[IBPrivateMessageAttachment objectWithContentsOfDictionary:sourceAtt]];
        }
    }

    ad.attachments= [NSArray arrayWithArray:atts];


    ad.subject = WantStringFromDic(theDictionary, @"subject");
    ad.from    = WantStringFromDic(theDictionary, @"from");
    ad.to      = WantStringFromDic(theDictionary, @"to");
    ad.patient = WantStringFromDic(theDictionary, @"patient");
    ad.source  = WantStringFromDic(theDictionary, @"source");

    return ad;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    /*
     * THIS DOES NOT PERSIST : CONFIDENTIAL MESSAGES ONLY
     */
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

#pragma mark getters

#pragma mark private methods

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}
@end