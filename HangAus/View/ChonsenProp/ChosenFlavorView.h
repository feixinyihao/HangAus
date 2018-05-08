//
//  ChosenFlavorView.h
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/28.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShowFood,OrderFood;
@protocol ChosenFlavorViewDelegate <NSObject>
@optional
-(void)ChosenFlavorViewFinish:(OrderFood*)orderfood withView:(UIView*)view withTag:(NSInteger)tag;

@end

@interface ChosenFlavorView : UIView

-(instancetype)initWithFrame:(CGRect)frame withShowfood:(ShowFood*)showfood;
@property(nonatomic,strong)NSArray*shopCookWay;
@property(nonatomic,strong)NSArray*shopFlavor;
@property(nonatomic,strong)id <ChosenFlavorViewDelegate>delegate;
@property(nonatomic,strong)NSMutableArray*orderfoods;
@property(nonatomic,assign)BOOL isPackage;
@end
