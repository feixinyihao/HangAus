//
//  ProtocolViewController.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/2.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "ProtocolViewController.h"
#import "ShopInfoViewController.h"
#import "UniHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "ShopInfo.h"
#import <MJExtension.h>
#import "MainViewController.h"
@interface ProtocolViewController ()
@property(nonatomic,weak)UIButton*btn;
@end

@implementation ProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"商家相关条款和协议";
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title = @"返回";
    self.navigationItem.backBarButtonItem = backbutton;
    self.view.backgroundColor=[UIColor whiteColor];
    [self setupUI];
    [self getData];
}

-(void)getData{
    [UniHttpTool getwithparameters:nil option:GetShop success:^(id json) {
        NSArray*infoArray=json[@"data"];
        ShopInfo*shopinfo=[ShopInfo mj_objectWithKeyValues:[infoArray firstObject]];
        [shopinfo save];
        UILabel*msgL=[[UILabel alloc]initWithFrame:CGRectMake(0, 200, kScreenW, 30)];
        msgL.textAlignment=NSTextAlignmentCenter;
        msgL.textColor=[UIColor redColor];
        [self.view addSubview:msgL];
        if ((shopinfo.dwShopStat&2)<=0) {
            msgL.text=@"您未审核通过，请耐心等待";
            self.btn.hidden=YES;
            self.title=@"";
        }else if ((shopinfo.dwShopStat&1024)<=0&&(shopinfo.dwShopStat&512)<=0&&(shopinfo.dwShopStat&256)<=0){
            msgL.text=@"您暂时还无法使用，请联系商家";
            self.btn.hidden=YES;
            self.title=@"";
        }
 //       else if ((shopinfo.dwShopStat&131072)>0){
//            MainViewController*main=[[MainViewController alloc]init];
//            self.view.window.rootViewController=main;
//        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupUI{
    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(10, kScreenH-50-64, kScreenW-20, 40)];
    [btn setTitle:@"我接受" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:KmainColor];
    btn.layer.cornerRadius=5;
    [self.view addSubview:btn];
    self.btn=btn;
    /*底部
    UILabel*progressL=[[UILabel alloc]initWithFrame:CGRectMake(0, kScreenH-64-20, kScreenW, 20)];
    progressL.font=[UIFont systemFontOfSize:16];
    progressL.textAlignment=NSTextAlignmentCenter;
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:@"修改密码—协议—门店信息—菜单类别—菜品信息"];
    NSRange blueRange = NSMakeRange([[noteStr string] rangeOfString:@"修改密码—"].location, [[noteStr string] rangeOfString:@"修改密码—协议—"].length);
    //需要设置的位置
    [noteStr addAttribute:NSForegroundColorAttributeName value:jpBlue range:blueRange];
    //设置颜色
    [progressL setAttributedText:noteStr];
    
    [self.view addSubview:progressL];
     */
}
-(void)next{
    ShopInfoViewController*shopinfo=[[ShopInfoViewController alloc]init];
    [self.navigationController pushViewController:shopinfo animated:YES];
}
@end
