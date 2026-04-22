//
// Created by Yves Le Borgne on 2023-01-31.
//

#import <Foundation/Foundation.h>

@interface EHRUserRegistrationManifest : NSObject <EHRInstanceCounterP, EHRPersistableP> {

}

@property (nonatomic) NSString *email;
@property (nonatomic) NSString *HCIN;
@property (nonatomic) NSString *HCINjurisdiction;
@property (nonatomic) NSString *mobilePhone;
//@property (nonatomic) NSString *dispensaryGuid;

@end
