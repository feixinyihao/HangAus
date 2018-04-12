//
//  ShopFlavor.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/4/3.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopFlavor : NSObject
@property(nonatomic,assign)NSInteger dwUnitPrice;
@property(nonatomic,copy)NSString*szName;
@property(nonatomic,copy)NSString*szAbbrName;
@property(nonatomic,copy)NSString*szValueName;
@property(nonatomic,copy)NSString*szMemo;

@property(nonatomic,assign)NSInteger dwFVID;
@property(nonatomic,assign)NSInteger dwDefValue;
@property(nonatomic,assign)NSInteger dwDispOrder;
@property(nonatomic,assign)NSInteger dwDiscount;
@property(nonatomic,assign)NSInteger dwMaxValue;
@property(nonatomic,assign)NSInteger dwShopID;
@property(nonatomic,assign)NSInteger dwMinValue;


@end
