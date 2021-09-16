//
// Created by Yves Le Borgne on 2015-11-17.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "UserDeviceSettings.h"
#import "NotificationsModelFilter.h"
#import "ServicesModelFilter.h"

@implementation UserDeviceSettings

TRACE_OFF

@synthesize subscribedServicesFilter = _subscribedServicesFilter;

- (instancetype)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
        _patientNotificationsFilter      = [NotificationsModelFilter patientFilter];
        _alertNotificationsFilter        = [NotificationsModelFilter alertFilter];
        _infoNotificationsFilter         = [NotificationsModelFilter infoFilter];
        _practitionerNotificationsFilter = [NotificationsModelFilter practitionerFilter];
        _messageNotificationsFilter      = [NotificationsModelFilter messageFilter];
        _telexNotificationsFilter        = [NotificationsModelFilter telexFilter];
        _appointmentNotificationsFilter  = [NotificationsModelFilter appointmentFilter];
        _subscribedServicesFilter        = [ServicesModelFilter subscribedServicesFilter];
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

- (void)dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
    _patientNotificationsFilter      = nil;
    _alertNotificationsFilter        = nil;
    _infoNotificationsFilter         = nil;
    _practitionerNotificationsFilter = nil;
    _messageNotificationsFilter      = nil;
    _telexNotificationsFilter        = nil;
    _subscribedServicesFilter        = nil;
}

#pragma mark - persistence

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    id                 val = nil;
    UserDeviceSettings *pa = [[self alloc] init];
    if ((val = dic[@"patientNotificationsFilter"])) pa->_patientNotificationsFilter = [NotificationsModelFilter objectWithContentsOfDictionary:val];
    if ((val = dic[@"alertNotificationFilter"])) pa->_alertNotificationsFilter = [NotificationsModelFilter objectWithContentsOfDictionary:val];
    if ((val = dic[@"infoNotificationFilter"])) pa->_infoNotificationsFilter = [NotificationsModelFilter objectWithContentsOfDictionary:val];
    if ((val = dic[@"practitionerNotificationsFilter"])) pa->_practitionerNotificationsFilter = [NotificationsModelFilter objectWithContentsOfDictionary:val];
    if ((val = dic[@"subscribedServicessFilter"])) pa.subscribedServicesFilter = [ServicesModelFilter objectWithContentsOfDictionary:val];

    if ((val = dic[@"messageNotificationsFilter"])) {
        pa->_messageNotificationsFilter = [NotificationsModelFilter objectWithContentsOfDictionary:val];
    } else {
        pa->_messageNotificationsFilter = [NotificationsModelFilter messageFilter];
    }

    if ((val = dic[@"telexNotificationsFilter"])) {
        pa->_telexNotificationsFilter = [NotificationsModelFilter objectWithContentsOfDictionary:val];
    } else {
        pa->_telexNotificationsFilter = [NotificationsModelFilter telexFilter];
    }

    if ((val = dic[@"appointmentNotificationsFilter"])) {
        pa->_appointmentNotificationsFilter = [NotificationsModelFilter objectWithContentsOfDictionary:val];
    } else {
        pa->_appointmentNotificationsFilter = [NotificationsModelFilter telexFilter];
    }

    return pa;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (_patientNotificationsFilter) dic[@"patientNotificationsFilter"]           = [_patientNotificationsFilter asDictionary];
    if (_alertNotificationsFilter) dic[@"alertNotificationsFilter"]               = [_alertNotificationsFilter asDictionary];
    if (_infoNotificationsFilter) dic[@"infoNotificationsFilter"]                 = [_infoNotificationsFilter asDictionary];
    if (_practitionerNotificationsFilter) dic[@"practitionerNotificationsFilter"] = [_practitionerNotificationsFilter asDictionary];
    if (_messageNotificationsFilter) dic[@"messageNotificationsFilter"]           = [_messageNotificationsFilter asDictionary];
    if (_telexNotificationsFilter) dic[@"telexNotificationsFilter"]               = [_telexNotificationsFilter asDictionary];
    if (_subscribedServicesFilter) dic[@"subscribedServicesFilter"]               = [_subscribedServicesFilter asDictionary];
    if (_appointmentNotificationsFilter) dic[@"appointmentNotificationsFilter"]   = [_appointmentNotificationsFilter asDictionary];
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

@end