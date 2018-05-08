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
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setBackgroundImage:[CommonFunc imageWithColor:[UIColor orangeColor]] forState:UIControlStateSelected];
            [self setBackgroundImage:[CommonFunc imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
            [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}
-(NSString*)fromValue:(NSInteger)value{
    if (value==0) {
        return  @"-";
    }else if (value==1){
        if (self.shopflavor.dwDefValue==0&&self.shopflavor.dwUnitPrice>0) {
            return [NSString stringWithFormat:@"+$%.2f",self.shopflavor.dwUnitPrice/100.0];
        }else{
            return @"+";
        }
       
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
    if ([self.delegate respondsToSelector:@selector(FlavorButtonClick:)]) {
        [self.delegate FlavorButtonClick:self];
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

@end
