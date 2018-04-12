//
//  UniHttpTool.m
//  
//
//  Created by 陈鑫荣 on 16/7/1.
//  Copyright © 2016年 unifound. All rights reserved.
//

#import "UniHttpTool.h"
#import <AFNetworking.h>
#import "MBProgressHUD+MJ.h"
#import "CommonFunc.h"
#import<CommonCrypto/CommonDigest.h>
#import "StaffInfo.h"
#import "Language.h"
#import "StaffToken.h"
NSString * const actUrl[]={
    [StaffLogin] = @"staff/login/",
    [StaffLogout]=@"staff/logout/",
    [ChangeStaffPassword]=@"staff/chgpw/",
    [GetShop]=@"shop/getshop/",
    [SetShop]=@"shop/setshop/",
    [DelShop]=@"shop/delshop",
    [GetFoodKind]=@"food/getfoodkind/",
    [SetFoodkind]=@"food/setfoodkind/",
    [DelFoodkind]=@"food/delfoodkind/",
    [GetShowGroup]=@"food/getshowgroup/",
    [SetShowGroup]=@"food/setshowgroup/",
    [DelShowGroup]=@"food/delshowgroup/",
    [GetMultilanLib]=@"system/getmultilanlib/",
    [GetShopTradinghour]=@"shop/getshoptradinghour/",
    [SetShopTradinghour]=@"shop/setshoptradinghour/",
    [GetCookWay]=@"food/getcookway/",
    [SetCookWay]=@"food/setcookway/",
    [DelCookWay]=@"food/delcookway/",
    [GetSubFood]=@"food/getsubfood/",
    [SetSubFood]=@"food/setsubfood/",
    [DelSubFood]=@"food/delsubfood/",
    [GetFlavor]=@"food/getflavor/",
    [SetFlavor]=@"food/setflavor/",
    [DelFlavor]=@"food/delflavor/",
    [GetSoldFood]=@"food/getsoldfood/",
    [SetSoldFood]=@"food/setsoldfood/",
    [DelSoldFood]=@"food/delsoldfood/",
    [GetShowFood]=@"food/getshowfood/",
    [SetShowFood]=@"food/setshowfood/",
    [DelShowFood]=@"food/delshowfood/",
    [GetShopCookWay]=@"food/getshopcookway/",
    [SetShopCookWay]=@"food/setshopcookway/",
    [DelShopCookWay]=@"food/delshopcookway/",
    [GetShopSubFood]=@"food/getshopsubfood/",
    [SetShopSubFood]=@"food/setshopsubfood/",
    [DelShopSubFood]=@"food/delshopsubfood/",
    [GetShopFlavor]=@"food/getshopflavor/",
    [SetShopFlavor]=@"food/setshopflavor/",
    [DelShopFlavor]=@"food/delshopflavor/",
    [SetShowGrouporder]=@"food/setshowgrouporder/",
    [SetShowFoodorder]=@"food/setshowfoodorder/",
    [GetOrder]=@"food/getorder/",
    [GetOrderno]=@"food/getorderno/",
    [SetOrder]=@"food/setorder/",

};

@interface UniHttpTool()


@end
@implementation UniHttpTool

+(void)getwithparameters:(id)parameters
                  option:(act)option
                 success:(void (^)(id  json))success{
    NSString*URL=baseURL;
    AFHTTPSessionManager* manager=[AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    //manager.responseSerializer=[AFJSONResponseSerializer serializer];
 //   manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    URL=[NSString stringWithFormat:@"%@%@",baseURL,actUrl[option]];
    NSMutableDictionary*parm=[NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString* file=[KDoc stringByAppendingString:@"/language.data"];
    Language * lan=[NSKeyedUnarchiver unarchiveObjectWithFile:file];
    [parm setObject:KUID forKey:@"uid"];
    [parm setObject:@"app" forKey:@"_fr"];
    if (lan) {
        if (lan.value==0) {
            [parm setValue:@"1" forKey:@"dwLanSN"];
        }else{
            [parm setValue:@"2" forKey:@"dwLanSN"];
        }
    }else{
        if ( [[CommonFunc getCurrentLanguage] isEqualToString:@"en"]) {
            [parm setValue:@"1" forKey:@"dwLanSN"];
        }else{
            [parm setValue:@"2" forKey:@"dwLanSN"];
        }
       
    }

    StaffInfo *staff=[StaffInfo getStaffInfo];
    StaffToken*token=[StaffToken getStaffToken];
    if (token) {
        [parm setValue:[NSString stringWithFormat:@"%@",token.token] forKey:@"token"];
        [parm setValue:@(staff.dwShopID) forKey:@"dwShopID"];
    }

    DLog(@"%@---GET---%@",URL,parm);
    [manager GET:URL parameters:parm progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            DLog(@"%@",jsonStr);
            if ([responseObject[@"ret"] integerValue]==0) {
                success(responseObject);
            }else{
            
                KShowServerMessage(responseObject[@"error"]);
              
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error);
        [MBProgressHUD hideHUD];
        if (error.code == -1009) {
            [MBProgressHUD showError:@"网络已断开"];
        }else if (error.code == -1005){
            [MBProgressHUD showError:@"网络连接已中断"];
        }else if(error.code == -1001){
            [MBProgressHUD showError:@"请求超时" ];
        }else if (error.code == -1003){
            [MBProgressHUD showError:@"未能找到使用指定主机名的服务器"];
        }
    }];

}
+(void)postwithparameters:(id)parameters
                   option:(act)option
                  success:(void (^)(id  json))success{
    NSString*URL=baseURL;
    AFHTTPSessionManager* manager=[AFHTTPSessionManager manager];
    URL=[NSString stringWithFormat:@"%@%@",baseURL,actUrl[option]];
    manager.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
   // manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary*parm=[NSMutableDictionary dictionaryWithDictionary:parameters];
    [parm setObject:KUID forKey:@"uid"];
    [parm setObject:@"app" forKey:@"_fr"];
    StaffToken*token=[StaffToken getStaffToken];
    StaffInfo *staff=[StaffInfo getStaffInfo];
    if (token) {
        [parm setValue:token.token forKey:@"token"];
        [parm setValue:@(staff.dwShopID) forKey:@"dwShopID"];
    }
    NSString* file=[KDoc stringByAppendingString:@"/language.data"];
    Language * lan=[NSKeyedUnarchiver unarchiveObjectWithFile:file];
    if (lan) {
        if (lan.value==0) {
            [parm setValue:@"1" forKey:@"dwLanSN"];
        }else{
            [parm setValue:@"2" forKey:@"dwLanSN"];
        }
    }else{
        if ( [[CommonFunc getCurrentLanguage] isEqualToString:@"en"]) {
            [parm setValue:@"1" forKey:@"dwLanSN"];
        }else{
            [parm setValue:@"2" forKey:@"dwLanSN"];
        }
        
    }
    DLog(@"%@---POST---%@",URL,parameters);
    [manager POST:URL parameters:parm progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
//            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            //NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
          //  DLog(@"%@",jsonStr);
            DLog(@"%@",responseObject);
            success(responseObject);
          //  NSString*str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
           // DLog(@"%@",str);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error);
        [MBProgressHUD hideHUD];
        if (error.code == -1009) {
            [MBProgressHUD showError:@"网络已断开"];
        }else if (error.code == -1005){
            [MBProgressHUD showError:@"网络连接已中断"];
        }else if(error.code == -1001){
            [MBProgressHUD showError:@"请求超时" ];
        }else if (error.code == -1003){
            [MBProgressHUD showError:@"未能找到使用指定主机名的服务器"];
        }
    }];
}

@end
