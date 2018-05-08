//
//  ChangeBalanceViewController.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/5.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "ChangeBalanceViewController.h"
#import "ShowFood.h"
#import "ChangeBalanceCell.h"
#import "UniHttpTool.h"
#import <MJExtension.h>
#import "SoldFood.h"
#import "MBProgressHUD+MJ.h"
#import "ShowGroup.h"
#import "MainViewController.h"
#import "EditFoodViewController.h"
#import <BGFMDB.h>
@interface ChangeBalanceViewController ()<ChangeBalanceCellDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray*showFoodArray;
@property(nonatomic,weak)UITableView*tableView;
@property(nonatomic,assign)NSInteger setupNum;
@property(nonatomic,assign)BOOL isPop;
@property(nonatomic,weak)UIButton*nextBtn;
@end

@implementation ChangeBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self setupTable];
    self.setupNum=1;
    [self setupData];
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isPop) {
        [self.tableView reloadData];
        
    }else{
        
    }
    _isPop=YES;
}
-(void)setupData{
    [MBProgressHUD showHUDAddedTo:nil animated:YES];
    ShowGroup*showGroup=self.selGroupArray[self.setupNum-1];
    self.title=[NSString stringWithFormat:@"食物初始化(%@)",showGroup.szGroupName];
    NSDictionary*parm=@{@"dwGroupID":@(showGroup.dwGroupID)};
    [UniHttpTool getwithparameters:parm option:GetShowFood success:^(id json) {
        [MBProgressHUD hideHUD];
        if ([json[@"ret"] integerValue]==0) {
            NSMutableArray*temp=[NSMutableArray array];
            for (NSDictionary*dict in json[@"data"]) {
                ShowFood*showFood=[ShowFood mj_objectWithKeyValues:dict];
                if (!(showFood.dwSoldProp==2&&showFood.dwDefQuantity==0)) {
                    if (showFood.dwShowProp==2) {
                        for (int i=0; i<showFood.ChosenFoods.count; i++) {
                            ChosenFood*chosenfood=showFood.ChosenFoods[i];
                            NSArray*array=[ShowFood bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"dwShowFoodID"),bg_sqlValue(@(chosenfood.dwShowFoodID))]];
                            ShowFood*chosenShowfood=[array firstObject];
                            chosenfood.szDisFoodName=chosenShowfood.szDispName;
                            chosenfood.dwSoldPrice=chosenShowfood.dwSoldPrice;
                            chosenfood.dwShowProp=chosenShowfood.dwShowProp;
                        }
                       
                    }
                    [temp addObject:showFood];
                }
                
            }
            self.showFoodArray=temp;
            [self.tableView reloadData];
            NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            if (self.setupNum==self.selGroupArray.count) {
                [self.nextBtn setTitle:@"完成" forState:UIControlStateNormal];
            }
        }
        
    }];
}
-(void)setupTable{
    UITableView*tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64-55)];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    self.tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:self.tableView];
    
    UIButton*saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, kScreenH-50-64, kScreenW-20, 40)];
    [saveBtn setTitle:@"设置下一类" forState:UIControlStateNormal];
    self.nextBtn=saveBtn;
    [saveBtn setBackgroundColor:KmainColor];
    saveBtn.layer.masksToBounds=YES;
    saveBtn.layer.cornerRadius=5;
    [saveBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
}
-(void)next{
    if (self.setupNum==self.selGroupArray.count) {
        [UniHttpTool getwithparameters:nil option:ShopInitOk success:^(id json) {
            
        }];
        MainViewController*main=[[MainViewController alloc]init];
        self.view.window.rootViewController=main;
    }else{
        self.setupNum=self.setupNum+1;
        [self setupData];
    }
    
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showFoodArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChangeBalanceCell*cell=[ChangeBalanceCell initWithTableView:tableView];
    ShowFood*showFood=self.showFoodArray[indexPath.row];
    cell.showFood=showFood;
    cell.delegate=self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowFood*showFood=self.showFoodArray[indexPath.row];
    if (showFood.dwShowProp!=1) {
        EditFoodViewController*edit=[[EditFoodViewController alloc]init];
        edit.showFood=showFood;
        [self.navigationController pushViewController:edit animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowFood*showFood=self.showFoodArray[indexPath.row];
    if (showFood.dwShowProp==1) {
        return 80;
    }else{
        return 100;
    }
    
}

-(void)ChangeBalanceCellBtnClick:(UIButton *)button withCell:(ChangeBalanceCell *)cell withStr:(NSString *)str{
    NSIndexPath*indexPath=[self.tableView indexPathForCell:cell];
    ShowFood*showFood=self.showFoodArray[indexPath.row];
    NSDictionary*dict=@{@"dwShowFoodID":@(showFood.dwShowFoodID),
                        @"dwSoldPrice":@(roundf([str floatValue]*100)),
                        @"dwUnitPrice":@(roundf([str floatValue]*100)),
                        @"dwMinPrice":@(roundf([str floatValue]*100)),
                        };
    
    [UniHttpTool getwithparameters:dict option:SetShowfoodprice success:^(id json) {
        [MBProgressHUD showSuccess:@"修改成功"];
        
    }];
}

-(void)ChangeBalanceCellupdownBtnClick:(UIButton *)button withCell:(ChangeBalanceCell *)cell{
    NSIndexPath*indexPath=[self.tableView indexPathForCell:cell];
    ShowFood*showFood=self.showFoodArray[indexPath.row];
    if ((showFood.dwStat&2)==2) {
        showFood.dwStat=1;
    }else{
        showFood.dwStat=2;
    }
    NSDictionary *parm=showFood.mj_keyValues;
    [UniHttpTool postwithparameters:parm option:SetShowFood success:^(id json) {
        if ([json[@"ret"] integerValue]==0) {
            NSArray<NSIndexPath*>*indexPathArray=@[indexPath];
            [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
        }else{
            KShowServerMessage(json[@"error"])
        }
    }];
}
@end
