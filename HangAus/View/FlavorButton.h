//
//  FlavorButton.h
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/11.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopFlavor;
@interface FlavorButton : UIButton

@property(nonatomic,strong)ShopFlavor*shopflavor;
@property(nonatomic,assign)NSInteger value;

@end
