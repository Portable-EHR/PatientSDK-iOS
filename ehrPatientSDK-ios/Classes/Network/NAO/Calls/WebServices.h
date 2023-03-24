//
// Created by Yves Le Borgne on 2022-12-28.
//

#import <Foundation/Foundation.h>
#import "GERuntimeConstants.h"
#import "EHRInstanceCounterP.h"
#import "ConvoWS.h"
#import "ConsentWS.h"
#import "CommandsWS.h"
#import "ActivationWS.h"
#import "NotificationWS.h"


@interface WebServices : NSObject <EHRInstanceCounterP>

@property(nonatomic) NotificationWS *notification;
@property(nonatomic) CommandsWS     *commands;
@property(nonatomic) ConsentWS      *consent;
@property(nonatomic) ConvoWS        *convo;
@property(nonatomic) ActivationWS   *activation;

@end
