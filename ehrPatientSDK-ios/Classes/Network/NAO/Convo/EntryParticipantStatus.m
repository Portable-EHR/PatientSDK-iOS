//
// Created by Yves Le Borgne on 2022-12-27.
//

#import "EntryParticipantStatus.h"
#import "GERuntimeConstants.h"

@implementation EntryParticipantStatus

TRACE_OFF

@synthesize participantId = _participantId;
@synthesize shouldSendToBackend = _shouldSendToBackend;
@synthesize entryId = _entryId;
@synthesize status = _status;
@synthesize date = _date;
@dynamic progress;

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        _shouldSendToBackend = NO;
    } else {
        MPLOG(@"*** super returns nil!");
    }
    return self;
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
    EntryParticipantStatus *ces = [[EntryParticipantStatus alloc] init];
    ces.participantId = WantStringFromDic(dic, @"participantId");
    ces.entryId       = WantStringFromDic(dic, @"entryId");
    ces.status        = WantStringFromDic(dic, @"status");
    ces.date          = WantDateFromDic(dic, @"date");
    return ces;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.participantId, dic, @"participantId");
    PutStringInDic(self.entryId, dic, @"entryId");
    PutStringInDic(self.status, dic, @"status");
    PutDateInDic(self.date, dic, @"date");
    return dic;
}

- (void)dealloc {
    _participantId = nil;
    _entryId       = nil;
    _status        = nil;
    _date          = nil;
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

//region API

- (EntryProgress)progress {
    if (self.isSent) return EntryProgressSent;
    if (self.isReceived) return EntryProgressReceived;
    if (self.isRead) return EntryProgressRead;
    if (self.isAcknowledged) return EntryProgressAcked;
    return EntryProgressInvalid;
}

- (void)setProgress:(EntryProgress)progress {
    switch (progress) {
        case EntryProgressSent:_status = @"sent";
            break;
        case EntryProgressReceived:_status = @"received";
            break;
        case EntryProgressRead:_status = @"read";
            break;
        case EntryProgressAcked:_status = @"ack";
            break;
        default:_status = @"invalid";
            break;
    }
}

+(EntryProgress) progressFromStatus:(NSString*) status{

    if ([status isEqualToString:@"sent"]) return EntryProgressSent;
    if ([status isEqualToString:@"read"]) return EntryProgressRead;
    if ([status isEqualToString:@"received"]) return EntryProgressReceived;
    if ([status isEqualToString:@"ack"]) return EntryProgressAcked;

    return EntryProgressInvalid;



}

+(NSString*) statusFromProgress:(EntryProgress) progress{
    NSString *_status;
    switch (progress) {
        case EntryProgressSent:_status = @"sent";
            break;
        case EntryProgressReceived:_status = @"received";
            break;
        case EntryProgressRead:_status = @"read";
            break;
        case EntryProgressAcked:_status = @"ack";
            break;
        default:_status = @"invalid";
            break;
    }
    return _status;
}

- (BOOL)isSent {
    return [_status isEqualToString:@"sent"];
}

- (BOOL)isReceived {
    return [_status isEqualToString:@"received"];
}

- (BOOL)isRead {
    return [_status isEqualToString:@"read"];
}

- (BOOL)isAcknowledged {
    return [_status isEqualToString:@"ack"];
}


//endregion

@end