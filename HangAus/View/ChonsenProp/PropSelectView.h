//
//  PropSelectView.h
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/28.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShowFood,OrderFood;


@protocol PropSelectViewDelegate <NSObject>
@optional
-(void)PropSelectViewFinish:(OrderFood*)orderfood withView:(UIView*)view withIndexPath:(NSIndexPath*)indexPath withTag:(NSInteger)tag;

@end

@interface PropSelectView : UIView
-(instancetype)initWithShowFood:(ShowFood *)showfood isPackage:(BOOL)package;
-(instancetype)initWithShowFood:(ShowFood *)showfood withOrderfoods:(NSMutableArray*)orderfoods isPackage:(BOOL)package;

/**
 配菜
 */
@property(nonatomic,strong)NSArray*shopSubFoods;

/**
 口味
 */
@property(nonatomic,strong)NSArray*shopFlavors;

/**
 烹饪方式
 */
@property(nonatomic,strong)NSArray*shopCookWays;

@property(nonatomic,strong)id <PropSelectViewDelegate>delegate;
@property(nonatomic,strong)NSIndexPath*indexPath;
@end
