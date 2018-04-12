//
//  WeekSelectViewController.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/16.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WeekSelectViewControllerDelegate <NSObject>

@optional
-(void)WeekSelectViewControllerDidSave:(NSArray*)weekArray;
@end

@interface WeekSelectViewController : UITableViewController
@property(nonatomic,strong)id <WeekSelectViewControllerDelegate>delegate;
@end
