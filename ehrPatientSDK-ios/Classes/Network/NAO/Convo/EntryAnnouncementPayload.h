//
//  EntryAnnouncementPayload.h
//  EHRPatientSDK
//
//  Created by Vinay on 2024-05-27.
//

#import "EHRInstanceCounterP.h"
#import "EHRPersistableP.h"
#import "EHRNetworkableP.h"
#import "GEMacros.h"
#import "NSDictionary+JSON.h"

@interface EntryAnnouncementPayload : NSObject <EHRInstanceCounterP, EHRNetworkableP>   {
    NSString  *_text;
}

@property(nonatomic) NSString *text;


@end

