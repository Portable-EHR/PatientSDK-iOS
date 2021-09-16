//
//  UICKeyChainStore.m
//  UICKeyChainStore
//
//  Created by Kishikawa Katsumi on 11/11/20.
//  Copyright (c) 2011 Kishikawa Katsumi. All rights reserved.
//

#import "UICKeyChainStore.h"

static NSString *defaultService;

@interface UICKeyChainStore () {
    NSMutableDictionary *itemsToUpdate;
}

@end

@implementation UICKeyChainStore

@synthesize service;
@synthesize accessGroup;

+ (void)initialize {

    [super initialize];
    defaultService = [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)stringForKey:(NSString *)key {

    return [self stringForKey:key service:defaultService accessGroup:nil];
}

+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service {

    return [self stringForKey:key service:service accessGroup:nil];
}

+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup {

    NSData *data = [self dataForKey:key service:service accessGroup:accessGroup];
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

+ (void)setString:(NSString *)value forKey:(NSString *)key {

    [self setString:value forKey:key service:defaultService accessGroup:nil];
}

+ (void)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service {

    [self setString:value forKey:key service:service accessGroup:nil];
}

+ (void)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup {

    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
    [self setData:data forKey:key service:service accessGroup:accessGroup];
}

+ (NSData *)dataForKey:(NSString *)key {

    return [self dataForKey:key service:defaultService accessGroup:nil];
}

+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service {

    return [self dataForKey:key service:service accessGroup:nil];
}

+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup {

    if (!key) {
        NSAssert(NO, @"key must not be nil.");
        return nil;
    }
    if (!service) {
        service = defaultService;
    }

    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [query setObject:(id) kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [query setObject:service forKey:(__bridge id)kSecAttrService];
    [query setObject:key forKey:(__bridge id)kSecAttrGeneric];
    [query setObject:key forKey:(__bridge id)kSecAttrAccount];
#if !TARGET_IPHONE_SIMULATOR && defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    if (accessGroup) {
        [query setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
    }
#endif

    CFDataRef   data  = nil;
//    NSData   *data  = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef) query, (CFTypeRef *) &data);
    if (status != errSecSuccess) {
        return nil;
    }
//    return data;
    return (__bridge_transfer NSData *) data;
}

+ (void)setData:(NSData *)data forKey:(NSString *)key {

    [self setData:data forKey:key service:defaultService accessGroup:nil];
}

+ (void)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service {

    [self setData:data forKey:key service:service accessGroup:nil];
}

+ (void)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup {

    if (!key) {
        NSAssert(NO, @"key must not be nil.");
        return;
    }
    if (!service) {
        service = defaultService;
    }

    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [query setObject:service forKey:(__bridge id)kSecAttrService];
    [query setObject:key forKey:(__bridge id)kSecAttrGeneric];
    [query setObject:key forKey:(__bridge id)kSecAttrAccount];
#if !TARGET_IPHONE_SIMULATOR && defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    if (accessGroup) {
        [query setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
    }
#endif

    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef) query, NULL);
    if (status == errSecSuccess) {
        if (data) {
            NSMutableDictionary *attributesToUpdate = [NSMutableDictionary dictionary];
            [attributesToUpdate setObject:data forKey:(__bridge id)kSecValueData];

            status = SecItemUpdate((__bridge CFDictionaryRef) query, (__bridge CFDictionaryRef) attributesToUpdate);
            if (status != errSecSuccess) {
                NSLog(@"%s|SecItemUpdate: error(%ld)", __func__, (long) status);
            }
        }
        else {
            [self removeItemForKey:key service:service accessGroup:accessGroup];
        }
    }
    else if (status == errSecItemNotFound) {
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        [attributes setObject:service forKey:(__bridge id)kSecAttrService];
        [attributes setObject:key forKey:(__bridge id)kSecAttrGeneric];
        [attributes setObject:key forKey:(__bridge id)kSecAttrAccount];
        [attributes setObject:data forKey:(__bridge id)kSecValueData];
#if !TARGET_IPHONE_SIMULATOR && defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
        if (accessGroup) {
            [attributes setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
        }
#endif

        status = SecItemAdd((__bridge CFDictionaryRef) attributes, NULL);
        if (status != errSecSuccess) {
            NSLog(@"%s|SecItemAdd: error(%ld)", __func__, (long) status);
        }
    }
    else {
        NSLog(@"%s|SecItemCopyMatching: error(%ld)", __func__, (long) status);
    }
}

+ (void)removeItemForKey:(NSString *)key {

    [UICKeyChainStore removeItemForKey:key service:defaultService accessGroup:nil];
}

+ (void)removeItemForKey:(NSString *)key service:(NSString *)service {

    [UICKeyChainStore removeItemForKey:key service:service accessGroup:nil];
}

+ (void)removeItemForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup {

    if (!key) {
        NSAssert(NO, @"key must not be nil.");
        return;
    }
    if (!service) {
        service = defaultService;
    }

    NSMutableDictionary *itemToDelete = [NSMutableDictionary dictionary];
    [itemToDelete setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [itemToDelete setObject:service forKey:(__bridge id)kSecAttrService];
    [itemToDelete setObject:key forKey:(__bridge id)kSecAttrGeneric];
    [itemToDelete setObject:key forKey:(__bridge id)kSecAttrAccount];
#if !TARGET_IPHONE_SIMULATOR && defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    if (accessGroup) {
        [itemToDelete setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
    }
#endif

    OSStatus status = SecItemDelete((__bridge CFDictionaryRef) itemToDelete);
    if (status != errSecSuccess && status != errSecItemNotFound) {
        NSLog(@"%s|SecItemDelete: error(%ld)", __func__, (long) status);
    }
}

+ (NSArray *)itemsForService:(NSString *)service accessGroup:(NSString *)accessGroup {

    if (!service) {
        service = defaultService;
    }

    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [query setObject:(__bridge id) kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
    [query setObject:(__bridge id) kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [query setObject:(__bridge id)kSecMatchLimitAll forKey:(__bridge id)kSecMatchLimit];
    [query setObject:service forKey:(__bridge id)kSecAttrService];
#if !TARGET_IPHONE_SIMULATOR && defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    if (accessGroup) {
        [query setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
    }
#endif

    CFArrayRef result = nil;
    OSStatus   status = SecItemCopyMatching((__bridge CFDictionaryRef) query, (CFTypeRef *) &result);
    if (status == errSecSuccess || status == errSecItemNotFound) {
        return (__bridge NSArray *) result ;
    }
    else {
        NSLog(@"%s|SecItemCopyMatching: error(%ld)", __func__, (long) status);
        return nil;
    }
}

+ (void)removeAllItems {

    [self removeAllItemsForService:defaultService accessGroup:nil];
}

+ (void)removeAllItemsForService:(NSString *)service {

    [self removeAllItemsForService:service accessGroup:nil];
}

+ (void)removeAllItemsForService:(NSString *)service accessGroup:(NSString *)accessGroup {

    NSArray           *items = [UICKeyChainStore itemsForService:service accessGroup:accessGroup];
    for (NSDictionary *item in items) {
        NSMutableDictionary *itemToDelete = [NSMutableDictionary dictionaryWithDictionary:item];
        [itemToDelete setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];

        OSStatus status = SecItemDelete((__bridge CFDictionaryRef) itemToDelete);
        if (status != errSecSuccess) {
            NSLog(@"%s|SecItemDelete: error(%ld)", __func__, (long) status);
            NSLog(@"%@", itemToDelete);
        }
    }
}

#pragma mark -

+ (UICKeyChainStore *)keyChainStore {

    return [[self alloc] initWithService:defaultService];
}

+ (UICKeyChainStore *)keyChainStoreWithService:(NSString *)service {

    return [[self alloc] initWithService:service];
}

+ (UICKeyChainStore *)keyChainStoreWithService:(NSString *)service accessGroup:(NSString *)accessGroup {

    return [[self alloc] initWithService:service accessGroup:accessGroup];
}

- (id)init {

    return [self initWithService:defaultService accessGroup:nil];
}

- (id)initWithService:(NSString *)s {

    return [self initWithService:s accessGroup:nil];
}

- (id)initWithService:(NSString *)s accessGroup:(NSString *)group {

    self = [super init];
    if (self) {
        if (!s) {
            s = defaultService;
        }
        service     = [s copy];
        accessGroup = [group copy];
        if (accessGroup) {
#if !TARGET_IPHONE_SIMULATOR && defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
            [itemsToUpdate setObject:accessGroup forKey:(id) kSecAttrAccessGroup];
#endif
        }

        NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:itemsToUpdate];
        [query setObject:(id) kSecMatchLimitAll forKey:(id) kSecMatchLimit];
        [query setObject:(id) kCFBooleanTrue forKey:(id) kSecReturnAttributes];

//        NSMutableDictionary *result = nil;
        CFMutableDictionaryRef result = nil;
        OSStatus            status  = SecItemCopyMatching((__bridge CFDictionaryRef) query, (CFTypeRef *) &result);
        if (status == errSecSuccess) {
//            itemsToUpdate = [[NSMutableDictionary alloc] initWithDictionary:result];
            itemsToUpdate = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSMutableDictionary *) result];
        }
        else {
            itemsToUpdate = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

- (void)dealloc {
    service=nil;
    accessGroup=nil;
    itemsToUpdate=nil;
}

#pragma mark -

- (NSString *)description {

    NSArray           *items = [UICKeyChainStore itemsForService:service accessGroup:accessGroup];
    NSMutableArray    *list  = [NSMutableArray arrayWithCapacity:[items count]];
    for (NSDictionary *attributes in items) {
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        [attrs setObject:[attributes objectForKey:(__bridge id)kSecAttrService] forKey:@"Service"];
        [attrs setObject:[attributes objectForKey:(__bridge id)kSecAttrAccount] forKey:@"Account"];
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
        [attrs setObject:[attributes objectForKey:(__bridge id)kSecAttrAccessGroup] forKey:@"AccessGroup"];
#endif
        NSData   *data   = [attributes objectForKey:(__bridge id)kSecValueData];
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (string) {
            [attrs setObject:string forKey:@"Value"];
        }
        else {
            [attrs setObject:data forKey:@"Value"];
        }
        [list addObject:attrs];
    }
    return [list description];
}

#pragma mark -

- (void)setString:(NSString *)string forKey:(NSString *)key {

    [self setData:[string dataUsingEncoding:NSUTF8StringEncoding] forKey:key];
}

- (NSString *)stringForKey:(id)key {

    NSData *data = [self dataForKey:key];
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (void)setData:(NSData *)data forKey:(NSString *)key {

    if (!key) {
        return;
    }
    if (!data) {
        [self removeItemForKey:key];
    }
    else {
        [itemsToUpdate setObject:data forKey:key];
    }
}

- (NSData *)dataForKey:(NSString *)key {

    NSData *data = [itemsToUpdate objectForKey:key];
    if (!data) {
        data = [[self class] dataForKey:key service:service accessGroup:accessGroup];
    }
    return data;
}

- (void)removeItemForKey:(NSString *)key {

    if ([itemsToUpdate objectForKey:key]) {
        [itemsToUpdate removeObjectForKey:key];
    }
    else {
        [[self class] removeItemForKey:key service:service accessGroup:accessGroup];
    }
}

#pragma mark -

- (void)removeAllItems __unused {

    [itemsToUpdate removeAllObjects];
    [[self class] removeAllItemsForService:service accessGroup:accessGroup];
}

#pragma mark -

- (void)synchronize __unused {

    for (NSString *key in itemsToUpdate) {
        [[self class] setData:[itemsToUpdate objectForKey:key] forKey:key service:service accessGroup:accessGroup];
    }
}

@end
