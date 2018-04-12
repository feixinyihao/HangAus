//
//  HomeViewController.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/20.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "HomeViewController.h"
#import "CreatePackageViewController.h"
#import "FoodKindPropViewController.h"
#import "SubfoodPriceViewController.h"
#import "FoodPriceViewController.h"
#import "CookWayPriceViewController.h"
#import "OrderViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
-(void)setupUI{
    NSArray*btnArray=@[@"分类管理",@"创建套餐",@"配料价格",@"主食价格",@"烹饪价格",@"点餐"];
    for (int i=0; i<btnArray.count; i++) {
        CGFloat spacing=20;
        UIButton*optionBtn=[[UIButton alloc]initWithFrame:CGRectMake(spacing+i%3*((kScreenW-spacing*4)/3+spacing), 40+i/3*80, (kScreenW-spacing*4)/3, 60)];
        [optionBtn setTitle:btnArray[i] forState:UIControlStateNormal];
        [optionBtn setBackgroundColor:KmainColor];
        [self.view addSubview:optionBtn];
        optionBtn.layer.masksToBounds=YES;
        optionBtn.layer.cornerRadius=5;
        optionBtn.tag=1000+i;
        [optionBtn addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)optionClick:(UIButton*)button{
   
    NSArray*classArray=@[@"FoodKindPropViewController",
                         @"CreatePackageViewController",
                         @"SubfoodPriceViewController",
                         @"FoodPriceViewController",
                         @"CookWayPriceViewController",
                         @"OrderViewController"];
    if ((button.tag-1000)<classArray.count) {
        id obj=[[NSClassFromString(classArray[button.tag-1000]) alloc]init];
        [self.navigationController pushViewController:obj animated:YES];
    }
}
@end
