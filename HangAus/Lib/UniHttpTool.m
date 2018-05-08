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
#import <BGFMDB.h>
#import <MJExtension.h>
NSString*const actClass[]={
    [GetShopCookWay]=@"ShopCookway",
    [GetShopSubFood]=@"ShopSubFood",
    [GetShopFlavor]=@"ShopFlavor",
    [GetShop]=@"ShopInfo",
};
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
    [SetShowfoodprice]=@"food/setshowfoodprice/",
    [ShopInitOk]=@"shop/shopinitok/",
    [SetShopsubfoodprice]=@"food/setshopsubfoodprice/",
};

@interface UniHttpTool()
@property(nonatomic,strong)MBProgressHUD*HUD;

@end
@implementation UniHttpTool

+(void)getwithparameters:(id)parameters
                  option:(act)option
                 success:(void (^)(id  json))success{
    NSString*URL=baseURL;
    AFHTTPSessionManager* manager=[AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
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

-(void)uploadWithparameters:(id)parameters
                       name:(NSString *)name
                   filename:(NSString*)filename
                 uploadData:(NSData*)data
                   mineType:(NSString*)mineType
                    success:(void (^)(id  json))success{
    NSString* URL=[NSString stringWithFormat:@"%@upload/img/",baseURL];
    AFHTTPSessionManager* manager=[AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    [manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [self hudTipWillShow:YES];
        [formData appendPartWithFileData:data name:name fileName:filename  mimeType:mineType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        self.HUD.progress=uploadProgress.fractionCompleted;
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hudTipWillShow:NO];
        if (success) {
            success(responseObject);
            NSString*str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            DLog(@"%@",str);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hudTipWillShow:NO];
        
        if (error.code == -1009) {
            [MBProgressHUD showError:@"网络已断开"];
        }else if (error.code == -1005){
            [MBProgressHUD showError:@"网络连接已中断"];
        }else if(error.code == -1001){
            [MBProgressHUD showError:@"请求超时"];
        }else if (error.code == -1003){
            [MBProgressHUD showError:@"未能找到使用指定主机名的服务器"];
        }else{
            [MBProgressHUD showError:@"上传失败"];
            
            
        }
        
    }];
    
}
+(void)uploadWithparameters:(id)parameters
                   filename:(NSString*)filename
                 uploadData:(NSData*)data
                    success:(void (^)(id  json))success{
    [[[self alloc]init] uploadWithparameters:parameters name:@"img" filename:@"hangaus.jpg" uploadData:data mineType:@"image/jpeg" success:^(id json) {
        if (success) {
            success(json);
        }
        
    }];
}
#pragma mark -- init MBProgressHUD
-(void)hudTipWillShow:(BOOL)willShow{
    if (willShow) {
        [[CommonFunc getCurrentVC] resignFirstResponder];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (!_HUD) {
            _HUD = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
            _HUD.mode = MBProgressHUDModeDeterminate;
            _HUD.progress = 0;
            _HUD.labelText = @"上传中";
            _HUD.removeFromSuperViewOnHide = YES;
        }else{
            _HUD.progress = 0;
            _HUD.labelText = @"上传中";
            [keyWindow addSubview:_HUD];
            [_HUD show:YES];
        }
    }else{
        [_HUD hide:YES];
    }
}

+ (void)getDataWithOption:(act)option Success:(void(^)(NSArray *modelArray))success{
    NSArray*models=[NSArray array];
    models=[NSClassFromString(actClass[option]) bg_findAll:nil];
    if (models.count<=0) {
        [self getDataFromHttpWithOption:option Success:^(NSArray *modelArray) {
            if (success) {
                success(modelArray);
            }
        }];
    }else{
        if (success) {
            success(models);
        }
        id obj=[models firstObject];
        if (([CommonFunc getCurrentDate]-[CommonFunc getTimestanps:[obj bg_updateTime]])>86400) {
            [self getDataFromHttpWithOption:option Success:^(NSArray *modelArray) {
            }];
        }
    }
}
+ (void)getDataFromHttpWithOption:(act)option Success:(void(^)(NSArray *modelArray))success{
    [self getwithparameters:nil option:option success:^(id json) {
        NSArray*models=[NSArray array];
        if ([json[@"data"] isKindOfClass:[NSArray class]]) {
            NSMutableArray*temp=[NSMutableArray array];
            for (NSDictionary *dict in json[@"data"]) {
                id obj=[NSClassFromString(actClass[option]) mj_objectWithKeyValues:dict];
                [obj bg_saveOrUpdate];
                [temp addObject:obj];
            }
            models=temp;
        }else{
            id obj=[NSClassFromString(actClass[option]) mj_objectWithKeyValues:json[@"data"]];
            [obj bg_saveOrUpdate];
            models=@[obj];
        }
        if (success) {
            success(models);
        }
    }];
}
@end
