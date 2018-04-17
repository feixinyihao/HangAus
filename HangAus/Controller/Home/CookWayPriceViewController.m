//
//  CookWayPriceViewController.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/9.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "CookWayPriceViewController.h"
#import "UniHttpTool.h"
#import "SubFoodCell.h"
#import <MJExtension.h>
#import "MBProgressHUD+MJ.h"
#import "ShopCookway.h"
@interface CookWayPriceViewController()<UITableViewDelegate,UITableViewDataSource,SubFoodCellDelegate>
@property(nonatomic,weak)UITableView*tableView;
@property(nonatomic,strong)NSArray*cookwayArray;
@end

@implementation CookWayPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTable];
    [self setupData];
    self.title=@"修改价格";
}

-(void)setupData{
    [MBProgressHUD showHUDAddedTo:nil animated:YES];
    [UniHttpTool getwithparameters:nil option:GetShopCookWay success:^(id json) {
        NSMutableArray*temp=[NSMutableArray array];
        for (NSDictionary*dict in json[@"data"]) {
            ShopCookway*cookway=[ShopCookway mj_objectWithKeyValues:dict];
            [temp addObject:cookway];
        }
        self.cookwayArray=temp;
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
    return self.cookwayArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SubFoodCell*cell=[SubFoodCell initWithTableView:tableView];
    cell.subfood=self.cookwayArray[indexPath.row];
    cell.delegate=self;
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)SubFoodCellBtnClick:(UIButton *)button withCell:(SubFoodCell *)cell withStr:(NSString *)str{
    NSIndexPath*indexPath=[self.tableView indexPathForCell:cell];
    ShopCookway*cookway=self.cookwayArray[indexPath.row];
    NSDictionary*parm=[cookway mj_keyValues];
    [parm setValue:[NSString stringWithFormat:@"%.f",[str floatValue]*100] forKey:@"dwUnitPrice"];
    [UniHttpTool getwithparameters:parm option:SetShopCookWay success:^(id json) {
        if ([json[@"ret"] integerValue]==0) {
            NSDictionary*dict=json[@"data"];
            cookway.dwUnitPrice=[dict[@"dwUnitPrice"] integerValue];
            [MBProgressHUD showSuccess:@"修改成功"];
        }
    }];
    
}
-(NSArray *)cookwayArray{
    if (!_cookwayArray) {
        _cookwayArray=[NSArray array];
    }
    return _cookwayArray;
}


@end
