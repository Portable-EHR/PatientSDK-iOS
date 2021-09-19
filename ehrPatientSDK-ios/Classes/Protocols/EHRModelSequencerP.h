//
// Created by Yves Le Borgne on 2017-01-23.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EHRModelSequencerP <NSObject>

-(void) pause;
-(void) setInterval:(float)intervalInSeconds;
-(void) resume;
-(void) refreshNow;

@end