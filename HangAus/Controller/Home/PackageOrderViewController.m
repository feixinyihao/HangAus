//
//  PackageOrderViewController.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/11.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "PackageOrderViewController.h"
#import "ShowFood.h"
#import "ChosenFood.h"
#import "DataBase.h"
#import "ShopSubFood.h"
#import "PackageExchange.h"
#import "PackageExchangeCell.h"
@interface PackageOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView*tableView;
@property(nonatomic,weak)UILabel*totalL;

@property(nonatomic,assign)NSInteger selectedRow;

@property(nonatomic,strong)NSArray*packageExchanges;
@end

@implementation PackageOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedRow=-1;
    self.view.backgroundColor=[UIColor whiteColor];
    [self setupTable];
    self.title=self.showfood.szDispName;
    [self setupBottomView];
    [self setupData];
    
}
-(void)setupTable{
    UITableView*tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64-50) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.tableFooterView=[[UIView alloc]init];
    self.tableView=tableView;
    [self.view addSubview:tableView];
}
-(void)setupData{
    NSMutableArray*temp=[NSMutableArray array];
    for (int i=0; i<self.showfood.ChosenFoods.count; i++) {
        ChosenFood*chosenfood=self.showfood.ChosenFoods[i];
        PackageExchange*packexchange=[[PackageExchange alloc]init];
        packexchange.chosenShowFood=[[DataBase sharedDataBase]getShowFoodWithID:chosenfood.dwShowFoodID];
       // packexchange.sameGroupFoods=[[DataBase sharedDataBase]getShowFoodEqual:[NSString stringWithFormat:@"%ld",packexchange.chosenShowFood.dwGroupID]];
        [temp addObject:packexchange];
    }
    self.packageExchanges=temp;
}
-(void)setupBottomView{
    UIView*bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-64-50, kScreenW, 50)];
    bottomView.backgroundColor=KmainColor;
    [self.view addSubview:bottomView];
    
    UILabel*totalL=[[UILabel alloc]init];
    totalL.frame=CGRectMake(20, 0, kScreenW/2, 50);
    totalL.textColor=[UIColor whiteColor];
    totalL.text=[NSString stringWithFormat:@"合计:%.2f",[self returnPriceFromShowFood:self.showfood isDiscount:YES]/100.0];
    self.totalL=totalL;
    [bottomView addSubview:totalL];
    
    UIButton*didBtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenW*2/3, 0, kScreenW/3, 50)];
    [didBtn setTitle:@"选好了" forState:UIControlStateNormal];
    [bottomView addSubview:didBtn];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showfood.ChosenFoods.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PackageExchangeCell*cell=[PackageExchangeCell initWithTableView:tableView];
    cell.package=self.packageExchanges[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PackageExchange*pe=self.packageExchanges[indexPath.row];
    if (indexPath.row==self.selectedRow) {
        return pe.cellHigh;
    }else{
        return 50;
    }
   
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PackageExchange*packexchange=self.packageExchanges[indexPath.row];
    packexchange.sameGroupFoods=[[DataBase sharedDataBase]getShowFoodEqual:[NSString stringWithFormat:@"%ld",packexchange.chosenShowFood.dwGroupID]];
    if (self.selectedRow==indexPath.row) {
        self.selectedRow=-1;
    }else{
        self.selectedRow=indexPath.row;
    }
    
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(NSInteger)returnPriceFromShowFood:(ShowFood*)showfood isDiscount:(BOOL)discount{
    //论重量卖
    if (showfood.dwSoldProp==2) {
        if (showfood.dwDefQuantity==0) {
            return discount?showfood.dwUnitPrice-showfood.dwDiscount: showfood.dwUnitPrice;
        }else{
            return discount?roundf(showfood.dwUnitPrice*showfood.dwDefQuantity/1000.0-showfood.dwDiscount):roundf(showfood.dwUnitPrice*showfood.dwDefQuantity/1000.0);
        }
        //套餐
    }else if (showfood.dwShowProp==2){
        NSInteger total=0;
        for (int i=0; i<showfood.ChosenFoods.count; i++) {
            ChosenFood*chosenfood=showfood.ChosenFoods[i];
            ShowFood*chosenShowfood=[[DataBase sharedDataBase]getShowFoodWithID:chosenfood.dwShowFoodID];
            if (chosenShowfood.dwSoldProp==2) {
                chosenShowfood.dwDefQuantity=chosenfood.dwQuantity;
                total=total+[self returnPriceFromShowFood:chosenShowfood isDiscount:NO];
            }else{
                total=total+[self returnPriceFromShowFood:chosenShowfood isDiscount:NO]*chosenfood.dwQuantity;
            }
        }
        return discount?total-showfood.dwDiscount:total;
        //食物包含配料
    }else if (showfood.dwIncSubFood){
        return discount?[self returnTotalPrice:showfood.dwIncSubFood]+showfood.dwUnitPrice-showfood.dwDiscount:[self returnTotalPrice:showfood.dwIncSubFood]+showfood.dwUnitPrice;
    }else{
        return discount?showfood.dwUnitPrice-showfood.dwDiscount:showfood.dwUnitPrice;
    }
}
-(NSInteger)returnTotalPrice:(NSInteger)incSubfood{
    NSArray*subfoodArray=[[DataBase sharedDataBase]getAllShopSubFood];
    NSInteger subPrice=0;
    for (int i=0; i<subfoodArray.count;i++) {
        ShopSubFood*subfood=subfoodArray[i];
        if ((incSubfood&subfood.dwSFID)==subfood.dwSFID) {
            subPrice=subPrice+subfood.dwUnitPrice;
        }
    }
    return subPrice;
}


@end
