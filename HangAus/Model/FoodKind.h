//
//  FoodKind.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/12.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodKind : NSObject
@property(nonatomic,assign)NSInteger dwShopID;
@property(nonatomic,assign)NSInteger dwFoodKindID;
@property(nonatomic,copy)NSString*szFoodKindName;
@property(nonatomic,assign)NSInteger dwProp;
@property(nonatomic,assign)NSInteger dwCookWayProp;
@property(nonatomic,assign)NSInteger dwSubFoodProp;
@property(nonatomic,assign)NSInteger dwFlavorProp;
@property(nonatomic,assign)NSInteger dwSoldProp;
@property(nonatomic,copy)NSString*szMemo;
@end
