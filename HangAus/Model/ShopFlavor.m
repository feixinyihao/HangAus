//
//  ShopFlavor.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/4/3.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "ShopFlavor.h"

@implementation ShopFlavor
+(NSArray *)bg_unionPrimaryKeys{
    return @[@"dwFVID",@"dwShopID"];
}

-(void)setDwDefValue:(NSInteger)dwDefValue{
    _dwDefValue=dwDefValue;
    _dwCurrentValue=dwDefValue;
}
@end
