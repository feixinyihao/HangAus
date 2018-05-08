//
//  ShopCookway.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/4/3.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCookway : NSObject
@property(nonatomic,copy)NSString*szName;
@property(nonatomic,copy)NSString*szShowName;
@property(nonatomic,assign)NSInteger dwCWID;
@property(nonatomic,assign)NSInteger dwFoodID;
@property(nonatomic,assign)NSInteger dwSupFlavor;
@property(nonatomic,assign)NSInteger dwUnitPrice;
@property(nonatomic,assign)NSInteger dwShopID;
@property(nonatomic,assign)NSInteger dwDispOrder;
@property(nonatomic,assign)NSInteger dwDiscount;
@property(nonatomic,assign)NSInteger dwFoodIDType;
@property(nonatomic,copy)NSString*szAbbrName;
@property(nonatomic,copy)NSString*szMemo;

+(NSArray *)bg_unionPrimaryKeys;
@end
