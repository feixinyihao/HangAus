//
//  PackageExchange.h
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/12.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShowFood;
@interface PackageExchange : NSObject
@property(nonatomic,strong)ShowFood*chosenShowFood;
@property(nonatomic,strong)NSArray<ShowFood*>*sameGroupFoods;
@property(nonatomic,assign)NSInteger cellHigh;
@end
