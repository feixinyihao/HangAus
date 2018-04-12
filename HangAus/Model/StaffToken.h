//
//  StaffToken.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/23.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaffToken : NSObject
@property(nonatomic,copy)NSString*token;
+(void)save:(StaffToken*)staffToken;
-(void)save;
+(StaffToken*)getStaffToken;
@end
