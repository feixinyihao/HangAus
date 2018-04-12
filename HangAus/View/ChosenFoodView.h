//
//  ChosenFoodView.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/22.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChosenFoodViewDelegate <NSObject>
@optional
-(void)ChosenFoodViewBtnClick:(UIButton*)button withChosenFoods:(NSMutableArray*)chosenFoods;
@end
@interface ChosenFoodView : UIView
-(instancetype)initWithFrame:(CGRect)frame chosenFoods:(NSArray*)chosenFoods;
@property(nonatomic,strong)NSMutableArray*chosenFoods;
@property(nonatomic,strong)id <ChosenFoodViewDelegate>delegate;

-(void)reload;
@end
