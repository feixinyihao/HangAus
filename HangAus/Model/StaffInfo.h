//
//  StaffInfo.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/15.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaffInfo : NSObject<NSCoding>
@property(nonatomic,copy)NSString*szEducation;
@property(nonatomic,copy)NSString*szTel;
@property(nonatomic,assign)NSInteger dwShopID;
@property(nonatomic,assign)NSInteger dwStaffID;
@property(nonatomic,copy)NSString*szLogonName;
@property(nonatomic,assign)NSInteger dwSex;
@property(nonatomic,assign)NSInteger dwBirthDate;
@property(nonatomic,assign)NSInteger dwEnrollDate;
@property(nonatomic,assign)NSInteger dwPostCode;
@property(nonatomic,assign)NSInteger dwFirstLanSN;
@property(nonatomic,assign)NSInteger dwJobType;
@property(nonatomic,assign)NSInteger dwJobTitle;
@property(nonatomic,assign)NSInteger dwStaffStat;
@property(nonatomic,assign)NSInteger dwLeaveDate;
@property(nonatomic,assign)NSInteger dwEndDate;
@property(nonatomic,copy)NSString*szPasswd;
@property(nonatomic,copy)NSString*szFirstName;
@property(nonatomic,copy)NSString*szMobilePhone;
@property(nonatomic,copy)NSString*szNationality;
@property(nonatomic,copy)NSString*szMemo;
@property(nonatomic,copy)NSString*szDynamicInfo;
@property(nonatomic,copy)NSString*szAddress;
@property(nonatomic,copy)NSString*szGraduateSchool;
@property(nonatomic,copy)NSString*szEmail;
@property(nonatomic,copy)NSString*szOpenID;

@property(nonatomic,copy)NSString*szMajor;
@property(nonatomic,copy)NSString*szIDCard;
@property(nonatomic,copy)NSString*szCallTitle;
@property(nonatomic,copy)NSString*szShopName;
@property(nonatomic,copy)NSString*szLastName;


+(void)save:(StaffInfo*)staffInfo;
-(void)save;
+(StaffInfo*)getStaffInfo;

@end
