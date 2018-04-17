//
//  ChoseSubFoodView.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/4/8.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "ChoseSubFoodView.h"
#import "CheckBoxBtn.h"
#import "ShopSubFood.h"
#import <BGFMDB.h>
@interface ChoseSubFoodView()

@end
@implementation ChoseSubFoodView
-(instancetype)initWithFrame:(CGRect)frame incSubfood:(NSInteger)incSubfood withSubfood:(NSInteger)subfood{
    if ([super initWithFrame:frame]) {
        if (self) {
            [self setupViewWithincSubfood:incSubfood withSubfood:subfood withFrame:frame];
           
        }
    }
    return self;
}

-(void)setupViewWithincSubfood:(NSInteger)incSubfood withSubfood:(NSInteger)subfood withFrame:(CGRect)frame{
    NSArray*shopSubFoodArray=[ShopSubFood bg_findAll:nil];
    CGRect rect=CGRectZero;
    NSInteger line=0;
    for (int i=0; i<shopSubFoodArray.count; i++) {
        ShopSubFood*shopsubfood=shopSubFoodArray[i];
        CGSize textSzie=[shopsubfood.szName sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
        if ((rect.origin.x+rect.size.width+textSzie.width+30)>frame.size.width) {
            line=line+1;
            rect=CGRectZero;
        }
        //DLog(@"%ld---%ld---%@--%ld",incSubfood,subfood,NSStringFromCGRect(rect),line);
        if ((incSubfood&shopsubfood.dwSFID)==shopsubfood.dwSFID) {
            CheckBoxBtn*checkbox=[[CheckBoxBtn alloc]initWithFrame:CGRectMake(rect.origin.x+rect.size.width+10, 10+25*line, textSzie.width+30, 20) withSelected:YES withTitle:shopsubfood.szName];
            checkbox.tag=shopsubfood.dwSFID;
            rect=checkbox.frame;
            [checkbox addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:checkbox];
           
        }else{
            if ((subfood&shopsubfood.dwSFID)==shopsubfood.dwSFID) {
                CheckBoxBtn*checkbox=[[CheckBoxBtn alloc]initWithFrame:CGRectMake(rect.origin.x+rect.size.width+10, 10+25*line, textSzie.width+30, 20) withSelected:NO withTitle:shopsubfood.szName];
                checkbox.tag=shopsubfood.dwSFID;
                rect=checkbox.frame;
                [checkbox addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:checkbox];
               
            }
           
        }
        
    }
}

-(void)checkboxClick:(CheckBoxBtn*)checkbox{
    NSInteger subfoodprop;
    if (checkbox.selected) {
        subfoodprop=-checkbox.tag;
    }else{
        subfoodprop=checkbox.tag;
    }
    checkbox.selected=!checkbox.selected;
    if ([self.delegate respondsToSelector:@selector(ChoseSubFoodViewBtnClick:withincSubfood:)]) {
        [self.delegate ChoseSubFoodViewBtnClick:checkbox withincSubfood:subfoodprop];
    }
    
}


@end
