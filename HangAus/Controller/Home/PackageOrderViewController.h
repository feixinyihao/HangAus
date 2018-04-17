//
//  PackageOrderViewController.h
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/11.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShowFood;
@interface PackageOrderViewController : UIViewController
@property(nonatomic,strong)ShowFood*showfood;

@property(nonatomic,copy)void (^VCBlock)(NSArray *orderfoods);

@property(nonatomic,assign)NSInteger orderfoodscount;
@end
