//
//  OrderFood.h
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/11.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderFood : NSObject<NSCopying>
@property(nonatomic,assign)NSInteger dwSubFoodPrice;
@property(nonatomic,assign)NSInteger dwSubFoodDiscount;
@property(nonatomic,assign)NSInteger dwParentIndex;
@property(nonatomic,assign)NSInteger dwStat;
@property(nonatomic,assign)NSInteger dwSelCookWay;
@property(nonatomic,assign)NSInteger dwFoodType;
@property(nonatomic,assign)NSInteger dwShowFoodID;
@property(nonatomic,assign)NSInteger dwFoodPrice;
@property(nonatomic,assign)NSInteger dwCookPrice;
@property(nonatomic,assign)NSInteger dwFoodDiscount;
@property(nonatomic,assign)NSInteger dwOrderSID;
@property(nonatomic,assign)NSInteger dwFoodIndex;
@property(nonatomic,assign)NSInteger dwQuantity;
@property(nonatomic,assign)NSInteger dwFlavorPrice;
@property(nonatomic,assign)NSInteger dwShopID;
@property(nonatomic,copy)NSString *szSelFlavor;
@property(nonatomic,copy)NSString *szMemo;
@property(nonatomic,copy)NSString *szSelSubFood;

//自定义
@property(nonatomic,copy)NSString*szShowFoodName;
@property(nonatomic,assign)NSInteger dwGroupID;
@property(nonatomic,copy)NSString *szSelSubFoodArrayStr;
@property(nonatomic,copy)NSString *szSelFlavorArrayStr;
@property(nonatomic,copy)NSString*szSelCookWay;
@end
