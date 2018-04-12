//
//  ShowGroup.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/12.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowGroup : NSObject
@property(nonatomic,assign)NSInteger dwProp;
@property(nonatomic,assign)NSInteger dwType;
@property(nonatomic,copy)NSString*szMemo;
@property(nonatomic,copy)NSString*szGroupName;
@property(nonatomic,assign)NSInteger dwShopID;
@property(nonatomic,assign)NSInteger dwGroupID;
@property(nonatomic,assign)NSInteger dwDispOrder;


@end
