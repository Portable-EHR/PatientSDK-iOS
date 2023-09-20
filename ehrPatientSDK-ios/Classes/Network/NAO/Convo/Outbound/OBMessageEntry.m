//
// Created by Yves Le Borgne on 2023-02-18.
//

#import "OBMessageEntry.h"
#import "OBMessageEntryAttachment.h"

@interface OBMessageEntry () {
    NSInteger _instanceNumber;
}
@end

@implementation OBMessageEntry

+ (id)objectWithContentsOfDictionary:(NSDictionary *)dic {
    OBMessageEntry *me = [[self alloc] init];
    me.text        = WantStringFromDic(dic, @"text");
    me.attachments = [NSMutableArray array];
    
    me.freeTextReply = WantStringFromDic(dic, @"freeTextReply");
    me.dateReply = WantStringFromDic(dic, @"dateReply");
    me.dateTimeReply = WantStringFromDic(dic, @"dateTimeReply");
    
    if (dic[@"attachments"]) {
        for (NSDictionary *attDic in dic[@"attachments"]) {
            OBMessageEntryAttachment *oea = [OBMessageEntryAttachment objectWithContentsOfDictionary:attDic];
            [me.attachments addObject:oea];
        }
    }
    return me;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"text"] = self.text;
    dic[@"freeTextReply"] = self.freeTextReply;
    dic[@"dateReply"] = self.dateReply;
    dic[@"dateTimeReply"] = self.dateReply;
    
    NSMutableArray *attachments = [NSMutableArray array];

    for (OBMessageEntryAttachment *oea in self.attachments) {
        NSDictionary *oeaDic = [oea asDictionary];
        [attachments addObject:oeaDic];
    }
    dic[@"attachments"] = attachments;
    
    NSMutableDictionary *obcrDic = [NSMutableDictionary dictionary];
    [obcrDic setValue:self.choiceReply.id forKey:@"id"];
    dic[@"choiceReply"] = obcrDic;
    
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

TRACE_ON

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        self.attachments = [NSMutableArray array];
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

- (void)dealloc {
    _attachments = nil;
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

@end
