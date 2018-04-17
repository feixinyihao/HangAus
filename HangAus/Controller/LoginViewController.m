//
//  LoginViewController.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/1.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD+MJ.h"
#import "UniHttpTool.h"
#import "StaffInfo.h"
#import "StaffToken.h"
#import <MJExtension.h>
#import "ChangePswViewController.h"
@interface LoginViewController ()
@property(nonatomic,weak)UITextField*userNameField;
@property(nonatomic,weak)UITextField*passWordField;

@property(nonatomic,weak)UIScrollView*scrollView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"杭澳科技商家APP";
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
    [self setupUI];
}
-(void)setupUI{
    //用户名
    UITextField*userNameField=[[UITextField alloc]init];
    userNameField.frame=CGRectMake(10, 60, kScreenW-20, 50);
    [userNameField setBackgroundColor:[UIColor whiteColor]];
    UIImageView*imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"username"]];
    imageView.frame=CGRectMake(10, 13, 20, 20);
    UIView*headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [headView addSubview:imageView];
    userNameField.layer.cornerRadius=5;
    userNameField.leftView=headView;
    userNameField.leftViewMode = UITextFieldViewModeAlways;
    userNameField.placeholder=@"请输入用户名";
    userNameField.text=@"cxr";
    self.userNameField=userNameField;
    [self.scrollView addSubview:userNameField];
    
    //密码
    UITextField*passWordField=[[UITextField alloc]init];
    passWordField.frame=CGRectMake(10, 130, kScreenW-20, 50);
    [passWordField setBackgroundColor:[UIColor whiteColor]];
    UIImageView*pswImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password"]];
    pswImageView.frame=CGRectMake(10, 13, 22, 22);
    UIView*psdHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [psdHeadView addSubview:pswImageView];
    passWordField.layer.cornerRadius=5;
    passWordField.leftView=psdHeadView;
    passWordField.leftViewMode = UITextFieldViewModeAlways;
    passWordField.placeholder=@"请输入密码";
    passWordField.secureTextEntry=YES;
    passWordField.text=@"Hangaus101";
    self.passWordField=passWordField;
    [self.scrollView addSubview:passWordField];
    
    //确认按钮
    UIButton*submitBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 230, kScreenW-20, 50)];
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:KmainColor];
    submitBtn.layer.cornerRadius=5;
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:submitBtn];
    
    //登录遇到问题
    UIButton*questionBtn=[[UIButton alloc]initWithFrame:CGRectMake((kScreenW-180)/2, 290, 180, 20)];
    [questionBtn setTitleColor:KmainColor forState:UIControlStateNormal];;
    questionBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [questionBtn setTitle:@"登录遇到问题？" forState:UIControlStateNormal];
    [self.scrollView addSubview:questionBtn];
}

-(void)submit{
    [MBProgressHUD showHUDAddedTo:nil animated:YES];
    NSDictionary*parm=@{@"szLogonName":self.userNameField.text,
                        @"szPassword":self.passWordField.text};
    [UniHttpTool getwithparameters:parm option:StaffLogin success:^(id json) {
        StaffToken*token=[StaffToken mj_objectWithKeyValues:json];
        NSDictionary*dict=json[@"data"];
        [token save];
        StaffInfo*info=[StaffInfo mj_objectWithKeyValues:dict[@"StaffInfo"]];
        [info save];
        ChangePswViewController*change=[[ChangePswViewController alloc]init];
        change.oldPassword=self.passWordField.text;
        [self.navigationController pushViewController:change animated:YES];
        [MBProgressHUD hideHUD];
        
       
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
