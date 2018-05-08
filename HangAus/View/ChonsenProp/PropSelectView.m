//
//  PropSelectView.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/28.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "PropSelectView.h"
#import "ShowFood.h"
#import "ChosenSubfoodView.h"
#import "UniHttpTool.h"
#import "ChosenFlavorView.h"
@interface PropSelectView()<ChosenSubfoodViewDelegate,ChosenFlavorViewDelegate>
@property(nonatomic,strong)ShowFood*showFood;
@property(nonatomic,weak)UIView*backgroundView;
@property(nonatomic,strong)NSMutableArray*orderfoods;
@property(nonatomic,assign)BOOL isPackage;
@end

@implementation PropSelectView


-(instancetype)initWithShowFood:(ShowFood *)showfood isPackage:(BOOL)package{
    if ([super init]) {
        if (self) {
            self.showFood=showfood;
            self.isPackage=package;
            self.frame=[UIScreen mainScreen].bounds;
            self.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
            [self setupUI];
        }
    }
    return self;
}
-(instancetype)initWithShowFood:(ShowFood *)showfood withOrderfoods:(NSMutableArray *)orderfoods isPackage:(BOOL)package{
    if ([super init]) {
        if (self) {
            self.showFood=showfood;
            self.isPackage=package;
            self.orderfoods=orderfoods;
            self.frame=[UIScreen mainScreen].bounds;
            self.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
            [self setupUI];
        }
    }
    return self;
}
-(void)setupUI{
    UIView*backgroundView=[[UIView alloc]initWithFrame:CGRectMake(40, 120, kScreenW-80, kScreenH-240)];
    self.backgroundView=backgroundView;
    backgroundView.layer.cornerRadius=5;
    backgroundView.layer.masksToBounds=YES;
    backgroundView.backgroundColor=[UIColor whiteColor];
    [self addSubview:backgroundView];
    //关闭按钮
    UIButton*delBtn=[[UIButton alloc]initWithFrame:CGRectMake(backgroundView.bounds.size.width-25, 0, 25, 25)];
    [delBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:delBtn];
    
    //标题
    UILabel*nameL=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, backgroundView.bounds.size.width, 30)];
    nameL.textAlignment=NSTextAlignmentCenter;
    nameL.font=[UIFont systemFontOfSize:15];
    nameL.textColor=[UIColor blackColor];
    nameL.text=self.showFood.szDispName;
    [backgroundView addSubview:nameL];
    
    if (self.showFood.dwIncSubFood) {
        ChosenSubfoodView*subfoodView=[[ChosenSubfoodView alloc]initWithFrame:CGRectMake(0, 30, backgroundView.bounds.size.width, backgroundView.bounds.size.height-30) withShowFood:self.showFood];
        subfoodView.isPackage=self.isPackage;
        [backgroundView addSubview:subfoodView];
        

        [UniHttpTool getDataWithOption:GetShopSubFood Success:^(NSArray *modelArray) {
            subfoodView.shopSubfoods=modelArray;
            subfoodView.orderfoods=self.orderfoods;
        }];
        
        subfoodView.delegate=self;
    }else if (self.showFood.dwFlavorProp){
        ChosenFlavorView*flaorView=[[ChosenFlavorView alloc]initWithFrame:CGRectMake(0, 30, backgroundView.bounds.size.width, backgroundView.bounds.size.height-30) withShowfood:self.showFood];
        flaorView.isPackage=self.isPackage;
        [backgroundView addSubview:flaorView];
        [UniHttpTool getDataWithOption:GetShopCookWay Success:^(NSArray *modelArray) {
            flaorView.shopCookWay=modelArray;
        }];
        [UniHttpTool getDataWithOption:GetShopFlavor Success:^(NSArray *modelArray) {
            flaorView.shopFlavor=modelArray;
        }];
        flaorView.orderfoods=self.orderfoods;
        flaorView.delegate=self;
    }
   
}
//点击加入购物车
-(void)ChosenSubfoodViewFinish:(OrderFood *)orderfood withView:(id)view withTag:(NSInteger)tag{
    if ([self.delegate respondsToSelector:@selector(PropSelectViewFinish:withView:withIndexPath:withTag:)]) {
        [self.delegate PropSelectViewFinish:orderfood withView:view withIndexPath:self.indexPath withTag:tag];
    }
}

-(void)ChosenFlavorViewFinish:(OrderFood *)orderfood withView:(UIView *)view withTag:(NSInteger)tag{
    if ([self.delegate respondsToSelector:@selector(PropSelectViewFinish:withView:withIndexPath:withTag:)]) {
        [self.delegate PropSelectViewFinish:orderfood withView:view withIndexPath:self.indexPath withTag:tag];
    }
}
-(void)delete{
    [self removeFromSuperview];
}
@end
