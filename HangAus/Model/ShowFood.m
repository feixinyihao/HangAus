//
//  ShowFood.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/12.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "ShowFood.h"

@implementation ShowFood
+ (NSDictionary *)objectClassInArray{
    return @{
             @"ChosenFoods" : @"ChosenFood",
             };
}


//BGFMDB
+(NSArray *)bg_unionPrimaryKeys{
    return @[@"dwShowFoodID"];
}

+(NSDictionary *)bg_objectClassInArray{
    return @{@"ChosenFoods":[ChosenFood class]};
}
@end
