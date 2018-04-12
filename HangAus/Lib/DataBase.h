//
//  Database.h
//  scan
//
//  Created by 陈鑫荣 on 2017/12/23.
//  Copyright © 2017年 justprint. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShowFood,ChosenFood,ShowGroup,SubFood,ShopSubFood;
@interface DataBase : NSObject


+ (instancetype)sharedDataBase;
#pragma mark URL
/**
 *  添加showfood
 *
 */
- (void)addShowFood:(ShowFood *)showFood;

- (void)addShopShowFood:(ShopSubFood *)ShopSubFood;
-(NSMutableArray*)getChosenFoodEqual:(NSString*)key;

-(void)addSubFood:(SubFood*)subFood;
-(void)addshowGroup:(ShowGroup*)showGroup;
/**
 添加套餐食物
 */
-(void)addChosenFood:(ChosenFood*)choseFood;
/**
 *  删除showfood
 *
 */

- (void)deleteShowFood:(ShowFood *)showFood;


/**
 *  更新showfood
 *
 */
- (void)updateShowFood:(ShowFood *)ShowFood;

/**
 *  获取所有数据
 *
 */
- (NSMutableArray *)getAllShowFood;
- (NSMutableArray *)getAllSubFood;
- (NSMutableArray *)getAllShopSubFood;
- (NSMutableArray *)getAllShowGroup;
/**
 模糊搜索
 
 @param key 搜索关键字
 @return 返回对象数组
 */
-(NSMutableArray*)getShowFoodLike:(NSString*)key;

-(NSMutableArray*)getShowFoodEqual:(NSString*)key;

-(ShowFood*)getShowFoodWithID:(NSInteger)ShowFoodID;

/**
 删除所有
 */
-(void)deleteAllShowFood;
-(void)deleteAllShopSubFood;
-(void)deleteAllChosenFood;
-(void)deleteAllShowGroup;

- (NSArray *)allProperties:(id)class;
@end
