//
//  Food.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/2/7.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "Food.h"

@implementation Food
+(instancetype)foodWithdic:(NSDictionary*)dic{
    return [[Food alloc]initWithdic:dic];
}
-(instancetype)initWithdic:(NSDictionary*)dic{
    if (self=[super init]) {
        self.foodNum=dic[@"foodNum"];
        self.foodName=dic[@"foodName"];
        self.imagePath=dic[@"imagePath"];
        self.foodBalance=dic[@"foodBalance"];
        self.down= [dic[@"down"] isEqualToString:@"1"]?YES:NO;;
    }
    return self;
}
@end
