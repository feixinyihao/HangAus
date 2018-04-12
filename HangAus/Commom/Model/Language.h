//
//  Language.h
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/2/27.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Language : NSObject
@property(nonatomic,copy)NSString* code;
@property(nonatomic,assign)int value;
@property(nonatomic,copy)NSString*desc;

+(instancetype)LanguageWithDic:(NSDictionary* )dic;
-(instancetype)initWithDic:(NSDictionary*)dic;
@end
