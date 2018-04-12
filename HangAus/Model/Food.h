//
//  Food.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/2/7.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Food : NSObject
@property(nonatomic,copy)NSString*foodName;
@property(nonatomic,copy)NSString*foodBalance;
@property(nonatomic,copy)NSString*foodNum;
@property(nonatomic,copy)NSString*imagePath;
@property(nonatomic,assign)BOOL down;
+(instancetype)foodWithdic:(NSDictionary*)dic;
-(instancetype)initWithdic:(NSDictionary*)dic;
@end
