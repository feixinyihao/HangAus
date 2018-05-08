//
//  OrderFood.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/11.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "OrderFood.h"

@implementation OrderFood
//深拷贝
-(id)copyWithZone:(NSZone *)zone{
    OrderFood*orderfood=[[[self class]allocWithZone:zone] init];
    orderfood.dwSubFoodPrice=self.dwSubFoodPrice;
    orderfood.dwSubFoodDiscount=self.dwSubFoodDiscount;
    orderfood.dwParentIndex=self.dwParentIndex;
    orderfood.dwStat=self.dwStat;
    orderfood.dwSelCookWay=self.dwSelCookWay;
    orderfood.dwFoodType=self.dwFoodType;
    orderfood.dwShowFoodID=self.dwShowFoodID;
    orderfood.dwFoodPrice=self.dwFoodPrice;
    orderfood.dwCookPrice=self.dwCookPrice;
    orderfood.dwFoodDiscount=self.dwFoodDiscount;
    orderfood.dwOrderSID=self.dwOrderSID;
    orderfood.dwFoodIndex=self.dwFoodIndex;
    orderfood.dwQuantity=self.dwQuantity;
    orderfood.dwFlavorPrice=self.dwFlavorPrice;
    orderfood.dwShopID=self.dwShopID;
    orderfood.szSelFlavor=self.szSelFlavor;
    orderfood.szMemo=self.szMemo;
    orderfood.szSelSubFood=self.szSelSubFood;
    orderfood.szShowFoodName=self.szShowFoodName;
    orderfood.dwGroupID=self.dwGroupID;
    orderfood.szSelSubFoodArrayStr=self.szSelSubFoodArrayStr;
    orderfood.szSelFlavorArrayStr=self.szSelFlavorArrayStr;
    orderfood.szSelCookWay=self.szSelCookWay;
    return orderfood;
}

@end
