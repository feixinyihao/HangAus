//
//  CommonFunc.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/2/8.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "CommonFunc.h"
#import "Language.h"
#import "MBProgressHUD+MJ.h"
#import <MJExtension.h>
#import "LoginViewController.h"
#import "BaseNavigationController.h"
@implementation CommonFunc

/** @brief Returns a customized snapshot of a given view. */
+(UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

//获取当前语言
+(NSString*)getCurrentLanguage
{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    DLog(@"%@",preferredLang);
    if ([preferredLang hasPrefix:@"en"]) {
        preferredLang = @"en";
    } else if ([preferredLang hasPrefix:@"zh"]) {
        if ([preferredLang rangeOfString:@"Hans"].location != NSNotFound) {
            preferredLang = @"zh-Hans"; // 简体中文
        } else { // zh-Hant\zh-HK\zh-TW
            preferredLang = @"zh-Hant"; // 繁體中文
        }
    } else {
        preferredLang = @"en";
    }
    return preferredLang;
    
}

+(NSString *)showText:(NSString *)key{

    NSString* file=[KDoc stringByAppendingString:@"/language.data"];
    Language * lan=[NSKeyedUnarchiver unarchiveObjectWithFile:file];
    if (lan) {
        NSString *path = [[NSBundle mainBundle] pathForResource:lan.code ofType:@"lproj"];
        // DLog(@"存在%@---%@",lan.code,path);
        return [[NSBundle bundleWithPath:path] localizedStringForKey:key value:nil table:@"Main"];
    }else{
        NSString *path = [[NSBundle mainBundle] pathForResource:[self getCurrentLanguage] ofType:@"lproj"];
       // DLog(@"不存在");
        return [[NSBundle bundleWithPath:path] localizedStringForKey:key value:nil table:@"Main"];
        
    }
}

/**
 获取当前的viewcontroller
 
 */
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}
//显示服务器返回的信息
+(void)showServerMessage:(NSDictionary*)dic{
    NSString*code=[NSString stringWithFormat:@"%@",dic[@"code"]];
    if ([code integerValue]==-1||[code integerValue]==0) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:dic[@"detail"]];
    }else{
        [MBProgressHUD hideHUD];
        if ([code integerValue]==2000003||[code integerValue]==2000004||[code integerValue]==2000005) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIWindow * window = [[UIApplication sharedApplication] keyWindow];
                LoginViewController*login=[[LoginViewController alloc]init];
                BaseNavigationController*base=[[BaseNavigationController alloc]initWithRootViewController:login];
                window.rootViewController=base;
            });
        }
        [MBProgressHUD showError:KLocalizedString(code)];
    }
    
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        DLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}

+ (NSString *)returnJSONStringWithDictionary:(NSDictionary *)dictionary{
    
    
    NSString *jsonStr = @"{";
    
    NSArray * keys = [dictionary allKeys];
    
    for (NSString * key in keys) {
        
        if ([key hasPrefix:@"dw"]) {
            jsonStr = [NSString stringWithFormat:@"%@\"%@\":%@,",jsonStr,key,[dictionary objectForKey:key]];
        }else{
            jsonStr = [NSString stringWithFormat:@"%@\"%@\":\"%@\",",jsonStr,key,[dictionary objectForKey:key]];
        }
        
    }
    
    jsonStr = [NSString stringWithFormat:@"%@%@",[jsonStr substringWithRange:NSMakeRange(0, jsonStr.length-1)],@"}"];
    return jsonStr;
}

/**
 数组返回字符串
 */
+ (NSString *)returnStringWithArray:(NSArray *)array{
    NSMutableArray*arrTemp=[NSMutableArray array];
    for (int i=0; i<array.count; i++) {
        NSDictionary*dict=array[i];
        NSString*strTemp=@"";
        if ([dict isKindOfClass:[NSDictionary class]]) {
             strTemp=[self returnJSONStringWithDictionary:dict];
            
        }else{
           
            strTemp=[self returnJSONStringWithDictionary:dict.mj_keyValues];
        }
        [arrTemp addObject:strTemp];
       
    }
    return [NSString stringWithFormat:@"[%@]",[arrTemp componentsJoinedByString:@","]];
}
@end
