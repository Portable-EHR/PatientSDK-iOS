//
// Created by Yves Le Borgne on 2015-10-01.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "EHRApiServer.h"
#import "SecureCredentials.h"
#import "UserCredentials.h"

#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation EHRApiServer

static NSString *DEV_HOST = @"darkmax.local";
@dynamic oampURL;

TRACE_OFF

- (id)init {
    if ((self = [super init])) {
        self.port          = (unsigned int) 443;
        self.serverDNSname = @"api.portableehr.net";
        self.scheme        = @"https";
        GE_ALLOC();
    } else {
        TRACE(@"*** super returned nil!");
    }
    return self;
}

+ (EHRApiServer *)defaultApiServer {

    return [SecureCredentials sharedCredentials].current.server;

}

+ (EHRApiServer *)serverForHost:(NSString *)host {

    EHRApiServer *server = [[EHRApiServer alloc] init];
    server.host = host;
    if ([host hasSuffix:@"portableehr.net"]) {
        server.port          = 443;
        server.scheme        = @"https";
        server.serverDNSname = @"api.portableehr.net";
    } else if ([host hasSuffix:@"portableehr.io"]) {
        server.port          = 443;
        server.scheme        = @"https";
        server.serverDNSname = @"api.portableehr.io";
    } else if ([host hasSuffix:@"portableehr.ca"]) {
        server.port          = 443;
        server.scheme        = @"https";
        server.serverDNSname = @"api.portableehr.ca";
    } else if ([host hasSuffix:@"portableehr.dev"]) {
        server.port          = 443;
        server.scheme        = @"https";
        server.serverDNSname = @"api.portableehr.dev";
    }  else if ([host isEqualToString:@"192.168.32.32"]) {
        server.port          = 8080;
        server.scheme        = @"http";
        server.host          = DEV_HOST;
        server.serverDNSname = @"192.168.32.32";
    } else if ([host isEqualToString:@"10.0.1.21"]) {
        server.port          = 8080;
        server.scheme        = @"http";
        server.host          = DEV_HOST;
        server.serverDNSname = @"10.0.1.21";
    } else if ([host isEqualToString:DEV_HOST]) {
        server.port          = 8080;
        server.scheme        = @"http";
        server.host          = DEV_HOST;
        server.serverDNSname = [server inferServerDNSnameFromHost:server.host];
    }
    return server;
}

+(EHRApiServer *) serverForStackKey:(NSString *) stackKey {
    NSString *host = [GERuntimeConstants getHostNameForStackKey:stackKey];
    return [EHRApiServer serverForHost:host];
}


- (void)setServerDNSname:(NSString *)serverDNSname {
    _serverDNSname = nil;
    _serverDNSname = serverDNSname;
}

- (void)setHost:(NSString *)host {
    _host = nil;
    _host = host;
}

- (NSString *)inferServerDNSnameFromHost:(NSString *)host {
    NSString *serverDNSname = host;
    if ([host isEqualToString:DEV_HOST]) {
        NSString *addy = [self getIPAddress];
        if (nil == addy) {
            MPLOGERROR(@"**** Got null IP address !");
            serverDNSname = @"10.0.1.21";
        } else if ([addy hasPrefix:@"192.168.32"]) {
            serverDNSname = @"192.168.32.32";
        } else if ([addy hasPrefix:@"10.0.1."]) {
            serverDNSname = @"10.0.1.21";
        } else {
            MPLOGERROR(@"**** Got invalid IP address [%@] !", addy);
            serverDNSname = @"10.0.1.21";
        }
    }
    return serverDNSname;
}

- (NSString *)oampURL {

    if ([kStackKey isEqualToString:@"CA.prod"]) {
        return @"https://oamp.portableehr.ca";
    } else if ([kStackKey isEqualToString:@"CA.partner"]) {
        return @"https://oamp.portableehr.io";
    } else if ([kStackKey isEqualToString:@"CA.staging"]) {
        return @"https://oamp.portableehr.net";
    } else if ([kStackKey isEqualToString:@"CA.dev"]) {
        return @"https://oamp.portableehr.dev";
    } else if ([kStackKey isEqualToString:@"CA.devoffice"]) {
        return @"http://192.168.32.32";
    } else if ([kStackKey isEqualToString:@"CA.devhome"]) {
        return @"http://10.0.1.21";
    } else {
        MPLOGERROR(@"**** No OAMP URL available for stack key [%@]", kStackKey);
        return nil;
    }

}

- (NSString *)getIPAddress {

    TRACE_KILLROY

    NSString       *address    = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr  = NULL;
    int            success     = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                TRACE(@"Devide has if [%@]", [NSString stringWithUTF8String:temp_addr->ifa_name]);
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"] || [[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en5"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *) temp_addr->ifa_addr)->sin_addr)];
                    TRACE(@"Found addy [%@]", address);
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    if ([address isEqualToString:@"error"]) {
        MPLOGERROR(@"**** Dafuk, could not find an IP addy, returning [error]");
    }
    return address;

}

- (NSURL *)urlForRoute:(NSString *)route {
    NSString *urlAsString = [NSString stringWithFormat:@"%@://%@:%u%@", self.scheme, self.serverDNSname, (unsigned int) self.port, route];
    return [[NSURL alloc] initWithString:urlAsString];
}

+ (instancetype)objectWithContentsOfDictionary:(NSDictionary *)dic {
    EHRApiServer *pa = [[EHRApiServer alloc] init];
    pa.port          = WantIntegerFromDic(dic, @"port");
    pa.serverDNSname = WantStringFromDic(dic, @"serverDNSname");
    pa.scheme        = WantStringFromDic(dic, @"scheme");
    pa.host          = WantStringFromDic(dic, @"host");
    if ([pa.host isEqualToString:DEV_HOST]) {
        [pa inferServerDNSnameFromHost:pa.host];
    }

    return pa;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    PutIntegerInDic(self.port, dic, @"port");
    PutStringInDic(self.serverDNSname, dic, @"serverDNSname");
    PutStringInDic(self.scheme, dic, @"scheme");
    PutStringInDic(self.host, dic, @"host");
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

- (NSString *)description {
    return [NSString stringWithFormat:@"%@://%@:%u", self.scheme, self.serverDNSname, (unsigned int) self.port];
}

- (void)dealloc {
    GE_DEALLOC();
}

@end
