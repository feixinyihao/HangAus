//
//  SubfoodBtn.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/17.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "SubfoodBtn.h"
#import "ShopSubFood.h"
@implementation SubfoodBtn

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        if (self) {
            self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.font=[UIFont systemFontOfSize:12];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setBackgroundImage:[CommonFunc imageWithColor:[UIColor orangeColor]] forState:UIControlStateSelected];
            [self setBackgroundImage:[CommonFunc imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
            self.layer.cornerRadius=5;
            self.layer.masksToBounds=YES;
            [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}

-(void)click:(SubfoodBtn*)sender{
    if (self.value==self.subfood.dwMaxValue) {
        [self setValue:self.subfood.dwMinValue];
    }else{
        [self setValue:self.value+1];
    }
    if ([self.delegate respondsToSelector:@selector(SubfoodBtnClick:)]) {
        [self.delegate SubfoodBtnClick:self];
    }

}

-(void)setValue:(NSInteger)value{
    _value=value;
    self.selected=value;
    NSString*str=[self.subfood.szName stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    [self setTitle:[NSString stringWithFormat:@"%@\n%@",str,[self fromValue:value]] forState:UIControlStateNormal];
}
-(NSString*)fromValue:(NSInteger)value{
    if (value==0) {
        if (self.defValue>value&&self.subfood.dwUnitPrice>0) {
            return [NSString stringWithFormat:@"-$%.2f",self.subfood.dwUnitPrice/100.0];
        }else{
            return  @"-";
        }
       
    }else if (self.value==1){
        if (self.defValue==0&&self.subfood.dwUnitPrice>0) {
             return [NSString stringWithFormat:@"+$%.2f",self.subfood.dwUnitPrice/100.0];
        }else{
            return @"+";
        }
       
    }else if (value==2){
        if ((value-self.defValue)>0&&self.subfood.dwUnitPrice>0) {
            return [NSString stringWithFormat:@"++$%.2f",self.subfood.dwUnitPrice*(value-self.defValue)/100.0];
        }else{
            return @"++";
        }
        
    }else if (value==3){
        if ((value-self.defValue)>0&&self.subfood.dwUnitPrice>0) {
            return [NSString stringWithFormat:@"+++$%.2f",self.subfood.dwUnitPrice*(value-self.defValue)/100.0];
        }else{
            return @"+++";
        }
    }else{
        return @"";
    }
}
@end
