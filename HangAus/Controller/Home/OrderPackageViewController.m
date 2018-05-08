//
//  OrderPackageViewController.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/5/4.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "OrderPackageViewController.h"
#import "ShowFood.h"
#import "ChosenFood.h"
#import <BGFMDB.h>
#import "OrderFood.h"
#import "ShopCookway.h"
#import "PackageExchangeCell.h"
#import "PropSelectView.h"
@interface OrderPackageViewController ()<UITableViewDelegate,UITableViewDataSource,PropSelectViewDelegate>
@property(nonatomic,strong)NSArray*inPackageOrderfoods;

@property(nonatomic,weak)UITableView*tableView;
@property(nonatomic,weak)UILabel*totalL;
@property(nonatomic,weak)PropSelectView*propView;
@property(nonatomic,strong)OrderFood*packageOrderfood;
@end

@implementation OrderPackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.showfood.szDispName;
    self.view.backgroundColor=[UIColor whiteColor];
    [self setupOrderfoods];
    [self setupTableView];
    [self setupBottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)setupTableView{
    UITableView*tablView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64-50)];
    tablView.tableFooterView=[[UIView alloc]init];
    tablView.delegate=self;
    tablView.dataSource=self;
    self.tableView= tablView;
    [self.view addSubview:self.tableView];
}
-(void)setupBottomView{
    UIView*bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-64-50, kScreenW, 50)];
    bottomView.backgroundColor=KmainColor;
    [self.view addSubview:bottomView];
    
    UILabel*totalL=[[UILabel alloc]init];
    totalL.frame=CGRectMake(20, 0, kScreenW/2, 50);
    totalL.textColor=[UIColor whiteColor];
    totalL.font=[UIFont systemFontOfSize:15];
    totalL.text=[NSString stringWithFormat:@"合计:$%.2f(优惠:$%.2f)",self.showfood.dwSoldPrice/100.0,self.showfood.dwDiscount/100.0];
    self.totalL=totalL;
    [bottomView addSubview:totalL];
    
    UIButton*didBtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenW*2/3, 0, kScreenW/3, 50)];
    didBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [didBtn setTitle:@"选好了" forState:UIControlStateNormal];
    [didBtn addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:didBtn];
}
-(void)didClick:(UIButton*)sender{
    self.showfood.orderNum=self.showfood.orderNum+1;
    NSMutableArray*temp=[NSMutableArray arrayWithArray:self.inPackageOrderfoods];
    [temp addObject:self.packageOrderfood];
    if (self.VCBlock) {
        self.VCBlock(temp);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setupOrderfoods{
    OrderFood*orderfoodPackage=[[OrderFood alloc]init];
    self.foodIndex=self.foodIndex+1;
    orderfoodPackage.dwFoodIndex=self.foodIndex;
    NSInteger parentIndex=self.foodIndex;
    orderfoodPackage.dwParentIndex=0;
    orderfoodPackage.dwShowFoodID=self.showfood.dwShowFoodID;
    orderfoodPackage.dwStat=0x12;
    orderfoodPackage.dwFoodType=0x4;
    orderfoodPackage.dwSelCookWay=self.showfood.dwCookWayProp;
    orderfoodPackage.szSelSubFood=@"";
    orderfoodPackage.szSelFlavor=@"";
    orderfoodPackage.dwQuantity=1;
    orderfoodPackage.dwFoodPrice=self.showfood.dwSoldPrice;
    orderfoodPackage.dwCookPrice=0;
    orderfoodPackage.dwSubFoodPrice=0;
    orderfoodPackage.dwFlavorPrice=0;
    orderfoodPackage.dwFoodDiscount=0;
    orderfoodPackage.dwSubFoodDiscount=0;
    orderfoodPackage.szShowFoodName=self.showfood.szDispName;
    orderfoodPackage.dwGroupID=self.showfood.dwGroupID;
    orderfoodPackage.szMemo=@"";
    self.packageOrderfood=orderfoodPackage;
    NSMutableArray*temp=[NSMutableArray array];
    for (int i=0; i<self.showfood.ChosenFoods.count; i++) {
        //根据套餐内食物获取showfood
        ChosenFood*chosenfood=self.showfood.ChosenFoods[i];
        NSArray*array=[ShowFood bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"dwShowFoodID"),bg_sqlValue(@(chosenfood.dwShowFoodID))]];
        
        ShowFood*chosenShowfood=[array firstObject];
        OrderFood*orderfood=[[OrderFood alloc]init];
       
        orderfood.dwParentIndex=parentIndex;
        orderfood.dwShowFoodID=chosenShowfood.dwShowFoodID;
        orderfood.dwStat=0x12;
        orderfood.dwFoodType=0x2;
        orderfood.szSelCookWay=@"";
        orderfood.szMemo=@"";
        for (ShopCookway*cookway in [ShopCookway bg_findAll:nil]) {
            if ((chosenShowfood.dwCookWayProp&cookway.dwCWID)==cookway.dwCWID) {
                orderfood.dwSelCookWay=cookway.dwCWID;
                orderfood.szSelCookWay=cookway.szShowName;
                break;
            }
        }
        orderfood.szSelSubFood=@"";
        orderfood.szSelFlavor=@"";
        orderfood.dwQuantity=chosenfood.dwQuantity;
        orderfood.dwFoodPrice=chosenShowfood.dwSoldPrice;
        if (chosenShowfood.dwSoldProp==2) {
            orderfood.dwQuantity=1;
            orderfood.dwFoodPrice=chosenShowfood.dwUnitPrice*chosenfood.dwQuantity/1000;
        }

        orderfood.dwCookPrice=0;
        orderfood.dwSubFoodPrice=0;
        orderfood.dwFlavorPrice=0;
        orderfood.dwFoodDiscount=chosenShowfood.dwDiscount;
        orderfood.dwSubFoodDiscount=0;
        orderfood.szShowFoodName=chosenShowfood.szDispName;
        if (orderfood.dwQuantity>1) {
            NSInteger x=orderfood.dwQuantity;
            orderfood.dwQuantity=1;
            for (int j=0; j<x; j++) {
                self.foodIndex=self.foodIndex+1;
                orderfood.dwFoodIndex=self.foodIndex;
                [temp addObject:[orderfood copy]];
            }
        }else{
            self.foodIndex=self.foodIndex+1;
            orderfood.dwFoodIndex=self.foodIndex;
            [temp addObject:orderfood];
        }
       
    }
    self.inPackageOrderfoods=[temp copy];
}


