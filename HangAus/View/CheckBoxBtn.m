//
//  CheckBoxBtn.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/4/8.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "CheckBoxBtn.h"

@implementation CheckBoxBtn


-(instancetype)initWithFrame:(CGRect)frame withSelected:(BOOL)selected withTitle:(NSString *)title{
    self=[super initWithFrame:frame];
    if (self) {
        self.selected=selected;
        [self setImage:[UIImage imageNamed:@"checkbox_sel"] forState:UIControlStateSelected];
        [self setImage:[UIImage imageNamed:@"checkbox_no"] forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font=[UIFont systemFontOfSize:12];
        [self setTitleColor:KmainColor forState:UIControlStateNormal];
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    return CGRectMake(0, 0, 15, 15);
    
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    return CGRectMake(20, 0,contentRect.size.width-20,contentRect.size.height);
    
}

-(void)setHighlighted:(BOOL)highlighted{}
@end
