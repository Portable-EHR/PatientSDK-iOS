//
// Created by Yves Le Borgne on 2017-09-18.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AccessState;

@protocol ScannerP <NSObject>
@property(nonatomic) NSString *scanReasonCode;
@property(nonatomic) NSString *scannedCode;
@property(nonatomic) NSString *scannedHost;
+ (instancetype)scannerWithCompletion:(VoidBlock)completionBlock cancel:(VoidBlock)cancelBlock;
@end