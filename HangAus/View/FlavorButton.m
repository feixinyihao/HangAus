//
//  FlavorButton.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/11.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "FlavorButton.h"
#import "ShopFlavor.h"
@implementation FlavorButton

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        if (self) {
            self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.font=[UIFont systemFontOfSize:15];
            [self setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setBackgroundImage:[self imageWithColor:[UIColor yellowColor]] forState:UIControlStateSelected];
            [self setBackgroundImage:[self imageWithColor:[UIColor blueColor]] forState:UIControlStateNormal];
            [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}
-(NSString*)fromValue:(NSInteger)value{
    if (value==0) {
        return  @"-";
    }else if (self.value==1){
        return @"+";
    }else if (value==2){
        return @"++";
    }else if (value==3){
        return @"+++";
    }else{
        return @"";
    }
}
-(void)click:(UIButton*)button{
    if (self.value==self.shopflavor.dwMaxValue) {
        [self setValue:self.shopflavor.dwMinValue];
    }else{
        [self setValue:self.value+1];
    }
}
-(void)setValue:(NSInteger)value{
    _value=value;
    self.selected=value;
    [self setTitle:[NSString stringWithFormat:@"%@ %@",self.shopflavor.szName,[self fromValue:value]] forState:UIControlStateNormal];
}
-(void)setShopflavor:(ShopFlavor *)shopflavor{
    _shopflavor=shopflavor;
    [self setValue:self.shopflavor.dwDefValue];
}
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f); //宽高 1.0只要有值就够了
    UIGraphicsBeginImageContext(rect.size); //在这个范围内开启一段上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);//在这段上下文中获取到颜色UIColor
    CGContextFillRect(context, rect);//用这个颜色填充这个上下文
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//从这段上下文中获取Image属性,,,结束
    UIGraphicsEndImageContext();
    
    return image;
}
@end
