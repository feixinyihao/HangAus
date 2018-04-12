//
//  SetCookWayViewController.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/25.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCookWayViewController : UITableViewController
@property(nonatomic,assign)NSInteger cookWayProp;
@property(nonatomic,copy)void (^VCBlock)(NSDictionary *vegDic);
@end
