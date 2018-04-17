//
//  ClassDataBase.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/14.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "ClassDataBase.h"
#import <FMDatabase.h>
#import<objc/runtime.h>
static ClassDataBase *_DBCtl = nil;

@interface ClassDataBase(){
    FMDatabase  *_db;
    
}

@end

@implementation ClassDataBase


+(instancetype)sharedDataBase{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [[ClassDataBase alloc] init];
        
        [_DBCtl initDataBase];
        
    }
    
    return _DBCtl;
    
}
-(void)initDataBase{
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"HangAusDB.sqlite"];
    _db = [FMDatabase databaseWithPath:filePath];
    [_db open];
    NSString*sqlStr=@"";
    NSArray*propArray=[self getAllProperties:NSClassFromString(@"ShowFood")];
    for (int i=0; i<propArray.count; i++) {
        if ([propArray[i] hasPrefix:@"T@\"NSString\""]) {
            
        }
    }
   
    
}

- (NSArray *)getAllProperties:(id)class {
    unsigned int count;
    
    // 获取类的所有属性
    // 如果没有属性，则count为0，properties为nil
    objc_property_t *properties = class_copyPropertyList([class class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (NSUInteger i = 0; i < count; i++) {
        // 获取属性名称
        //const char *propertyName = property_getName(properties[i]);
        // NSString *name = [NSString stringWithUTF8String:propertyName];
        NSString*property=[NSString stringWithUTF8String:property_getAttributes(properties[i])];
        [propertiesArray addObject:property];
    }
    
    // 注意，这里properties是一个数组指针，是C的语法，
    // 我们需要使用free函数来释放内存，否则会造成内存泄露
    free(properties);
    
    return propertiesArray;
}

@end
