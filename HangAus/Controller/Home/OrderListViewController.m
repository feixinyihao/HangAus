//
//  OrderListViewController.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/24.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderFood.h"
#import <UIImageView+WebCache.h>
@interface OrderListViewController ()
@property(nonatomic,strong)NSArray*noPackagesOrder;
@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    self.tableView.tableFooterView=[[UIView alloc]init];
    
    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(0, kScreenH-64-50, kScreenW, 50)];
    [btn setBackgroundColor:KmainColor];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:btn];
  
}
-(void)setupData{
    NSMutableArray*temp=[NSMutableArray array];
    for (int i=0; i<self.orderFoods.count; i++) {
        OrderFood*orderfood=self.orderFoods[i];
        if (orderfood.dwFoodType!=2) {
            [temp addObject:orderfood];
        }
    }
    self.noPackagesOrder=temp;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.noPackagesOrder.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    OrderFood*orderfood=self.noPackagesOrder[indexPath.row];
    cell.textLabel.text=orderfood.szShowFoodName;
    cell.imageView.image=[UIImage imageNamed:@"coca"];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"$%.2f",orderfood.dwFoodPrice/100.0];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
