//
// Created by Yves Le Borgne on 2015-10-23.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "PersistenceManager.h"
#import "GEFileUtil.h"
#import "GEMacros.h"

@implementation PersistenceManager

TRACE_OFF

static NSString *_documentDir;
static NSString *_libraryDir;
static NSString *_resourcesDir;

+ (void)initialize {

    _libraryDir  = [[GEFileUtil sharedFileUtil] getLibraryPath];
    _documentDir = [[GEFileUtil sharedFileUtil] getDocumentsPath];
    _resourcesDir = [_libraryDir stringByAppendingPathComponent:@"resources"];

}

- (id)init {
    if ((self = [super init])) {
        GE_ALLOC();
        GE_ALLOC_ECHO();
    } else {
        MPLOG(@"*** super returned nil!");
    }
    return self;
}

+ (PersistenceManager *)sharedPersistenceManager {
    static dispatch_once_t    once;
    static PersistenceManager *_sharedInstance;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

-(void) dealloc {
    GE_DEALLOC();
    GE_DEALLOC_ECHO();
    MPLOG(@"***** YELP : Singleton deallocating ");
}

@end