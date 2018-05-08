//
//  PackageExchangeCell.h
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/12.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShowFood,OrderFood;
@interface PackageExchangeCell : UITableViewCell

@property(nonatomic,strong)OrderFood*orderfood;
+(PackageExchangeCell*)initWithTableView:(UITableView*)tableView;

@end
