//
//  TradingHourCell.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/16.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TradingHour,TradingHourCell;
@protocol TradingHourCellDelegate <NSObject>

@optional
-(void)TradingHourCellBtnClick:(UIButton*)button withCell:(TradingHourCell*)cell;
@end

@interface TradingHourCell : UITableViewCell
+(TradingHourCell*)initWithTableView:(UITableView*)tableView;
@property(nonatomic,strong)TradingHour*tradingHour;

@property(nonatomic,strong)id <TradingHourCellDelegate>delegate;
@end
