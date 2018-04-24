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

@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView=[[UIView alloc]init];
  
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderFoods.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    OrderFood*orderfood=self.orderFoods[indexPath.row];
    cell.textLabel.text=orderfood.szShowFoodName;
    cell.imageView.image=[UIImage imageNamed:@"coca"];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"$%.2f",orderfood.dwFoodPrice/100.0];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
