//
//  FoodKind.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/2/7.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShowGroup;
@interface FoodKindTest : NSObject
@property(nonatomic,copy)NSString* foodKindName;
@property(nonatomic,strong)NSMutableArray*foodArr;
@property(nonatomic,strong)ShowGroup*showGroup;

-(instancetype)initWithName:(NSString*)name withFoodArr:(NSMutableArray*)foodArr;
-(instancetype)initWithName:(NSString*)name withFoodArr:(NSMutableArray*)foodArr WithShowGroup:(ShowGroup*)showGroup;
@end
