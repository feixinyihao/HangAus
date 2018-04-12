//
//  CookWay.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/22.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CookWay : NSObject

/**
 1 Fried  2 Grilled  4 Steamed
 */
@property(nonatomic,assign)NSInteger dwCWID;
@property(nonatomic,copy)NSString*szAbbrName;
@property(nonatomic,copy)NSString*szMemo;
@property(nonatomic,copy)NSString*szName;
@end
