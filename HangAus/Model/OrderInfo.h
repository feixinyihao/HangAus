//
//  OrderInfo.h
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/11.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface OrderInfo : NSObject
@property(nonatomic,assign)NSInteger dwOrderType;
@property(nonatomic,assign)NSInteger dwShopID;
@property(nonatomic,assign)NSInteger dwOrderTime;
@property(nonatomic,assign)NSInteger dwOrderDate;
@property(nonatomic,assign)NSInteger dwOrderSID;
@property(nonatomic,assign)NSInteger dwTakeDate;
@property(nonatomic,assign)NSInteger dwTotalPrice;
@property(nonatomic,assign)NSInteger dwPayType;
@property(nonatomic,assign)NSInteger dwCashPaid;
@property(nonatomic,assign)NSInteger dwCardPaid;
@property(nonatomic,assign)NSInteger dwDiscount;
@property(nonatomic,assign)NSInteger dwCustomID;
@property(nonatomic,assign)NSInteger dwWantTakeTime;
@property(nonatomic,assign)NSInteger dwTips;
@property(nonatomic,assign)NSInteger dwOrderStat;
@property(nonatomic,assign)NSInteger dwPayTime;
@property(nonatomic,assign)NSInteger dwRealTakeTime;

@property(nonatomic,copy)NSString*szTel;
@property(nonatomic,copy)NSString*szCardInfo;
@property(nonatomic,copy)NSString*szMemo;
@property(nonatomic,copy)NSString*szOrderNo;
@property(nonatomic,copy)NSString*szCustomName;
@property(nonatomic,copy)NSString*szMobilePhone;
@property(nonatomic,strong)NSArray*OrderFoods;
+ (NSDictionary *)objectClassInArray;

@end
