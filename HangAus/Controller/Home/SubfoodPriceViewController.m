//
//  SubfoodPriceViewController.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/4/8.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "SubfoodPriceViewController.h"
#import "UniHttpTool.h"
#import "ShopSubFood.h"
#import "SubFoodCell.h"
#import <MJExtension.h>
#import "DataBase.h"
#import "MBProgressHUD+MJ.h"
@interface SubfoodPriceViewController ()<UITableViewDelegate,UITableViewDataSource,SubFoodCellDelegate>
@property(nonatomic,weak)UITableView*tableView;
@property(nonatomic,strong)NSArray*subfoodArray;
@end

@implementation SubfoodPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTable];
    [self setupData];
    self.title=@"修改价格";
}
-(void)setupFromDataBase{
    if ([[DataBase sharedDataBase]getAllShopSubFood].count>0) {
        self.subfoodArray=[[DataBase sharedDataBase]getAllShopSubFood];
    }else{
        [self setupData];
    }
}
-(void)setupData{
    [MBProgressHUD showHUDAddedTo:nil animated:YES];
    [[DataBase sharedDataBase]deleteAllShopSubFood];
    [UniHttpTool getwithparameters:nil option:GetShopSubFood success:^(id json) {
        NSMutableArray*temp=[NSMutableArray array];
        for (NSDictionary*dict in json[@"data"]) {
            ShopSubFood*subfood=[ShopSubFood mj_objectWithKeyValues:dict];
            [[DataBase sharedDataBase]addShopShowFood:subfood];
            [temp addObject:subfood];
        }
        self.subfoodArray=temp;
        [self.tableView reloadData];
        [MBProgressHUD hideHUD];
    }];
}
-(void)setupTable{
    UITableView*tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64) style:UITableViewStylePlain];
    tableView.tableFooterView=[[UIView alloc]init];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    [self.view addSubview:self.tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.subfoodArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SubFoodCell*cell=[SubFoodCell initWithTableView:tableView];
    cell.subfood=self.subfoodArray[indexPath.row];
    cell.delegate=self;
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)SubFoodCellBtnClick:(UIButton *)button withCell:(SubFoodCell *)cell withStr:(NSString *)str{
    NSIndexPath*indexPath=[self.tableView indexPathForCell:cell];
    ShopSubFood*subfood=self.subfoodArray[indexPath.row];
    NSDictionary*parm=[subfood mj_keyValues];
    [parm setValue:[NSString stringWithFormat:@"%.f",[str floatValue]*100] forKey:@"dwUnitPrice"];
    [UniHttpTool getwithparameters:parm option:SetShopSubFood success:^(id json) {
        if ([json[@"ret"] integerValue]==0) {
            NSDictionary*dict=json[@"data"];
            subfood.dwUnitPrice=[dict[@"dwUnitPrice"] integerValue];
        }
    }];
    
}
-(NSArray *)subfoodArray{
    if (!_subfoodArray) {
        _subfoodArray=[NSArray array];
    }
    return _subfoodArray;
}

@end
