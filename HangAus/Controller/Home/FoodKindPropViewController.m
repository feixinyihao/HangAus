//
//  FoodKindPropViewController.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/9.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "FoodKindPropViewController.h"
#import "UniHttpTool.h"
#import "FoodKind.h"
#import <MJExtension.h>
#import "EditFoodKindPropViewController.h"
#import "MBProgressHUD+MJ.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
@interface FoodKindPropViewController ()
@property(nonatomic,strong)NSArray*foodKindArray;
@end

@implementation FoodKindPropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super viewDidLoad];
    self.tableView.tableFooterView=[[UIView alloc]init];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupUI{
    [MBProgressHUD showHUDAddedTo:nil animated:YES];
    [UniHttpTool getwithparameters:nil option:GetFoodKind success:^(id json) {
        if ([json[@"ret"] integerValue]==0) {
            NSMutableArray*temp=[NSMutableArray array];
            for (NSDictionary*dict in json[@"data"]) {
                FoodKind*foodkind=[FoodKind mj_objectWithKeyValues:dict];
                [temp addObject:foodkind];
            }
            self.foodKindArray=temp;
            [self.tableView reloadData];
        }else{
            LoginViewController*login=[[LoginViewController alloc]init];
            BaseNavigationController*base=[[BaseNavigationController alloc]initWithRootViewController:login];
            self.view.window.rootViewController=base;
        }
        [MBProgressHUD hideHUDForView:nil animated:YES];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.foodKindArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    FoodKind*foodkind=self.foodKindArray[indexPath.row];
    cell.textLabel.text=foodkind.szFoodKindName;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FoodKind*foodkind=self.foodKindArray[indexPath.row];
    EditFoodKindPropViewController*edit=[[EditFoodKindPropViewController alloc]init];
    edit.foodkind=foodkind;
    [self.navigationController pushViewController:edit animated:YES];
}


-(NSArray *)foodKindArray{
    if (!_foodKindArray) {
        _foodKindArray=[NSArray array];
    }
    return _foodKindArray;
}

@end
