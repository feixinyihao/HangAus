//
//  ChosenPackageFoodView.h
//  HangAus
//
//  Created by 陈鑫荣 on 2018/5/7.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChosenFood,ChosenPackageFoodView;
@protocol ChosenPackageFoodViewDelegate <NSObject>
@optional
-(void)ChosenPackageFoodViewDelete:(ChosenPackageFoodView*)ChosenPackageFoodView;
-(void)ChosenPackageFoodViewincreaseStatus:(BOOL)increaseStatus withChosenPackageFoodView:(ChosenPackageFoodView*)ChosenPackageFoodView;
@end

@interface ChosenPackageFoodView : UIView
@property(nonatomic,strong)ChosenFood*chosenfood;
@property(nonatomic,strong)id <ChosenPackageFoodViewDelegate>delegate;
@end
