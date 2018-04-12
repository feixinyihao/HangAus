//
//  SubFoodCell.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/4/8.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopSubFood,SubFoodCell,SoldFood,ShopCookway;
@protocol SubFoodCellDelegate <NSObject>

@optional
-(void)SubFoodCellBtnClick:(UIButton*)button withCell:(SubFoodCell*)cell withStr:(NSString*)str;

@end
@interface SubFoodCell : UITableViewCell
@property(nonatomic,strong)ShopSubFood* subfood;
@property(nonatomic,strong)SoldFood*soldfood;
@property(nonatomic,strong)ShopCookway*cookway;
+(SubFoodCell*)initWithTableView:(UITableView*)tableView;
@property(nonatomic,strong)id <SubFoodCellDelegate>delegate;
@end
