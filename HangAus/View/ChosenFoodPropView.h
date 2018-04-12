//
//  ChosenFoodPropView.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/4/2.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShowFood,OrderFood;
@protocol ChosenFoodPropViewDelegate <NSObject>
@optional
-(void)ChosenFoodPropViewOrderWithSelFlavor:(NSString*)szSelFlavor withSelSubFood:(NSString*)szSelSubFood withSelCookWay:(NSInteger)dwSelCookWay withShowFood:(ShowFood*)showfood;
-(void)ChosenFoodPropViewOrderWithOrderFood:(OrderFood*)orderfood;
@end

@interface ChosenFoodPropView : UIView

-(instancetype)initWithShowFood:(ShowFood*)showfood withFlavorArray:(NSArray*)FlavorArray withCookwayArray:(NSArray*)cookwayArray;


@property(nonatomic,strong)id <ChosenFoodPropViewDelegate>delegate;
@end
