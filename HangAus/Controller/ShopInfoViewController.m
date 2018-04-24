//
//  ShopInfoViewController.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/2.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "ShopInfoViewController.h"
#import "SetupFoodKindViewController.h"
#import <XXPickerView.h>
#import "UniHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "TradingHour.h"
#import <MJExtension.h>
#import "CommonFunc.h"
#import "ShopInfo.h"
#import "CellWithView.h"
#import "WithTextCell.h"
#import "ChangeTradingHourViewController.h"
#import "CookWayPriceViewController.h"
@interface ShopInfoViewController ()<UITableViewDelegate,UITableViewDataSource,XXPickerViewDelegate>
@property(nonatomic,weak)UITableView*tableView;

@property(nonatomic,weak)UITextField*shopNameField;

@property(nonatomic,weak)UITextField*telField;
@property(nonatomic,strong)NSMutableArray*cellModelArray;

@property(nonatomic,strong)ShopInfo*shopinfo;
@end

@implementation ShopInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCellArray];
    [self getShopInfo];
    self.title=@"门店信息";
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title = @"返回";
    self.navigationItem.backBarButtonItem = backbutton;
    self.view.backgroundColor=[UIColor whiteColor];
   
    
    UITableView*tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-84) style:UITableViewStylePlain];
    tableView.tableFooterView=[[UIView alloc]init];
    self.tableView=tableView;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tableViewGesture];
    [self setupUI];
}
-(void)setupCellArray{
    NSDictionary*parm1=@{@"leftTitle":@"餐厅名称:",@"placeholder":@"请输入餐厅名称",@"viewClass":@"UITextField"};
    NSDictionary*parm2=@{@"leftTitle":@"电话:",@"placeholder":@"请输入餐厅简介",@"viewClass":@"UITextField"};
    NSDictionary*parm3=@{@"leftTitle":@"营业时间:",@"viewClass":@"UILabel"};
    NSDictionary*parm4=@{@"leftTitle":@"街道地址:",@"viewClass":@"UITextField"};
    NSDictionary*parm5=@{@"leftTitle":@"门牌号:",@"viewClass":@"UITextField"};
    NSDictionary*parm6=@{@"leftTitle":@"城市:",@"viewClass":@"UITextField"};
    NSDictionary*parm7=@{@"leftTitle":@"洲:",@"viewClass":@"UITextField"};
    NSArray*temp=@[parm1,parm2,parm3,parm4,parm5,parm6,parm7];
    for (int i=0; i<temp.count; i++) {
        CellWithView*cell=[CellWithView mj_objectWithKeyValues:temp[i]];
        [self.cellModelArray addObject:cell];
    }
    
}
-(void)getShopInfo{
    [UniHttpTool getwithparameters:nil option:GetShop success:^(id json) {
        if ([json[@"ret"] integerValue]==0) {
            NSArray*tempArr=json[@"data"];
            ShopInfo*shopinfo=[ShopInfo mj_objectWithKeyValues:[tempArr firstObject]];
            self.shopinfo=shopinfo;
            for (int i=0; i<self.cellModelArray.count; i++) {
                CellWithView*model=self.cellModelArray[i];
                switch (i) {
                    case 0:
                        model.text=shopinfo.szShopName;
                        break;
                    case 1:
                        model.text=shopinfo.szTel;
                        break;
                    case 3:
                        model.text=shopinfo.szRoad;
                        break;
                    case 4:
                        model.text=shopinfo.szNumber;
                        break;
                    case 5:
                        model.text=shopinfo.szSuburb;
                        break;
                    case 6:
                        model.text=shopinfo.szState;
                        break;
                    default:
                        break;
                }
            }
            [self.tableView reloadData];
        }else{
            KShowServerMessage(json[@"error"]);
        }
       
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellModelArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    WithTextCell*cell=[WithTextCell initWithTableView:tableView];
    cell.cellWithView=self.cellModelArray[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2) {
        ChangeTradingHourViewController*TradingHour=[[ChangeTradingHourViewController alloc]init];
        [self.navigationController pushViewController:TradingHour animated:YES];
    }else if (indexPath.row==3){
       
    }
}

-(void)setupUI{
    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(10, kScreenH-64-50, kScreenW-20, 40)];
    [btn setTitle:@"保存并下一步" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:KmainColor];
    btn.layer.cornerRadius=5;
    [self.view addSubview:btn];
    /*底部
    UILabel*progressL=[[UILabel alloc]initWithFrame:CGRectMake(0, kScreenH-64-20, kScreenW, 20)];
    progressL.font=[UIFont systemFontOfSize:16];
    progressL.textAlignment=NSTextAlignmentCenter;
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:@"修改密码—协议—门店信息—菜单类别—菜品信息"];
    NSRange blueRange = NSMakeRange([[noteStr string] rangeOfString:@"修改密码—"].location, [[noteStr string] rangeOfString:@"修改密码—协议—门店信息—"].length);
    //需要设置的位置
    [noteStr addAttribute:NSForegroundColorAttributeName value:jpBlue range:blueRange];
    //设置颜色
    [progressL setAttributedText:noteStr];
    
    [self.view addSubview:progressL];
     */
}

-(void)commentTableViewTouchInSide{
    [self.view endEditing:YES];
}
-(void)next{
    
    for (int i=0; i<self.cellModelArray.count; i++) {
        CellWithView*model=self.cellModelArray[i];
        switch (i) {
            case 0:
                self.shopinfo.szShopName=model.text;
                break;
            case 1:
                self.shopinfo.szTel=model.text;
                break;
            case 3:
                self.shopinfo.szRoad=model.text;
                break;
            case 4:
                self.shopinfo.szNumber=model.text;
                break;
            case 5:
                self.shopinfo.szSuburb=model.text;
                break;
            case 6:
                self.shopinfo.szState=model.text;
                break;
            default:
                break;
        }
    }
    NSDictionary*parm=[self.shopinfo mj_keyValues];
    [UniHttpTool getwithparameters:parm option:SetShop success:^(id json) {
        if ([json[@"ret"] integerValue]==0) {
            CookWayPriceViewController*cookway=[[CookWayPriceViewController alloc]init];
            [self.navigationController pushViewController:cookway animated:YES];
        }else{
            //DLog(@"%@",json);
            KShowServerMessage(json[@"error"]);
        }
    }];
   
    
}

-(NSMutableArray *)cellModelArray{
    if (!_cellModelArray) {
        _cellModelArray=[NSMutableArray array];
    }
    return _cellModelArray;
}
@end
