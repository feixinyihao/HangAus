//
//  SetSubFoodViewController.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/23.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetSubFoodViewController : UITableViewController
@property(nonatomic,assign)NSInteger subFoodProp;

@property(nonatomic,copy)void (^VCBlock)(NSDictionary *vegDic);

@end
