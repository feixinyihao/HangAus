//
//  UniHttpTool.h
//  
//
//  Created by 陈鑫荣 on 16/7/1.
//  Copyright © 2016年 unifound. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* baseURL=@"http://10.121.0.250:8088/api/v1/";



typedef NS_ENUM(NSUInteger,act) {
    
    StaffLogin = 0,
    StaffLogout,
    ChangeStaffPassword,
    GetShop,
    SetShop,
    DelShop,
    GetFoodKind,
    SetFoodkind,
    DelFoodkind,
    GetShowGroup,
    SetShowGroup,
    DelShowGroup,
    GetMultilanLib,
    GetShopTradinghour,
    SetShopTradinghour,
    GetCookWay,
    SetCookWay,
    DelCookWay,
    GetSubFood,
    SetSubFood,
    DelSubFood,
    GetFlavor,
    SetFlavor,
    DelFlavor,
    GetSoldFood,
    SetSoldFood,
    DelSoldFood,
    GetShowFood,
    SetShowFood,
    DelShowFood,
    GetShopCookWay,
    SetShopCookWay,
    DelShopCookWay,
    GetShopSubFood,
    SetShopSubFood,
    DelShopSubFood,
    GetShopFlavor,
    SetShopFlavor,
    DelShopFlavor,
    SetShowGrouporder,
    SetShowFoodorder,
    GetOrder,
    GetOrderno,
    SetOrder,

};

@interface UniHttpTool : NSObject



+(void)getwithparameters:(id)parameters
                  option:(act)option
                 success:(void (^)(id  json))success;



+(void)postwithparameters:(id)parameters
                  option:(act)option
                 success:(void (^)(id  json))success;




@end
