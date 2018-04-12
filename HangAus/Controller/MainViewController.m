//
//  MainViewController.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/2/7.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "MainViewController.h"
#import "BaseNavigationController.h"
#import "ManagerViewController.h"
#import "SettingsViewController.h"
#import "ReportViewController.h"
#import "HomeViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAllChildView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  初始化一个子控制器
 */
-(void)SetupChildViewConterller:(UIViewController * )childView title:(NSString*)title  imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName{
    self.tabBar.tintColor=[UIColor blackColor];
    // childView.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 2, 0);
   // [childView.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, 0)];
    childView.title=title;
    childView.tabBarItem.image=[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childView.tabBarItem.selectedImage=[[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    BaseNavigationController * childViewNav=[[BaseNavigationController alloc]initWithRootViewController:childView];
        [self addChildViewController:childViewNav];
    
    
    
}
/**
 *  初始化所有子控制器
 */
-(void)setupAllChildView{
    
    HomeViewController*home=[[HomeViewController alloc]init];
    [self SetupChildViewConterller:home title:KLocalizedString(@"6000001") imageName:@"home" selectedImageName:@"homeSelected"];
    
    ManagerViewController*viewcontrol=[[ManagerViewController alloc]init];
    [self SetupChildViewConterller:viewcontrol title:KLocalizedString(@"6000002") imageName:@"manager" selectedImageName:@"manager_selected"];
    
    SettingsViewController*map=[[SettingsViewController alloc]init];
    [self SetupChildViewConterller:map title:KLocalizedString(@"6000003") imageName:@"setting" selectedImageName:@"setting_selected"];
    
    ReportViewController*wallet=[[ReportViewController alloc]init];
    [self SetupChildViewConterller:wallet title:KLocalizedString(@"6000004") imageName:@"report" selectedImageName:@"report_selected"];
    
    
}

-(void)dealloc{
    DLog(@"释放了");
}

@end
