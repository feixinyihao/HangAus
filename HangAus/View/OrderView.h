//
//  OrderView.h
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/25.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderFood;
@protocol OrderViewDelegate <NSObject>

@optional
-(void)OrderViewEmpty:(UIButton*)button;
-(void)OrderViewActionWithOrderfood:(OrderFood*)orderfood withStatus:(BOOL)status withNum:(NSInteger)num;
@end

@interface OrderView : UIView
@property(nonatomic,strong)NSMutableArray*orderfoods;
@property(nonatomic,strong)id <OrderViewDelegate>delegate;
@end
