//
//  UIView+cxr.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/16.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "UIView+cxr.h"

@implementation UIView (cxr)
-(void)addSubviewWithAnimation:(UIView *)view{
    CATransition *transition =[CATransition animation];
    [transition setDuration:0.25];
    [transition setType:kCATransitionFade];
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [self.layer addAnimation:transition forKey:nil];
    [self addSubview:view];
}
@end
