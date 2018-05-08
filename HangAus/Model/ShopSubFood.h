//
//  ShopSubFood.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/4/8.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopSubFood : NSObject
@property(nonatomic,assign)NSInteger dwSFID;
@property(nonatomic,assign)NSInteger dwUnitWeight;
@property(nonatomic,assign)NSInteger dwIncluding;
@property(nonatomic,assign)NSInteger dwUnitPrice;
@property(nonatomic,assign)NSInteger dwSupFlavor;
@property(nonatomic,assign)NSInteger dwDefValue;
@property(nonatomic,assign)NSInteger dwIncluded;
@property(nonatomic,assign)NSInteger dwDispOrder;
@property(nonatomic,assign)NSInteger dwDiscount;
@property(nonatomic,assign)NSInteger dwMaxValue;
@property(nonatomic,assign)NSInteger dwShopID;
@property(nonatomic,assign)NSInteger dwMinValue;

@property(nonatomic,copy)NSString* szAbbrName;
@property(nonatomic,copy)NSString* szUnit;
@property(nonatomic,copy)NSString* szMemo;
@property(nonatomic,copy)NSString* szName;
@property(nonatomic,copy)NSString* szValueName;


+(NSArray *)bg_unionPrimaryKeys;
@end
