//
//  BaseNavigationController.m
//  JustPrintLab
//
//  Created by 陈鑫荣 on 2018/1/20.
//  Copyright © 2018年 justprint. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor=KmainColor;
    self.navigationBar.translucent=NO;
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    self.navigationBar.tintColor=[UIColor whiteColor];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
-(void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
