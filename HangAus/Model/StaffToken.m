//
//  StaffToken.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/23.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "StaffToken.h"
#import <MJExtension.h>
#define file [KDoc stringByAppendingString:@"/StaffToken.data"]
@implementation StaffToken
MJCodingImplementation

+(void)save:(StaffToken*)staffToken{
     [NSKeyedArchiver archiveRootObject:staffToken toFile:file];
}
-(void)save{
    [NSKeyedArchiver archiveRootObject:self toFile:file];
}
+(StaffToken*)getStaffToken{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:file];
}
@end
