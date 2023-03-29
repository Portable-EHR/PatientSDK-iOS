//
// Created by Yves Le Borgne on 2022-12-27.
//

#import "ConversationParticipant.h"
#import "GERuntimeConstants.h"

@implementation ConversationParticipant

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

@synthesize guid = _guid;
@synthesize participantId = _participantId;
@synthesize type = _type;
@synthesize role = _role;
@synthesize addedOn = _addedOn;
@synthesize name = _name;
@synthesize firstName = _firstName;
@synthesize middleName = _middleName;
@synthesize mySelf = _mySelf;
@synthesize isActive = _isActive;

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
    ConversationParticipant *cp = [[ConversationParticipant alloc] init];
    cp.guid          = WantStringFromDic(dic, @"guid");
    cp.participantId = WantStringFromDic(dic, @"participantId");
    cp.type          = WantStringFromDic(dic, @"type");
    cp.role          = WantStringFromDic(dic, @"role");
    cp.addedOn       = WantDateFromDic(dic, @"addedOn");
    cp.name          = WantStringFromDic(dic, @"name");
    cp.firstName     = WantStringFromDic(dic, @"firstName");
    cp.middleName    = WantStringFromDic(dic, @"middleName");
    cp.mySelf        = WantBoolFromDic(dic, @"mySelf");
    cp.isActive      = WantBoolFromDic(dic, @"active");
    return cp;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutStringInDic(self.guid, dic, @"guid");
    PutStringInDic(self.participantId, dic, @"participantId");
    PutStringInDic(self.type, dic, @"type");
    PutStringInDic(self.role, dic, @"role");
    PutDateInDic(self.addedOn, dic, @"addedOn");
    PutStringInDic(self.name, dic, @"name");
    PutStringInDic(self.firstName, dic, @"firstName");
    PutStringInDic(self.middleName, dic, @"middleName");
    PutBoolInDic(self.mySelf, dic, @"myself");
    PutBoolInDic(self.isActive, dic, @"active");
    return dic;
}

- (void)dealloc {
    _guid          = nil;
    _participantId = nil;
    _type          = nil;
    _role          = nil;
    _addedOn       = nil;
    _name          = nil;
    _firstName     = nil;
    _middleName    = nil;
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
}

- (NSString *)fullName {
    if (!_firstName && !_middleName % !_name) return @"Undefined";
    if (!_name) {
        if (!_firstName) return _middleName;
        return _firstName;
    }
    if (!_firstName) {
        if (_middleName) {
            [NSString stringWithFormat:@"%@ %@", _middleName, _name];
        } else return _name;
    }
    return [NSString stringWithFormat:@"%@ %@", _firstName, _name];
}
 //region API

- (NSString *) __unused shortName {
    if (_firstName) return _firstName;
    return self.fullName;
}

- (BOOL)isAdmin __unused {
    return [_role isEqualToString:@"admin"];
}

- (BOOL)isParticipant __unused {
    return [_role isEqualToString:@"participant"];
}

- (BOOL)isStaff __unused {
    return [_type isEqualToString:@"staff"];
}

- (BOOL)isPrivilegedStaff __unused {
    return [_type isEqualToString:@"privileged_staff"];
}

- (BOOL)isStaffGuest __unused {
    return [_type isEqualToString:@"staff_guess"]; // dafuk !
}

- (BOOL)isClient __unused {
    return [_type isEqualToString:@"client"];
}

- (BOOL)isClientGuest __unused {
    return [_type isEqualToString:@"client_guess"]; // re-dafuk !
}

//endregion
@end