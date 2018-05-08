//
//  CommonFunc.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/2/8.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CommonFunc : NSObject
+ (UIView *)customSnapshoFromView:(UIView *)inputView;
+(NSString*)getCurrentLanguage;
+(NSString *)showText:(NSString *)key;

+(UIViewController *)getCurrentVC;
+(void)showServerMessage:(NSDictionary*)dic;
+ (NSString*)convertToJSONData:(id)infoDict;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString *)returnJSONStringWithDictionary:(NSDictionary *)dictionary;
+ (NSString *)returnStringWithArray:(NSArray *)array;
+ (long long)getCurrentDate;
+ (long long)getTimestanps:(NSString*)time;
+ (NSString *) md5:(NSString *) input;

/**
根据颜色返回图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

+(void)alert:(NSString*)title withMessage:(NSString*)message :(void (^)(UIAlertAction *acton))success;
+ (void)actionSheet:(NSString*)title1 withTitle2:(NSString*)title2;
@end
