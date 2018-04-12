//
//  ChangeBalanceCell.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/7.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShowFood,ChangeBalanceCell;
@protocol ChangeBalanceCellDelegate <NSObject>

@optional
-(void)ChangeBalanceCellBtnClick:(UIButton*)button withCell:(ChangeBalanceCell*)cell withStr:(NSString*)str;
-(void)ChangeBalanceCellupdownBtnClick:(UIButton*)button withCell:(ChangeBalanceCell*)cell;
@end

@interface ChangeBalanceCell : UITableViewCell
@property(nonatomic,strong)ShowFood*showFood;
+(ChangeBalanceCell*)initWithTableView:(UITableView*)tableView;
@property(nonatomic,strong)id <ChangeBalanceCellDelegate>delegate;
@end
