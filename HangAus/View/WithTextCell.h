//
//  WithTextCell.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/21.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CellWithView,WithTextCell;

@protocol WithTextCellDelegate <NSObject>
@optional
-(void)TextCellEditing:(WithTextCell*)cell;
-(void)DeleteChosenFood:(NSMutableArray*)chosenfoods;
-(void)reloadTotalPrice:(NSInteger)incSubfood;
@end

@interface WithTextCell : UITableViewCell
@property(nonatomic,strong)CellWithView*cellWithView;
+(WithTextCell*)initWithTableView:(UITableView*)tableView;
@property(nonatomic,strong)id <WithTextCellDelegate>delegate;
@end
