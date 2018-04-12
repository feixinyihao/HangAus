//
//  ChoseSubFoodView.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/4/8.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChoseSubFoodViewDelegate <NSObject>

@optional
-(void)ChoseSubFoodViewBtnClick:(UIButton*)button withincSubfood:(NSInteger)incSubfood;

@end
@interface ChoseSubFoodView : UIView
-(instancetype)initWithFrame:(CGRect)frame incSubfood:(NSInteger)incSubfood withSubfood:(NSInteger)subfood;

@property(nonatomic,strong)id <ChoseSubFoodViewDelegate>delegate;
@end
