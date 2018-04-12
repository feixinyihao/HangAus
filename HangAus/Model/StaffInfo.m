//
//  StaffInfo.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/15.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "StaffInfo.h"
#import <MJExtension.h>
#define file [KDoc stringByAppendingString:@"/StaffInfo.data"]
@implementation StaffInfo

MJCodingImplementation

+(void)save:(StaffInfo*)staffInfo{
   
    [NSKeyedArchiver archiveRootObject:staffInfo toFile:file];
}
+(StaffInfo*)getStaffInfo{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:file];
}
-(void)save{
     [NSKeyedArchiver archiveRootObject:self toFile:file];
}
@end
