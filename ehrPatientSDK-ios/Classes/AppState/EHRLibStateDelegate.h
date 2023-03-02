//
// Created by Yves Le Borgne on 2023-03-02.
//

#import <Foundation/Foundation.h>

@protocol EHRLibStateDelegate <NSObject>

-(void) setNetworkActivityIndicatorVisible:(BOOL) isIt;

@end