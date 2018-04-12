//
//  FoodTableViewCell.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/2/7.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShowFood,FoodTableViewCell;
@protocol FoodTableViewCellDelegate <NSObject>

@optional
-(void)FoodTableViewCelleditBtnClick:(UIButton*)button withCell:(FoodTableViewCell*)cell;
-(void)ppNumDidClickWithCell:(FoodTableViewCell*)cell withIncreaseStatus:(BOOL)status;
-(void)FoodTableViewCellOrderPackages:(FoodTableViewCell*)cell withShowfood:(ShowFood*)showfood;
@end

@interface FoodTableViewCell : UITableViewCell
@property(nonatomic,strong)ShowFood*food;
@property(nonatomic,assign)BOOL isSales;
+(FoodTableViewCell*)initWithTableView:(UITableView*)tableView;

@property(nonatomic,strong)id <FoodTableViewCellDelegate>delegate;
@end
