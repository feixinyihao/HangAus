//
//  ShopInfo.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/21.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopInfo : NSObject
@property(nonatomic,assign)NSInteger dwRunStat;
@property(nonatomic,assign)NSInteger dwBalance;
@property(nonatomic,copy)NSString *szTel;


@property(nonatomic,assign)NSInteger dwOpenTime;
@property(nonatomic,assign)NSInteger dwPayMode;
@property(nonatomic,assign)NSInteger dwShopID;
@property(nonatomic,assign)NSInteger dwShopStat;
@property(nonatomic,assign)NSInteger dwCardLimit;
@property(nonatomic,assign)NSInteger dwMaintainingExpDate;
@property(nonatomic,assign)NSInteger dwFormalDate;
@property(nonatomic,assign)NSInteger dwCreateDate;
@property(nonatomic,assign)NSInteger dwCloseTime;
@property(nonatomic,assign)NSInteger dwServiceExpDate;
@property(nonatomic,assign)NSInteger dwUpdateTime;
@property(nonatomic,assign)NSInteger dwCardSurCharge;
@property(nonatomic,assign)NSInteger dwRunDate;
@property(nonatomic,assign)NSInteger dwChgTime;

@property(nonatomic,copy)NSString *szCurVer;
@property(nonatomic,copy)NSString *szNumber;
@property(nonatomic,copy)NSString *szCompany;
@property(nonatomic,copy)NSString *szShopSN;
@property(nonatomic,copy)NSString *szCountry;
@property(nonatomic,copy)NSString *szWebsite;
@property(nonatomic,copy)NSString *szStatInfo;
@property(nonatomic,copy)NSString *szUnit;
@property(nonatomic,copy)NSString *szSuburb;
@property(nonatomic,copy)NSString *szShopName;
@property(nonatomic,copy)NSString *szPostcode;
@property(nonatomic,copy)NSString *szMemo;
@property(nonatomic,copy)NSString *szCoordinate;
@property(nonatomic,copy)NSString *szIP;
@property(nonatomic,copy)NSString *szIndustry;
@property(nonatomic,copy)NSString *szRoad;
@property(nonatomic,copy)NSString *szState;


+(void)save:(ShopInfo*)shopInfo;
-(void)save;
+(ShopInfo*)getShopInfo;
@end
