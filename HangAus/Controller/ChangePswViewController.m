//
//  ChangePswViewController.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/2.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "ChangePswViewController.h"
#import "ProtocolViewController.h"
#import "UniHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "StaffInfo.h"
@interface ChangePswViewController ()
@property(nonatomic,weak)UITextField*passWordField;
@property(nonatomic,weak)UITextField*doPassWordField;
@property(nonatomic,weak)UIScrollView*scrollView;

@end

@implementation ChangePswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"修改密码";
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title = @"返回";
    self.navigationItem.backBarButtonItem = backbutton;
    self.view.backgroundColor=KColor(240, 240, 240);
    UIScrollView*scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64)];
    scrollView.contentSize=CGSizeMake(kScreenW, kScreenH-44);
    scrollView.backgroundColor=KColor(240, 240, 240);
    scrollView.showsVerticalScrollIndicator=NO;
    self.scrollView=scrollView;
    [self.view addSubview:self.scrollView];
    UITapGestureRecognizer *scrollGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.scrollView addGestureRecognizer:scrollGesture];
    [self setupUI];
}
-(void)setupUI{
    //密码
    UITextField*passWordField=[[UITextField alloc]init];
    passWordField.frame=CGRectMake(10, 60, kScreenW-20, 50);
    [passWordField setBackgroundColor:[UIColor whiteColor]];
    UIImageView*imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password"]];
    imageView.frame=CGRectMake(10, 13, 22, 22);
    UIView*headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [headView addSubview:imageView];
    passWordField.layer.cornerRadius=5;
    passWordField.leftView=headView;
    passWordField.leftViewMode = UITextFieldViewModeAlways;
    passWordField.placeholder=@"请输入新密码";
    passWordField.secureTextEntry=YES;
    passWordField.text=@"Hangaus101";
    self.passWordField=passWordField;
    [self.scrollView addSubview:passWordField];
    
    //密码确认
    UITextField*doPassWordField=[[UITextField alloc]init];
    doPassWordField.frame=CGRectMake(10, 130, kScreenW-20, 50);
    [doPassWordField setBackgroundColor:[UIColor whiteColor]];
    UIImageView*pswImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password"]];
    pswImageView.frame=CGRectMake(10, 13, 22, 22);
    UIView*psdHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [psdHeadView addSubview:pswImageView];
    doPassWordField.layer.cornerRadius=5;
    doPassWordField.leftView=psdHeadView;
    doPassWordField.leftViewMode = UITextFieldViewModeAlways;
    doPassWordField.placeholder=@"重复新密码";
    doPassWordField.secureTextEntry=YES;
    doPassWordField.text=@"Hangaus101";
    self.doPassWordField=doPassWordField;
    [self.scrollView addSubview:doPassWordField];
    
    //确认按钮
    UIButton*submitBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 230, kScreenW-20, 50)];
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:KmainColor];
    submitBtn.layer.cornerRadius=5;
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:submitBtn];
    
    //说明
    UILabel*msgL=[[UILabel alloc]initWithFrame:CGRectMake(0, 290, kScreenW, 20)];
    msgL.textColor=KmainColor;
    msgL.text=@"首次登录请修改密码";
    msgL.font=[UIFont systemFontOfSize:15];
    msgL.textAlignment=NSTextAlignmentCenter;
    
    [self.scrollView addSubview:msgL];
    
    /*底部
    UILabel*progressL=[[UILabel alloc]initWithFrame:CGRectMake(0, kScreenH-64-20, kScreenW, 20)];
    progressL.font=[UIFont systemFontOfSize:16];
    progressL.textAlignment=NSTextAlignmentCenter;
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:@"修改密码—协议—门店信息—菜单类别—菜品信息"];
    NSRange blueRange = NSMakeRange([[noteStr string] rangeOfString:@"修改密码—"].location, [[noteStr string] rangeOfString:@"修改密码—"].length);
    //需要设置的位置
    [noteStr addAttribute:NSForegroundColorAttributeName value:jpBlue range:blueRange];
    //设置颜色
    [progressL setAttributedText:noteStr];
   
    [self.view addSubview:progressL];
     */
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)hideKeyboard{
    [self.view endEditing:YES];
}

-(void)submit{
    if ([self.passWordField.text isEqualToString:self.doPassWordField.text]) {
        StaffInfo*info=[StaffInfo getStaffInfo];
        NSDictionary*parm=@{@"szLoginPasswd":[NSString stringWithFormat:@"%@",self.oldPassword],@"szNewPasswd":self.passWordField.text,@"dwAdminID":@(info.dwStaffID)};
        [UniHttpTool getwithparameters:parm option:ChangeStaffPassword success:^(id json) {
            ProtocolViewController*protol=[[ProtocolViewController alloc]init];
            [self.navigationController pushViewController:protol animated:YES];
            
        }];
    }else{
        [MBProgressHUD showText:@"两次输入的密码不一样"];
    }
}
@end
