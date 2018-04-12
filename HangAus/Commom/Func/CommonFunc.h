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
@end
