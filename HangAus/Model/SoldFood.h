//
//  SoldFood.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/12.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoldFood : NSObject
@property(nonatomic,assign)NSInteger dwUnitWeight;
@property(nonatomic,assign)NSInteger dwSubFoodProp;
@property(nonatomic,assign)NSInteger dwUnitPrice;
@property(nonatomic,copy)NSString*szFoodKindName;
@property(nonatomic,assign)NSInteger dwProp;
@property(nonatomic,assign)NSInteger dwFoodKindID;
@property(nonatomic,assign)NSInteger dwStat;
@property(nonatomic,copy)NSString*szAbbrName;
@property(nonatomic,copy)NSString*szUnit;
@property(nonatomic,assign)NSInteger dwCookWayProp;
@property(nonatomic,assign)NSInteger dwFlavorProp;
@property(nonatomic,assign)NSInteger dwSoldProp;
@property(nonatomic,copy)NSString*szMemo;
@property(nonatomic,copy)NSString*szFoodName;
@property(nonatomic,assign)NSInteger dwKindProp;
@property(nonatomic,assign)NSInteger dwStoredNum;
@property(nonatomic,assign)NSInteger dwShopID;
@property(nonatomic,assign)NSInteger dwFoodID;

@end
