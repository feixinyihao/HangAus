//
//  AppDelegate.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/9.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "AppDelegate.h"
#import <IQKeyboardManager.h>
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "StaffToken.h"
#import "MainViewController.h"
#import "UniHttpTool.h"
#import "ProtocolViewController.h"
#import "ShopInfo.h"
@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupKeyboardManager];
    StaffToken*token=[StaffToken getStaffToken];
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    if (token) {
        ShopInfo*shopinfo=[ShopInfo getShopInfo];
        if ((shopinfo.dwShopStat&131072)>0) {
            MainViewController*main=[[MainViewController alloc]init];
            self.window.rootViewController=main;
//            ProtocolViewController*protocol=[[ProtocolViewController alloc]init];
//            BaseNavigationController*base=[[BaseNavigationController alloc]initWithRootViewController:protocol];
//            self.window.rootViewController=base;
        }else{
            ProtocolViewController*protocol=[[ProtocolViewController alloc]init];
            BaseNavigationController*base=[[BaseNavigationController alloc]initWithRootViewController:protocol];
            self.window.rootViewController=base;
        }
    }else{
        LoginViewController*login=[[LoginViewController alloc]init];
        BaseNavigationController*base=[[BaseNavigationController alloc]initWithRootViewController:login];
        self.window.rootViewController=base;
        
    }
    [self.window  makeKeyAndVisible];
    return YES;
}


-(void)setupKeyboardManager{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = YES; // 控制整个功能是否启用
    
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    
    keyboardManager.enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
    
    // keyboardManager.shouldShowTextFieldPlaceholder = YES; // 是否显示占位文字
    
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
    
}


@end
