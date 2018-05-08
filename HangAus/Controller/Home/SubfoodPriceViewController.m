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
#import "MBProgressHUD+MJ.h"
#import <BGFMDB.h>
#import "SetupFoodKindViewController.h"
#import "ShowFood.h"
@interface SubfoodPriceViewController ()<UITableViewDelegate,UITableViewDataSource,SubFoodCellDelegate>
@property(nonatomic,weak)UITableView*tableView;
@property(nonatomic,strong)NSArray*subfoodArray;
@end

@implementation SubfoodPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTable];
    [self setupData];
    self.title=@"配菜价格";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)save{
    SetupFoodKindViewController*setupkkind=[[SetupFoodKindViewController alloc]init];
    [self.navigationController pushViewController:setupkkind animated:YES];
}
-(void)setupFromDataBase{
    if ([ShopSubFood bg_findAll:nil].count>0) {
        self.subfoodArray=[ShopSubFood bg_findAll:nil];
    }else{
        [self setupData];
    }
}
-(void)setupData{
    [MBProgressHUD showHUDAddedTo:nil animated:YES];
    [UniHttpTool getwithparameters:nil option:GetShopSubFood success:^(id json) {
        NSMutableArray*temp=[NSMutableArray array];
        for (NSDictionary*dict in json[@"data"]) {
            ShopSubFood*subfood=[ShopSubFood mj_objectWithKeyValues:dict];
            [subfood bg_saveOrUpdate];
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
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2==1) {
        cell.backgroundColor = KColor(223, 239, 246);
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
   
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
    NSDictionary*parm=@{@"dwSFID":@(subfood.dwSFID),
                        @"dwUnitPrice":@(roundf([str floatValue]*100)),
                        @"szMemo":@""
                        };
    NSDictionary*dic=@{@"dwSFID":@(subfood.dwSFID)};
    [UniHttpTool getwithparameters:dic option:GetShowFood success:^(id json) {
        NSString*foodStr=@"";
        for (NSDictionary*dict in json[@"data"]) {
            foodStr=[foodStr stringByAppendingFormat:@"%@,",dict[@"szDispName"]];
        }
        if (foodStr.length>1) {
            foodStr=[foodStr substringToIndex:foodStr.length-1];
        }
        [CommonFunc alert:@"修改会影响以下食物价格" withMessage:foodStr :^(UIAlertAction *acton) {
            
            [UniHttpTool getwithparameters:parm option:SetShopsubfoodprice success:^(id json) {
                subfood.dwUnitPrice=roundf([str floatValue]*100);
                [MBProgressHUD showSuccess:@"修改成功"];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
        }];
    }];
    
   
    
}
-(NSArray *)subfoodArray{
    if (!_subfoodArray) {
        _subfoodArray=[NSArray array];
    }
    return _subfoodArray;
}

@end
