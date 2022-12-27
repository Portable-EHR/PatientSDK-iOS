//
// Created by Yves Le Borgne on 2022-12-27.
//

#import "ConversationEntryPayload.h"
#import "EntryAttachment.h"

@implementation ConversationEntryPayload

TRACE_OFF

@synthesize text = _text;

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        MPLOG(@"*** super returns nil!");
    }
    return self;
}

- (NSArray *)attachments {
    return _attachments;
}

- (void)setAttachments:(NSArray *)attachments {
    _attachments = attachments;
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

+ (id)objectWithContentsOfDictionary:(NSDictionary *)dic {
    ConversationEntryPayload *cep = [[ConversationEntryPayload alloc] init];
    cep->_text = WantStringFromDic(dic, @"text");
    NSArray        *attsAsDics = WantArrayFromDic(dic, @"attachments");
    NSMutableArray *atts       = [NSMutableArray array];
    if (nil != attsAsDics) {
        for (id element in attsAsDics) {
            [atts addObject:[EntryAttachment objectWithContentsOfDictionary:element]];
        }
    }
    cep.attachments = [NSArray arrayWithArray:atts];
    return cep;
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