//
//  FlavorPriceViewController.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/23.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "FlavorPriceViewController.h"
#import "SubFoodCell.h"
#import "ShopFlavor.h"
#import "UniHttpTool.h"
#import <MJExtension.h>
#import "MBProgressHUD+MJ.h"
#import <BGFMDB.h>
#import "SubfoodPriceViewController.h"
@interface FlavorPriceViewController ()<SubFoodCellDelegate>
@property(nonatomic,strong)NSArray*shopflavorArray;
@end

@implementation FlavorPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    self.title=@"口味价格";
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)save{
    SubfoodPriceViewController*subfood=[[SubfoodPriceViewController alloc]init];
    [self.navigationController pushViewController:subfood animated:YES];
}
-(void)setupData{
    NSMutableArray*temp=[NSMutableArray array];
    [UniHttpTool getwithparameters:nil option:GetShopFlavor success:^(id json) {
        for (NSDictionary*dict in json[@"data"]) {
             ShopFlavor*shopflavor=[ShopFlavor mj_objectWithKeyValues:dict];
            [shopflavor bg_saveOrUpdate];
            [temp addObject:shopflavor];
        }
        self.shopflavorArray=temp;
        [self.tableView reloadData];
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2==1) {
        cell.backgroundColor = KColor(223, 239, 246);
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shopflavorArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SubFoodCell*cell=[SubFoodCell initWithTableView:tableView];
    cell.shopFlavor=self.shopflavorArray[indexPath.row];
    cell.delegate=self;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)SubFoodCellBtnClick:(UIButton *)button withCell:(SubFoodCell *)cell withStr:(NSString *)str{
    NSIndexPath*indexPath=[self.tableView indexPathForCell:cell];
    ShopFlavor*shopflavor=self.shopflavorArray[indexPath.row];
    NSDictionary*parm=shopflavor.mj_keyValues;
    [parm setValue:[NSString stringWithFormat:@"%.f",[str floatValue]*100] forKey:@"dwUnitPrice"];
    [UniHttpTool getwithparameters:parm option:SetShopFlavor success:^(id json) {
        [MBProgressHUD showSuccess:@"修改成功"];
        ShopFlavor*result=[ShopFlavor mj_objectWithKeyValues:json[@"data"]];
        shopflavor.dwUnitPrice=result.dwUnitPrice;
        [result bg_saveOrUpdate];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
