//
//  ShowFood.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/12.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowFood : NSObject
@property(nonatomic,assign)NSInteger dwUnitWeight;

/**
 可选配料
 */
@property(nonatomic,assign)NSInteger dwSubFoodProp;
@property(nonatomic,assign)NSInteger dwUnitPrice;
@property(nonatomic,copy)NSString*szFoodKindName;
@property(nonatomic,assign)NSInteger dwProp;
@property(nonatomic,assign)NSInteger dwFoodKindID;
@property(nonatomic,assign)NSInteger dwStat;
@property(nonatomic,copy)NSString*szAbbrName;
@property(nonatomic,copy)NSString*szUnit;

/**
 烹饪方法
 */
@property(nonatomic,assign)NSInteger dwCookWayProp;

/**
 个人口味
 */
@property(nonatomic,assign)NSInteger dwFlavorProp;
@property(nonatomic,assign)NSInteger dwSoldProp;
@property(nonatomic,copy)NSString*szMemo;
@property(nonatomic,copy)NSString*szFoodName;
@property(nonatomic,assign)NSInteger dwKindProp;
@property(nonatomic,assign)NSInteger dwStoredNum;
@property(nonatomic,assign)NSInteger dwShopID;
@property(nonatomic,assign)NSInteger dwFoodID;
@property(nonatomic,assign)NSInteger dwShowFoodID;
@property(nonatomic,assign)NSInteger dwGroupID;
@property(nonatomic,copy)NSString*szDispName;
@property(nonatomic,copy)NSString*szDispAbbr;

@property(nonatomic,assign)NSInteger dwDispOrder;
@property(nonatomic,assign)NSInteger dwShowProp;
@property(nonatomic,assign)NSInteger dwDiscount;
@property(nonatomic,assign)NSInteger dwMinPrice;
@property(nonatomic,assign)NSInteger dwIncSubFood;
@property(nonatomic,assign)NSInteger dwDefQuantity;
@property(nonatomic,strong)NSMutableArray*ChosenFoods;
/**
 测试使用
 */
@property(nonatomic,copy)NSString*imagePath;
@property(nonatomic,assign)NSInteger orderNum;
+ (NSDictionary *)objectClassInArray;



@end
