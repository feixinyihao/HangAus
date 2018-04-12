//
//  Language.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/2/27.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "Language.h"

@implementation Language
+(instancetype)LanguageWithDic:(NSDictionary* )dic{
    return [[self alloc]initWithDic:dic];
}
-(instancetype)initWithDic:(NSDictionary*)dic{
    if (self=[super init]) {
        self.value=[dic[@"value"] intValue];
        self.code=dic[@"code"];
        self.desc=dic[@"desc"];
        
    }
    return self;

}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self=[super init]) {
       
        self.value=[aDecoder decodeInt32ForKey:@"value"];
        self.code=[aDecoder decodeObjectForKey:@"code"];
        self.desc=[aDecoder decodeObjectForKey:@"desc"];
      
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
   
    [aCoder encodeInt32:self.value forKey:@"value"];
    [aCoder encodeObject:self.code forKey:@"code"];
    [aCoder encodeObject:self.desc forKey:@"desc"];
   
}
@end
