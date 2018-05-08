//
//  ChosenFoodView.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/22.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "ChosenFoodView.h"
#import "ChosenFood.h"
#import "CustomButton.h"
#import "ShowFood.h"
#import <BGFMDB.h>
#import "ChosenPackageFoodView.h"
@interface ChosenFoodView()<ChosenPackageFoodViewDelegate>

@end
@implementation ChosenFoodView

-(instancetype)initWithFrame:(CGRect)frame chosenFoods:(NSArray*)chosenFoods{
    if ([super initWithFrame:frame]) {
        if (self) {
            self.chosenFoods=[NSMutableArray arrayWithArray:chosenFoods];
            [self setupWithChosenFoods:chosenFoods];
            
            
          
        }
    }
    return self;
}
-(void)setupWithChosenFoods:(NSArray*)chosenFoods{
    for (UIView*view in self.subviews) {
        [view removeFromSuperview];
    }

    if (chosenFoods.count==0) {
        UILabel*textL=[[UILabel alloc]init];
        textL.frame=self.bounds;
        textL.font=[UIFont systemFontOfSize:15];
        textL.textAlignment=NSTextAlignmentCenter;
        textL.text=@"请添加套餐食物";
        textL.textColor=KmainColor;
        [self addSubview:textL];
    }else{
        for (int i=0; i<chosenFoods.count; i++) {
            ChosenFood*chosenFood=chosenFoods[i];
            
            ChosenPackageFoodView*packagefood=[[ChosenPackageFoodView alloc]init];
            packagefood.tag=1000+i;
            packagefood.delegate=self;
            packagefood.frame=CGRectMake(0, 30*i+10, kScreenW, 20);
            packagefood.chosenfood=chosenFood;
            [self addSubview:packagefood];
        }
        
    }
    
}
-(void)btnClick:(CustomButton*)btn{
    [self.chosenFoods removeObjectAtIndex:btn.tag-1000];
    [self setupWithChosenFoods:self.chosenFoods];
    if ([self.delegate respondsToSelector:@selector(ChosenFoodViewBtnClick:withChosenFoods:)]) {
        [self.delegate ChosenFoodViewBtnClick:btn withChosenFoods:self.chosenFoods];
    }
}

-(void)reload{
    [self setupWithChosenFoods:self.chosenFoods];

}

-(void)ChosenPackageFoodViewDelete:(ChosenPackageFoodView *)ChosenPackageFoodView{
    DLog(@"%ld",ChosenPackageFoodView.tag);
    [self.chosenFoods removeObjectAtIndex:ChosenPackageFoodView.tag-1000];
    [self setupWithChosenFoods:self.chosenFoods];
    if ([self.delegate respondsToSelector:@selector(ChosenFoodViewBtnClick:withChosenFoods:)]) {
        [self.delegate ChosenFoodViewBtnClick:nil withChosenFoods:self.chosenFoods];
    }
}

-(void)ChosenPackageFoodViewincreaseStatus:(BOOL)increaseStatus withChosenPackageFoodView:(ChosenPackageFoodView *)ChosenPackageFoodView{
    if ([self.delegate respondsToSelector:@selector(ChosenFoodViewBtnClick:withChosenFoods:)]) {
        [self.delegate ChosenFoodViewBtnClick:nil withChosenFoods:self.chosenFoods];
    }
}
@end
