//
//  FoodKind.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/2/7.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "FoodKindTest.h"

@implementation FoodKindTest
-(instancetype)initWithName:(NSString*)name withFoodArr:(NSMutableArray*)foodArr{
    if ([super init]) {
        if (self) {
            self.foodKindName=name;
            self.foodArr=foodArr;
        }
    }
    return self;
}
-(instancetype)initWithName:(NSString*)name withFoodArr:(NSMutableArray*)foodArr WithShowGroup:(ShowGroup*)showGroup{
    if ([super init]) {
        if (self) {
            self.foodKindName=name;
            self.foodArr=foodArr;
            self.showGroup=showGroup;
        }
    }
    return self;
}
@end
