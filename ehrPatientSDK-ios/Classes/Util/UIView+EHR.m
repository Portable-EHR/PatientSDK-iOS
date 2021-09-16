//
// Created by Yves Le Borgne on 2015-11-02.
// Copyright (c) 2015-2019 Portable EHR inc. All rights reserved.
//

#import "UIView+EHR.h"

@implementation UIView (EHR)
-(CGPoint)getPosition {
    return self.frame.origin;
}

-(void)setPosition:(CGPoint)position {
    CGRect frame = CGRectMake(position.x,position.y,self.frame.size.width,self.frame.size.height);
    self.frame=frame;
}
@end