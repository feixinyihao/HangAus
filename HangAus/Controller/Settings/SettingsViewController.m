//
//  SettingsViewController.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/9.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "SettingsViewController.h"
#import "SetLanTableViewController.h"
#import "SettingViewController.h"
#import "ChangeTradingHourViewController.h"
@interface SettingsViewController ()
@property(nonatomic,strong)NSArray*titleArray;
@property(nonatomic,strong)NSArray*controllerArray;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArray=@[@"多语言",@"店铺信息",@"营业时间",@"评分"];
    self.controllerArray=@[@"SetLanTableViewController",
                           @"SettingViewController",
                           @"ChangeTradingHourViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    tableView.tableFooterView=[[UIView alloc]init];
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text=self.titleArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row<(self.controllerArray.count)) {
        id obj= [[NSClassFromString(self.controllerArray[indexPath.row])alloc]init];
        [self.navigationController pushViewController:obj animated:YES];
       
    }
    
    
}
@end
