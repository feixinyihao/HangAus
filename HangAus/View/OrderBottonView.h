//
//  OrderBottonView.h
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/27.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OrderBottonViewDelegate <NSObject>

@optional
-(void)OrderBottonViewClick:(id)sender;

@end
@interface OrderBottonView : UIView
@property(nonatomic,strong)NSArray*orderfoods;

@property(nonatomic,strong)id <OrderBottonViewDelegate>delegate;
@end
