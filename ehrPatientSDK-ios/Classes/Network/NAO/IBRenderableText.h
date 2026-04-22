//
//  IBConsentInfo.h
//  ehrPatientSDK-ios
//
//

#ifndef IBConsentInfo_h
#define IBConsentInfo_h

#import <Foundation/Foundation.h>
#import "EHRInstanceCounterP.h"
#import "EHRNetworkableP.h"
#import "NSDictionary+JSON.h"

@interface IBRenderableText : NSObject <EHRInstanceCounterP, EHRNetworkableP, EHRPersistableP> {
    NSInteger _instanceNumber;
    NSString  *_renderer;
    NSString  *_text;
}

@property(nonatomic) NSString *renderer;
@property(nonatomic) NSString *text;

- (BOOL)isPlainText __attribute__((unused));
- (BOOL)isMarkdown __attribute__((unused));
- (BOOL)isHtml __attribute__((unused));

@end

#endif /* IBConsentInfo_h */
