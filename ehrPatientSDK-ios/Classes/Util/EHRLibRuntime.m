//
// Created by Yves Le Borgne on 2023-01-27.
//

#import "EHRLibRuntime.h"
#import "PehrSDKConfig.h"

PehrSDKConfig *EHRLib;

@implementation EHRLibRuntime
+(void) initialize {
    EHRLib=[PehrSDKConfig shared];
}
@end