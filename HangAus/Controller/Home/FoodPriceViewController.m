//
//  FoodPriceViewController.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/9.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "FoodPriceViewController.h"
#import "MBProgressHUD+MJ.h"
#import "UniHttpTool.h"
#import "SoldFood.h"
#import "SubFoodCell.h"
#import <MJExtension.h>
@interface FoodPriceViewController ()<UITableViewDelegate,UITableViewDataSource,SubFoodCellDelegate>
@property(nonatomic,weak)UITableView*tableView;
@property(nonatomic,strong)NSArray*soldfoodArray;
@end

@implementation FoodPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTable];
    [self setupData];
    self.title=@"修改价格";
}

-(void)setupData{
    [MBProgressHUD showHUDAddedTo:nil animated:YES];
    [UniHttpTool getwithparameters:nil option:GetSoldFood success:^(id json) {
        NSMutableArray*temp=[NSMutableArray array];
        for (NSDictionary*dict in json[@"data"]) {
            SoldFood*soldfood=[SoldFood mj_objectWithKeyValues:dict];
            [temp addObject:soldfood];
        }
        self.soldfoodArray=temp;
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
    return self.soldfoodArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SubFoodCell*cell=[SubFoodCell initWithTableView:tableView];
    cell.soldfood=self.soldfoodArray[indexPath.row];
    cell.delegate=self;
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)SubFoodCellBtnClick:(UIButton *)button withCell:(SubFoodCell *)cell withStr:(NSString *)str{
    NSIndexPath*indexPath=[self.tableView indexPathForCell:cell];
    SoldFood*soldfood=self.soldfoodArray[indexPath.row];
    NSDictionary*parm=[soldfood mj_keyValues];
    [parm setValue:[NSString stringWithFormat:@"%.f",[str floatValue]*100] forKey:@"dwUnitPrice"];
    [UniHttpTool getwithparameters:parm option:SetSoldFood success:^(id json) {
        if ([json[@"ret"] integerValue]==0) {
            NSDictionary*dict=json[@"data"];
            soldfood.dwUnitPrice=[dict[@"dwUnitPrice"] integerValue];
        }
    }];
    
}
-(NSArray *)soldfoodArray{
    if (!_soldfoodArray) {
        _soldfoodArray=[NSArray array];
    }
    return _soldfoodArray;
}

@end
