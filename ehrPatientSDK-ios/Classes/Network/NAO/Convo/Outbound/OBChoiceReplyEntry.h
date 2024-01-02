//
//  OBChoiceReplyEntry.h
//  EHRPatientSDK
//
//  Created by Vinay on 2023-09-19.
//

#ifndef OBChoiceReplyEntry_h
#define OBChoiceReplyEntry_h

#import <Foundation/Foundation.h>
#import "EHRLibRuntimeGlobals.h"
#import "GERuntimeConstants.h"
#import "EHRInstanceCounterP.h"
#import "EHRNetworkableP.h"

@interface OBChoiceReplyEntry : NSObject <EHRInstanceCounterP, EHRNetworkableP> {

}
@property(nonatomic) NSString *id;
@end

#endif /* OBChoiceReplyEntry_h */
