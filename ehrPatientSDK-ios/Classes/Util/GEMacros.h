//
//  GEMacros.h
//  Max Power
//
//  Created by Yves Le Borgne on 11-08-20.
//  // Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

//#define MP_DEBUG 1

#import <Foundation/Foundation.h>
#include "GERuntimeConstants.h"
#import "PehrSDKConfig.h"


//@class SKPaymentTransaction;

/*
//
//@interface GEMacros : NSObject {
//
//}

#define GE_ALLOC()                                   \
do {                                                 \
_numberOfInstances++;                                \
_lifeTimeInstances++;                                   \
_instanceNumber=_lifeTimeInstances;                     \
[GERuntimeConstants addAllocatedClass:self.class.description];          \
} while(0)                                           \

#define GE_ALLOC_ECHO()                                     \
do {                                                                                                    \
    MPLOG(@" alloc [%ld]/[%08X], [%ld] left.",(long)_instanceNumber,(int)self,(long)_numberOfInstances);    \
} while (0)\

#define GE_DEALLOC()                                 \
do {                                                 \
_numberOfInstances--;                                \
} while(0)                                           \

#define GE_DEALLOC_ECHO()                                                                                \
do {                                                                                                    \
MPLOG(@"dealloc [%ld]/[%08X], [%ld] left.",(long)_instanceNumber,(int)self,(long)_numberOfInstances);    \
} while (0)\
*/

//#define __MPLOGWITHFUNCTION(s, ...) \
//NSLog(@"%s : %@",__FUNCTION__,[NSString stringWithFormat:(s), ##__VA_ARGS__])

//#define __MPLOG(s, ...) \
//NSLog(@"%@",[NSString stringWithFormat:(s), ##__VA_ARGS__])

#define NOOP

;

#define GEOMETRY() \
__unused     CGRect windowBoundsFrame = [UIScreen mainScreen].bounds; \
__unused     CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame; \
__unused CGRect navigationControllerFrame = self.navigationController.navigationBar.frame; \

#define __MPLOGWITHFUNCTION(s, ...) \
QuietLog(@"%s : %@",__FUNCTION__,[NSString stringWithFormat:(s), ##__VA_ARGS__])

#define __MPLOGDEBUGWITHFUNCTION(s, ...) \
QuietLog(@"%s : %@",__FUNCTION__,[NSString stringWithFormat:(s), ##__VA_ARGS__])

#define __MPLOG(s, ...) \
QuietLog (@"%@",[NSString stringWithFormat:(s), ##__VA_ARGS__])

#if !defined(MP_DEBUG) || MP_DEBUG == 0
#define MPLOGWARN(...) do {} while (0)
#define MPLOGINFO(...) do {} while (0)
#define MPLOG(...) __MPLOGWITHFUNCTION(__VA_ARGS__)
#define MPLOGERROR(...) NSLog(__VA_ARGS__)
#define MPLOGDEBUG(...) do {} while (0)
#define MPLOGSCRIPT(...) __MPLOG(__VA_ARGS__)
#define TRACE(...)  NOOP
#define TRACE_ON   NOOP
#define TRACE_OFF  NOOP
#define TRACE_KILLROY  NOOP
#define GE_ALLOC() NOOP
#define GE_DEALLOC() NOOP
#define GE_ALLOC_ECHO() NOOP
#define GE_DEALLOC_ECHO() NOOP

#elif MP_DEBUG == 1

#define MPLOG(...) __MPLOGWITHFUNCTION(__VA_ARGS__)
#define MPLOGWARN(...) __MPLOGWITHFUNCTION(__VA_ARGS__)
#define MPLOGINFO(...) __MPLOGWITHFUNCTION(__VA_ARGS__)
#define MPLOGERROR(...) __MPLOGWITHFUNCTION(__VA_ARGS__)
//#define MPLOGDEBUG(...) __MPLOGDEBUGWITHFUNCTION(__VA_ARGS__)
#define MPLOGDEBUG(...) do {} while (0)
#define MPLOGSCRIPT(...) __MPLOG(__VA_ARGS__)
#define TRACE                            \
if(_trace)                               \
      MPLOG \

#define TRACE_ON                         \
static BOOL _trace = YES;                \
static NSInteger _lifeTimeInstances = 0; \
static NSInteger _numberOfInstances = 0; \
+(NSInteger) numberOfInstances {         \
    return _numberOfInstances;           \
}                                        \
-(NSInteger) instanceNumber {            \
    return _instanceNumber;              \
}                                        \

#define TRACE_KILLROY                   \
    TRACE(@"[%ld]/[%08X]",(long)_instanceNumber,(int) self);

#define TRACE_OFF                        \
static BOOL _trace = NO;                 \
static NSInteger _lifeTimeInstances = 0; \
static NSInteger _numberOfInstances = 0; \
+(NSInteger) numberOfInstances {         \
    return _numberOfInstances;           \
}                                        \
-(NSInteger) instanceNumber {            \
    return _instanceNumber;              \
}                                        \

#define GE_ALLOC()                                                 \
                                                                   \
do {                                                               \
                                                                   \
_numberOfInstances++;                                              \
_lifeTimeInstances++;                                              \
_instanceNumber=_lifeTimeInstances;                                \
[GERuntimeConstants addAllocatedClass:self.class.description];     \
} while(0);                                                        \

#define GE_ALLOC_ECHO()                                                                                 \
if(_trace)    {                                                                                         \
do {                                                                                                    \
MPLOG(@" alloc [%ld]/[%08X], [%ld] left.",(long)_instanceNumber,(int)self,(long)_numberOfInstances);    \
} while (0);                                                                                            \
}                                                                                                       \

#define GE_DEALLOC()                                 \
do {                                                 \
_numberOfInstances--;                                \
} while(0)                                           \

#define GE_DEALLOC_ECHO()                                                                                \
if(_trace)    {                                                                                          \
do {                                                                                                     \
MPLOG(@"dealloc [%ld]/[%08X], [%ld] left.",(long)_instanceNumber,(int)self,(long)_numberOfInstances);    \
} while (0);                                                                                              \
}                                                                                                        \

#elif MP_DEBUG > 1
#define MPLOGWARN(...) __MPLOGWITHFUNCTION(__VA_ARGS__)
#define MPLOGINFO(...) __MPLOGWITHRUNCTION(__VA_ARGS__)
#define MPLOG(...) __MPLOGWITHFUNCTION(__VA_ARGS__)
#define MPLOGDEBUG(...) __MPLOGWITHFUNCTION(__VA_ARGS__)
#define MPLOGSCRIPT(...) __MPLOG(__VA_ARGS__)
#define TRACE MPLOG

#endif // MP_DEBUG = 1

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define RELEASE_AND_NIL(__ivar__)\
do{ \
__ivar__ = nil; \
} while(0)\





