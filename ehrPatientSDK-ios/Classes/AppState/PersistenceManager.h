//
// Created by Yves Le Borgne on 2015-10-23.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersistenceManager : NSObject {

    NSInteger _instanceNumber;

}

+(PersistenceManager *) sharedPersistenceManager;

@end