#pragma mark TableViewDelegte
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.inPackageOrderfoods.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PackageExchangeCell*cell=[[PackageExchangeCell alloc]init];
    
    cell.orderfood=self.inPackageOrderfoods[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderFood*orderfood=self.inPackageOrderfoods[indexPath.row];
    NSArray*array=[ShowFood bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"dwShowFoodID"),bg_sqlValue(@(orderfood.dwShowFoodID))]];
    ShowFood*showfood=[array firstObject];
    if (showfood.dwCookWayProp||showfood.dwFlavorProp||showfood.dwIncSubFood) {
        PropSelectView*propView=[[PropSelectView alloc]initWithShowFood:showfood isPackage:YES];
        propView.delegate=self;
        propView.indexPath=indexPath;
        
        self.propView=propView;
        [self.navigationController.view addSubview:propView];
    }
    DLog(@"%@",orderfood.szSelFlavorArrayStr);
}
-(void)PropSelectViewFinish:(OrderFood *)orderfood withView:(UIView *)view withIndexPath:(NSIndexPath *)indexPath withTag:(NSInteger)tag{
    OrderFood*myOrderfood=self.inPackageOrderfoods[indexPath.row];
    myOrderfood.dwCookPrice=orderfood.dwCookPrice;
    myOrderfood.dwSelCookWay=orderfood.dwSelCookWay;
    myOrderfood.dwFlavorPrice=orderfood.dwFlavorPrice;
    myOrderfood.dwSubFoodPrice=orderfood.dwSubFoodPrice;
    myOrderfood.szSelCookWay=orderfood.szSelCookWay;
    myOrderfood.szSelFlavor=orderfood.szSelFlavor;
    myOrderfood.szSelSubFood=orderfood.szSelSubFood;
    myOrderfood.szSelFlavorArrayStr=orderfood.szSelFlavorArrayStr;
    myOrderfood.szSelSubFoodArrayStr=orderfood.szSelSubFoodArrayStr;
    [self.tableView reloadData];
   // [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.propView removeFromSuperview];
}
@end
