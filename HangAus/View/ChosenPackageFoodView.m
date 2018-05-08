//
//  ChosenPackageFoodView.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/5/7.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "ChosenPackageFoodView.h"
#import "CustomButton.h"
#import <BGFMDB.h>
#import "ShowFood.h"
#import <PPNumberButton.h>
@implementation ChosenPackageFoodView

-(instancetype)init{
    if ([super init]) {
        if (self) {
            
        }
    }
    return self;
}


-(void)setChosenfood:(ChosenFood *)chosenfood{
    _chosenfood=chosenfood;
    NSArray*array=[ShowFood bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"dwShowFoodID"),bg_sqlValue(@(chosenfood.dwShowFoodID))]];
    ShowFood*showfood=[array firstObject];
    
    UILabel*titleL=[[UILabel alloc]init];
    titleL.text=showfood.szDispName;
    titleL.frame=CGRectMake(10, 0, kScreenW/2, 20);
    titleL.font=[UIFont systemFontOfSize:15];
    [self addSubview:titleL];
    
    PPNumberButton*ppBtn=[[PPNumberButton alloc]init];
    ppBtn.frame=CGRectMake(kScreenW/2, 0, 80, 20);
   // ppBtn.decreaseHide = YES;
    ppBtn.shakeAnimation = YES;
    ppBtn.minValue=1;
    ppBtn.maxValue=10;
    if (showfood.dwSoldProp==2) {
        ppBtn.maxValue=1;
    }
  
    ppBtn.currentNumber=self.chosenfood.dwQuantity;
    ppBtn.increaseImage = [UIImage imageNamed:@"increase"];
    ppBtn.decreaseImage = [UIImage imageNamed:@"decrease"];
    ppBtn.longPressSpaceTime=CGFLOAT_MAX;
    __weak typeof(self) weakSelf = self;
    ppBtn.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus) {
        weakSelf.chosenfood.dwQuantity=number;
        if ([weakSelf.delegate respondsToSelector:@selector(ChosenPackageFoodViewincreaseStatus:withChosenPackageFoodView:)]) {
            [weakSelf.delegate ChosenPackageFoodViewincreaseStatus:increaseStatus withChosenPackageFoodView:weakSelf];
        }
        DLog(@"%ld",self.chosenfood.dwQuantity);
    };
    [self addSubview:ppBtn];
    
    UIButton*delBtn=[[UIButton alloc]init];
    [delBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    delBtn.frame=CGRectMake(kScreenW-30, 0, 20, 20);
    [delBtn addTarget:self action:@selector(del:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:delBtn];
    
}
-(void)del:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(ChosenPackageFoodViewDelete:)]) {
        [self.delegate ChosenPackageFoodViewDelete:self];
    }
}
@end
