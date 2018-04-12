//
//  CellWithView.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/21.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellWithView : NSObject
@property(nonatomic,copy)NSString* leftTitle;
@property(nonatomic,copy)NSString* viewClass;
@property(nonatomic,copy)NSString* placeholder;
@property(nonatomic,copy)NSString* text;
@property(nonatomic,copy)NSString* detailText;
@property(nonatomic,copy)NSString* imageName;
@property(nonatomic,copy)NSString*imagePath;
@property(nonatomic,strong)NSArray* chosenFoods;
@property(nonatomic,assign)NSInteger prop;
@property(nonatomic,assign)NSInteger propNum;

@property(nonatomic,assign)NSInteger subfoodprop;
@property(nonatomic,assign)NSInteger incSubfoodprop;
/**
 0 默认键盘 1 带点的数字键盘
 */
@property(nonatomic,assign)NSInteger keyboard;
+ (NSDictionary *)objectClassInArray;
@end
