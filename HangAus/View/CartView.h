//
//  CartView.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/30.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartView : UIView
@property(nonatomic,assign)NSInteger num;

/**
 刷新
 */
-(void)reload;
@end
