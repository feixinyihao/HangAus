//
//  OrderPackageViewController.h
//  HangAus
//
//  Created by 陈鑫荣 on 2018/5/4.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShowFood;
@interface OrderPackageViewController : UIViewController
@property(nonatomic,strong)ShowFood*showfood;

@property(nonatomic,copy)void (^VCBlock)(NSArray *orderfoods);

@property(nonatomic,assign)NSInteger foodIndex;
@end
