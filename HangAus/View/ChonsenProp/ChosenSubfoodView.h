//
//  ChosenSubfoodView.h
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/28.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShowFood,OrderFood;
@protocol ChosenSubfoodViewDelegate <NSObject>
@optional
-(void)ChosenSubfoodViewFinish:(OrderFood*)orderfood withView:(UIView*)view withTag:(NSInteger)tag;

@end
@interface ChosenSubfoodView : UIView

@property(nonatomic,strong)NSArray*shopSubfoods;

-(instancetype)initWithFrame:(CGRect)frame withShowFood:(ShowFood*)showfood;
@property(nonatomic,strong)id <ChosenSubfoodViewDelegate>delegate;
@property(nonatomic,strong)NSMutableArray*orderfoods;
@property(nonatomic,assign)BOOL isPackage;
@end
