//
//  SubfoodBtn.h
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/17.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopSubFood,SubfoodBtn;
@protocol SubfoodBtnDelegate <NSObject>

@optional
-(void)SubfoodBtnClick:(SubfoodBtn*)button;

@end

@interface SubfoodBtn : UIButton
@property(nonatomic,assign)NSInteger subfoodPrice;
@property(nonatomic,assign)BOOL isDefInc;
@property(nonatomic,strong)ShopSubFood*subfood;
@property(nonatomic,assign)NSInteger value;
@property(nonatomic,assign)NSInteger defValue;

@property(nonatomic,strong)id <SubfoodBtnDelegate>delegate;
@end
