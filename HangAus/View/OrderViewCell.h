//
//  OrderViewCell.h
//  HangAus
//
//  Created by 陈鑫荣 on 2018/5/2.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderFood,OrderViewCell;
@protocol OrderViewCellDelegate <NSObject>

@optional
-(void)OrderViewCellAction:(OrderViewCell*)cell withStatus:(BOOL)status withNum:(NSInteger)num;
@end

@interface OrderViewCell : UITableViewCell
@property(nonatomic,strong)OrderFood*orderfood;
+(OrderViewCell*)initWithTableView:(UITableView*)tableView;
@property(nonatomic,strong)id <OrderViewCellDelegate>delegate;
@end
