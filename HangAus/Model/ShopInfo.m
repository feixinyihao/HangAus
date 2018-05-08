//
//  ShopInfo.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/21.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "ShopInfo.h"
#import <MJExtension.h>
#define file [KDoc stringByAppendingString:@"/ShopInfo.data"]

@implementation ShopInfo
MJCodingImplementation
+(void)save:(ShopInfo*)shopInfo{
     [NSKeyedArchiver archiveRootObject:shopInfo toFile:file];
}
-(void)save{
    [ShopInfo save:self];
}
+(ShopInfo*)getShopInfo{
     return [NSKeyedUnarchiver unarchiveObjectWithFile:file];
}
@end
