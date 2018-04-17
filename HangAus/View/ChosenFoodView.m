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
    CGRect rect=CGRectMake(0, 0, 0, 0);
    BOOL isNewline=NO;
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
            CustomButton*nameBtn=[[CustomButton alloc]init];
            nameBtn.tag=i+1000;
            NSArray*array=[ShowFood bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"dwShowFoodID"),bg_sqlValue(@(chosenFood.dwShowFoodID))]];
            ShowFood*showfood=[array firstObject];
            CGSize textSzie=[showfood.szDispName sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];
            CGSize size=CGSizeMake(textSzie.width+20, textSzie.height);
            if ((20+rect.origin.x+rect.size.width+size.width)>self.bounds.size.width) {
                isNewline=YES;
                rect=CGRectMake(0, 0, 0, 0);
            }
            nameBtn.frame=CGRectMake(10+rect.origin.x+rect.size.width, 10+isNewline*25, size.width+10, 20);
            rect=nameBtn.frame;
            [nameBtn setTitle:showfood.szDispName forState:UIControlStateNormal];
            [nameBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:nameBtn];
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
@end
