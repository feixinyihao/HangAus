//
//  CustomButton.m
//  justprint
//
//  Created by 陈鑫荣 on 2017/11/27.
//  Copyright © 2017年 justprint. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
        self.imageView.contentMode=  UIViewContentModeCenter;
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.font=[UIFont systemFontOfSize:10];
        [self setBackgroundColor:KmainColor];
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=10;
        [self setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    return CGRectMake(contentRect.size.width-20, 0, 20, contentRect.size.height);
    
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    return CGRectMake(0, 0,contentRect.size.width-20,contentRect.size.height);
    
}

-(void)setHighlighted:(BOOL)highlighted{}
@end
