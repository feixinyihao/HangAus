//
//  ChosenFood.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/14.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChosenFood : NSObject
@property(nonatomic,assign)NSInteger dwParentID;
@property(nonatomic,assign)NSInteger dwShowFoodID;
@property(nonatomic,assign)NSInteger dwDispOrder;
@property(nonatomic,assign)NSInteger dwCookWayProp;
@property(nonatomic,assign)NSInteger dwSubFoodProp;
@property(nonatomic,assign)NSInteger dwFlavorProp;
@property(nonatomic,assign)NSInteger dwQuantity;
@property(nonatomic,copy)NSString*szMemo;

@end
