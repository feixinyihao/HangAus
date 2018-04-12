//
//  Database.m
//  scan
//
//  Created by 陈鑫荣 on 2017/12/23.
//  Copyright © 2017年 justprint. All rights reserved.
//

#import "DataBase.h"
#import <FMDatabase.h>
#import "ShowFood.h"
#import "ChosenFood.h"
#import "ShowGroup.h"
#import "SubFood.h"
#import "ShopSubFood.h"
#import<objc/runtime.h>

static DataBase *_DBCtl = nil;

@interface DataBase(){
    FMDatabase  *_db;

}

@end

@implementation DataBase

-(id)copy{
    
    return self;
    
}

-(id)mutableCopy{
    
    return self;
    
}
+(instancetype)sharedDataBase{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [[DataBase alloc] init];
        
        [_DBCtl initDataBase];
        
    }
    
    return _DBCtl;
    
}
- (NSArray *)allProperties:(id)class {
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


-(void)initDataBase{
    // 获得Documents目录路径
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 文件路径

    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"moder.sqlite"];
    
    // 实例化FMDataBase对象
    
    _db = [FMDatabase databaseWithPath:filePath];
    
    [_db open];
    
    // 初始化数据表
    NSString *Sql1 = @"CREATE TABLE  IF NOT EXISTS 'tblShowFood'  ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'UnitWeight' INTEGER,'FoodKindName' VARCHAR(255),'SubFoodProp' INTEGER,'UnitPrice' INTEGER,'Prop' INTEGER,'FoodKindID' INTEGER, 'Stat' INTEGER,'AbbrName' VARCHAR(255), 'Unit' VARCHAR(255),'CookWayProp' INTEGER,'FlavorProp' INTEGER, 'SoldProp' INTEGER,'Memo' VARCHAR(255),'FoodName' VARCHAR(255),'KindProp' INTEGER,'StoredNum' INTEGER,'ShopID' INTEGER,'FoodID' INTEGER,'ShowFoodID' INTEGER,'GroupID' INTEGER,'DispName' VARCHAR(255),'DispAbbr' VARCHAR(255),'DispOrder' INTEGER,'ShowProp' INTEGER,'Discount' INTEGER,'MinPrice' INTEGER,'IncSubFood' INTEGER,'DefQuantity' INTEGER) ";
    
    NSString *Sql2 = @"CREATE TABLE  IF NOT EXISTS 'tblChosenFood'  ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'ParentID' INTEGER,'Memo' VARCHAR(255),'ShowFoodID' INTEGER,'DispOrder' INTEGER,'CookWayProp' INTEGER,'SubFoodProp' INTEGER, 'FlavorProp' INTEGER,'Quantity' INTEGER) ";
    
    NSString *Sql3 = @"CREATE TABLE  IF NOT EXISTS 'tblShowGroup'  ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'Prop' INTEGER,'Memo' VARCHAR(255),'Type' INTEGER,'GroupName' VARCHAR(255),'ShopID' INTEGER,'GroupID' INTEGER, 'DispOrder' INTEGER) ";

    NSString *Sql4 = @"CREATE TABLE  IF NOT EXISTS 'tblSubFood'  ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'SFID' INTEGER,'AbbrName' VARCHAR(255),'Unit' VARCHAR(255),'Memo' VARCHAR(255),'Name' VARCHAR(255)) ";
    
     NSString *Sql5 = @"CREATE TABLE  IF NOT EXISTS 'tblShopSubFood'  ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'SFID' INTEGER,'AbbrName' VARCHAR(255),'Unit' VARCHAR(255),'Memo' VARCHAR(255),'Name' VARCHAR(255),'ValueName' VARCHAR(255),'UnitWeight' INTEGER,'Including' INTEGER,'UnitPrice' INTEGER,'SupFlavor' INTEGER,'DefValue' INTEGER,'Included' INTEGER,'DispOrder' INTEGER,'Discount' INTEGER,'MaxValue' INTEGER,'ShopID' INTEGER,'MinValue' INTEGER) ";
    

    [_db executeUpdate:Sql1];
    [_db executeUpdate:Sql2];
    [_db executeUpdate:Sql3];
    [_db executeUpdate:Sql4];
    [_db executeUpdate:Sql5];

    
    [_db close];
    
}
#pragma mark - 接口

/**
 添加套餐食物
 */
-(void)addChosenFood:(ChosenFood *)choseFood{
    [_db open];
    [_db executeUpdate:@"INSERT INTO tblChosenFood(ParentID,Memo,ShowFoodID,DispOrder,CookWayProp,SubFoodProp,FlavorProp,Quantity)VALUES(?,?,?,?,?,?,?,?)",[NSString stringWithFormat:@"%ld",choseFood.dwParentID],choseFood.szMemo,[NSString stringWithFormat:@"%ld",choseFood.dwShowFoodID],
        [NSString stringWithFormat:@"%ld",choseFood.dwDispOrder],
     [NSString stringWithFormat:@"%ld",choseFood.dwCookWayProp],
     [NSString stringWithFormat:@"%ld",choseFood.dwSubFoodProp],
     [NSString stringWithFormat:@"%ld",choseFood.dwFlavorProp],
     [NSString stringWithFormat:@"%ld",choseFood.dwQuantity]];
    [_db close];

}
-(void)addSubFood:(SubFood*)subFood{
    [_db open];
    [_db executeUpdate:@"INSERT INTO tblSubFood(SFID,AbbrName,Unit,Memo,Name)VALUES(?,?,?,?,?)",[NSString stringWithFormat:@"%ld",subFood.dwSFID],subFood.szAbbrName,subFood.szUnit,subFood.szMemo,subFood.szName];
    [_db close];
}
-(void)addshowGroup:(ShowGroup*)showGroup{
    [_db open];
    [_db executeUpdate:@"INSERT INTO tblShowGroup(Prop,Memo,Type,DispOrder,GroupName,ShopID,GroupID)VALUES(?,?,?,?,?,?,?)",[NSString stringWithFormat:@"%ld",showGroup.dwProp],showGroup.szMemo,[NSString stringWithFormat:@"%ld",showGroup.dwType],
     [NSString stringWithFormat:@"%ld",showGroup.dwDispOrder],showGroup.szGroupName,
     [NSString stringWithFormat:@"%ld",showGroup.dwShopID],
     [NSString stringWithFormat:@"%ld",showGroup.dwGroupID]];
     [_db close];
    
}
-(NSMutableArray*)getChosenFoodEqual:(NSString*)key{
    [_db open];
    NSMutableArray*dataArray=[NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tblChosenFood WHERE ParentID = '%@' ORDER BY DispOrder ASC",key];
    FMResultSet*res=[_db executeQuery:sql];
    while ([res next]) {
        ChosenFood*chosenFood=[[ChosenFood alloc]init];
        chosenFood.dwParentID=[res intForColumn:@"ParentID"];
        chosenFood.szMemo=[res stringForColumn:@"Memo"];
        chosenFood.dwShowFoodID=[res intForColumn:@"ShowFoodID"];
        chosenFood.dwDispOrder=[res intForColumn:@"DispOrder"];
        chosenFood.dwCookWayProp=[res intForColumn:@"CookWayProp"];
        chosenFood.dwSubFoodProp=[res intForColumn:@"SubFoodProp"];
        chosenFood.dwFlavorProp=[res intForColumn:@"FlavorProp"];
        chosenFood.dwQuantity=[res intForColumn:@"Quantity"];
        [dataArray addObject:chosenFood];
        
    }
    
    [_db close];
    return dataArray;
}
/**
 *  添加showfood
 *
 */
- (void)addShowFood:(ShowFood *)showFood{
    [_db open];
    [_db executeUpdate:@"INSERT INTO tblShowFood(UnitWeight,FoodKindName,SubFoodProp,UnitPrice,Prop,FoodKindID,Stat,AbbrName,Unit,CookWayProp,FlavorProp,SoldProp,Memo,FoodName,KindProp,StoredNum,ShopID,FoodID,ShowFoodID,GroupID,DispName,DispAbbr,DispOrder,ShowProp,Discount,MinPrice,IncSubFood,DefQuantity)VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
     [NSString stringWithFormat:@"%ld",showFood.dwUnitWeight],showFood.szFoodKindName,
     [NSString stringWithFormat:@"%ld",showFood.dwSubFoodProp],
     [NSString stringWithFormat:@"%ld",showFood.dwUnitPrice],
     [NSString stringWithFormat:@"%ld",showFood.dwProp],
     [NSString stringWithFormat:@"%ld",showFood.dwFoodKindID],
     [NSString stringWithFormat:@"%ld",showFood.dwStat],showFood.szAbbrName,showFood.szUnit,
     [NSString stringWithFormat:@"%ld",showFood.dwCookWayProp],
     [NSString stringWithFormat:@"%ld",showFood.dwFlavorProp],
     [NSString stringWithFormat:@"%ld",showFood.dwSoldProp],showFood.szMemo,showFood.szFoodName,
     [NSString stringWithFormat:@"%ld",showFood.dwKindProp],
     [NSString stringWithFormat:@"%ld",showFood.dwStoredNum],
     [NSString stringWithFormat:@"%ld",showFood.dwShopID],
     [NSString stringWithFormat:@"%ld",showFood.dwFoodID],
     [NSString stringWithFormat:@"%ld",showFood.dwShowFoodID],
     [NSString stringWithFormat:@"%ld",showFood.dwGroupID],showFood.szDispName,showFood.szDispAbbr,
     [NSString stringWithFormat:@"%ld",showFood.dwDispOrder],
     [NSString stringWithFormat:@"%ld",showFood.dwShowProp],
     [NSString stringWithFormat:@"%ld",showFood.dwDiscount],
     [NSString stringWithFormat:@"%ld",showFood.dwMinPrice],
     [NSString stringWithFormat:@"%ld",showFood.dwIncSubFood],
     [NSString stringWithFormat:@"%ld",showFood.dwDefQuantity]];

    [_db close];
    
    for (int i=0; i<showFood.ChosenFoods.count; i++) {
        [self addChosenFood:showFood.ChosenFoods[i]];
    }
    
}



- (void)addShopShowFood:(ShopSubFood *)ShopSubFood;{
    [_db open];
    [_db executeUpdate:@"INSERT INTO tblShopSubFood(AbbrName,Unit,Memo,Name,ValueName,SFID,UnitWeight,Including,UnitPrice,SupFlavor,DefValue,Included,DispOrder,Discount,MaxValue,ShopID,MinValue)VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",ShopSubFood.szAbbrName,ShopSubFood.szUnit,ShopSubFood.szMemo,ShopSubFood.szName,ShopSubFood.szValueName,
     [NSString stringWithFormat:@"%ld",ShopSubFood.dwSFID],
     [NSString stringWithFormat:@"%ld",ShopSubFood.dwUnitWeight],
     [NSString stringWithFormat:@"%ld",ShopSubFood.dwIncluding],
     [NSString stringWithFormat:@"%ld",ShopSubFood.dwUnitPrice],
     [NSString stringWithFormat:@"%ld",ShopSubFood.dwSupFlavor],
     [NSString stringWithFormat:@"%ld",ShopSubFood.dwDefValue],
     [NSString stringWithFormat:@"%ld",ShopSubFood.dwIncluded],
     [NSString stringWithFormat:@"%ld",ShopSubFood.dwDispOrder],
     [NSString stringWithFormat:@"%ld",ShopSubFood.dwDiscount],
     [NSString stringWithFormat:@"%ld",ShopSubFood.dwMaxValue],
     [NSString stringWithFormat:@"%ld",ShopSubFood.dwShopID],
     [NSString stringWithFormat:@"%ld",ShopSubFood.dwMinValue]];
    [_db close];
}

/**
 *  删除showfood
 *
 */
- (void)deleteShowFood:(ShowFood *)showFood{
    [_db open];
    
    [_db executeUpdate:@"DELETE FROM tblShowFood WHERE ShowFoodID = ?",showFood.dwShowFoodID];
    
    [_db close];
    
}
/**
 *  更新showfood
 *
 */
- (void)updateShowFood:(ShowFood *)ShowFood{
    [_db open];
    [_db executeUpdate:@"UPDATE 'tblShowFood' SET DispName = ?  WHERE ShowFoodID = ? ",ShowFood.szDispName,ShowFood.dwShowFoodID];

    [_db close];
    
}

/**
 *  获取所有数据
 *
 */
- (NSMutableArray *)getAllShowFood{
    
    [_db open];
        
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM tblShowFood ORDER BY ShowFoodID ASC"];
    
    FMResultSet *req = [_db executeQuery:@"SELECT * FROM tblChosenFood  ORDER BY DispOrder ASC"];

    NSMutableArray*temp=[NSMutableArray array];
    
    while ([req next]) {
        
        ChosenFood*chosenFood=[[ChosenFood alloc]init];
        chosenFood.dwParentID=[req intForColumn:@"ParentID"];
        chosenFood.szMemo=[req stringForColumn:@"Memo"];
        chosenFood.dwShowFoodID=[req intForColumn:@"ShowFoodID"];
        chosenFood.dwDispOrder=[req intForColumn:@"DispOrder"];
        chosenFood.dwCookWayProp=[req intForColumn:@"CookWayProp"];
        chosenFood.dwSubFoodProp=[req intForColumn:@"SubFoodProp"];
        chosenFood.dwFlavorProp=[req intForColumn:@"FlavorProp"];
        chosenFood.dwQuantity=[req intForColumn:@"Quantity"];
        [temp addObject:chosenFood];
    }
    while ([res next]) {
       
        ShowFood*showfood=[[ShowFood alloc]init];
        showfood.dwShowFoodID=[res intForColumn:@"ShowFoodID"];
        showfood.dwUnitWeight=[res intForColumn:@"UnitWeight"];
        showfood.dwSubFoodProp=[res intForColumn:@"SubFoodProp"];
        showfood.dwUnitPrice=[res intForColumn:@"UnitPrice"];
        showfood.dwProp=[res intForColumn:@"Prop"];
        showfood.dwFoodKindID=[res intForColumn:@"FoodKindID"];
        showfood.dwStat=[res intForColumn:@"Stat"];
        showfood.dwCookWayProp=[res intForColumn:@"CookWayProp"];
        showfood.dwFlavorProp=[res intForColumn:@"FlavorProp"];
        showfood.dwSoldProp=[res intForColumn:@"SoldProp"];
        showfood.dwKindProp=[res intForColumn:@"KindProp"];
        showfood.dwStoredNum=[res intForColumn:@"StoredNum"];
        showfood.dwShopID=[res intForColumn:@"ShopID"];
        showfood.dwGroupID=[res intForColumn:@"GroupID"];
        showfood.dwDispOrder=[res intForColumn:@"DispOrder"];
        showfood.dwShowProp=[res intForColumn:@"ShowProp"];
        showfood.dwDiscount=[res intForColumn:@"Discount"];
        showfood.dwMinPrice=[res intForColumn:@"MinPrice"];
        showfood.dwIncSubFood=[res intForColumn:@"IncSubFood"];
        showfood.dwDefQuantity=[res intForColumn:@"DefQuantity"];
        showfood.szDispName = [res stringForColumn:@"DispName"];
        showfood.szFoodKindName = [res stringForColumn:@"FoodKindName"];
        showfood.szAbbrName = [res stringForColumn:@"AbbrName"];
        showfood.szUnit = [res stringForColumn:@"Unit"];
        showfood.szMemo = [res stringForColumn:@"Memo"];
        NSMutableArray*chosenFoodTemp=[NSMutableArray array];
        for (int i=0; i<temp.count; i++) {
            ChosenFood*chosenFood=temp[i];
            if (chosenFood.dwParentID==showfood.dwShowFoodID) {
                [chosenFoodTemp addObject:chosenFood];
            }
        }
        showfood.ChosenFoods=chosenFoodTemp;
        [dataArray addObject:showfood];
    }
        
    [_db close];
    
    return dataArray;
    
}
- (NSMutableArray *)getAllSubFood{
    [_db open];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM tblSubFood ORDER BY SFID ASC"];
    
    while ([res next]) {
        SubFood*subFood=[[SubFood alloc]init];
        subFood.dwSFID=[res intForColumn:@"SFID"];
        subFood.szAbbrName=[res stringForColumn:@"AbbrName"];
        subFood.szUnit=[res stringForColumn:@"Unit"];
        subFood.szMemo=[res stringForColumn:@"Memo"];
        subFood.szName=[res stringForColumn:@"Name"];
        [dataArray addObject:subFood];
    }
    
    [_db close];
    
    return dataArray;
}

- (NSMutableArray *)getAllShopSubFood{
    [_db open];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM tblShopSubFood ORDER BY SFID ASC"];
    while ([res next]) {
        ShopSubFood*subFood=[[ShopSubFood alloc]init];
        subFood.dwSFID=[res intForColumn:@"SFID"];
        subFood.szAbbrName=[res stringForColumn:@"AbbrName"];
        subFood.szUnit=[res stringForColumn:@"Unit"];
        subFood.szMemo=[res stringForColumn:@"Memo"];
        subFood.szName=[res stringForColumn:@"Name"];
        subFood.szValueName=[res stringForColumn:@"ValueName"];
        
        subFood.dwUnitWeight=[res intForColumn:@"UnitWeight"];
        subFood.dwIncluding=[res intForColumn:@"Including"];
        subFood.dwUnitPrice=[res intForColumn:@"UnitPrice"];
        subFood.dwSupFlavor=[res intForColumn:@"SupFlavor"];
        subFood.dwDefValue=[res intForColumn:@"DefValue"];
        subFood.dwIncluded=[res intForColumn:@"Included"];
        subFood.dwDispOrder=[res intForColumn:@"DispOrder"];
        subFood.dwDiscount=[res intForColumn:@"Discount"];
        subFood.dwMaxValue=[res intForColumn:@"MaxValue"];
        subFood.dwShopID=[res intForColumn:@"ShopID"];
        subFood.dwMinValue=[res intForColumn:@"MinValue"];
        
        [dataArray addObject:subFood];
    }
    
    [_db close];
    
    return dataArray;
}
/**
 模糊搜索

 @param key 搜索关键字
 @return 返回对象数组
 */
-(NSMutableArray*)getShowFoodLike:(NSString *)key{
    [_db open];
    NSMutableArray*dataArray=[NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tblShowFood WHERE DispName like '%%%@%%' ORDER BY id ASC",key];
    FMResultSet*res=[_db executeQuery:sql];
    while ([res next]) {
        ShowFood*showfood=[[ShowFood alloc]init];
        showfood.dwShowFoodID=[res intForColumn:@"ShowFoodID"];
        showfood.dwUnitWeight=[res intForColumn:@"UnitWeight"];
        showfood.dwSubFoodProp=[res intForColumn:@"SubFoodProp"];
        showfood.dwUnitPrice=[res intForColumn:@"UnitPrice"];
        showfood.dwProp=[res intForColumn:@"Prop"];
        showfood.dwFoodKindID=[res intForColumn:@"FoodKindID"];
        showfood.dwStat=[res intForColumn:@"Stat"];
        showfood.dwCookWayProp=[res intForColumn:@"CookWayProp"];
        showfood.dwFlavorProp=[res intForColumn:@"FlavorProp"];
        showfood.dwSoldProp=[res intForColumn:@"SoldProp"];
        showfood.dwKindProp=[res intForColumn:@"KindProp"];
        showfood.dwStoredNum=[res intForColumn:@"StoredNum"];
        showfood.dwShopID=[res intForColumn:@"ShopID"];
        showfood.dwGroupID=[res intForColumn:@"GroupID"];
        showfood.dwDispOrder=[res intForColumn:@"DispOrder"];
        showfood.dwShowProp=[res intForColumn:@"ShowProp"];
        showfood.dwDiscount=[res intForColumn:@"Discount"];
        showfood.dwMinPrice=[res intForColumn:@"MinPrice"];
        showfood.dwIncSubFood=[res intForColumn:@"IncSubFood"];
        showfood.dwDefQuantity=[res intForColumn:@"DefQuantity"];
        
        showfood.szDispName = [res stringForColumn:@"DispName"];
        showfood.szFoodKindName = [res stringForColumn:@"FoodKindName"];
        showfood.szAbbrName = [res stringForColumn:@"AbbrName"];
        showfood.szUnit = [res stringForColumn:@"Unit"];
        showfood.szMemo = [res stringForColumn:@"Memo"];
        [dataArray addObject:showfood];
    }
    [_db close];
    return dataArray;
    

}

-(ShowFood*)getShowFoodWithID:(NSInteger)ShowFoodID{
    [_db open];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tblShowFood WHERE ShowFoodID = '%ld' ORDER BY DispOrder ASC",ShowFoodID];
    FMResultSet*res=[_db executeQuery:sql];
    ShowFood*showfood=[[ShowFood alloc]init];
    while ([res next]) {
        showfood.dwShowFoodID=[res intForColumn:@"ShowFoodID"];
        showfood.dwUnitWeight=[res intForColumn:@"UnitWeight"];
        showfood.dwSubFoodProp=[res intForColumn:@"SubFoodProp"];
        showfood.dwUnitPrice=[res intForColumn:@"UnitPrice"];
        showfood.dwProp=[res intForColumn:@"Prop"];
        showfood.dwFoodKindID=[res intForColumn:@"FoodKindID"];
        showfood.dwStat=[res intForColumn:@"Stat"];
        showfood.dwCookWayProp=[res intForColumn:@"CookWayProp"];
        showfood.dwFlavorProp=[res intForColumn:@"FlavorProp"];
        showfood.dwSoldProp=[res intForColumn:@"SoldProp"];
        showfood.dwKindProp=[res intForColumn:@"KindProp"];
        showfood.dwStoredNum=[res intForColumn:@"StoredNum"];
        showfood.dwShopID=[res intForColumn:@"ShopID"];
        showfood.dwGroupID=[res intForColumn:@"GroupID"];
        showfood.dwDispOrder=[res intForColumn:@"DispOrder"];
        showfood.dwShowProp=[res intForColumn:@"ShowProp"];
        showfood.dwDiscount=[res intForColumn:@"Discount"];
        showfood.dwMinPrice=[res intForColumn:@"MinPrice"];
        showfood.dwIncSubFood=[res intForColumn:@"IncSubFood"];
        showfood.dwDefQuantity=[res intForColumn:@"DefQuantity"];
        showfood.szDispName = [res stringForColumn:@"DispName"];
        showfood.szFoodKindName = [res stringForColumn:@"FoodKindName"];
        showfood.szAbbrName = [res stringForColumn:@"AbbrName"];
        showfood.szUnit = [res stringForColumn:@"Unit"];
        showfood.szMemo = [res stringForColumn:@"Memo"];
      
    }
    [_db close];
    return showfood;
}
-(NSMutableArray*)getShowFoodEqual:(NSString*)key{
    [_db open];
    NSMutableArray*dataArray=[NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tblShowFood WHERE GroupID = '%@' ORDER BY DispOrder ASC",key];
    FMResultSet*res=[_db executeQuery:sql];
    while ([res next]) {
        ShowFood*showfood=[[ShowFood alloc]init];
        showfood.dwShowFoodID=[res intForColumn:@"ShowFoodID"];
        showfood.dwUnitWeight=[res intForColumn:@"UnitWeight"];
        showfood.dwSubFoodProp=[res intForColumn:@"SubFoodProp"];
        showfood.dwUnitPrice=[res intForColumn:@"UnitPrice"];
        showfood.dwProp=[res intForColumn:@"Prop"];
        showfood.dwFoodKindID=[res intForColumn:@"FoodKindID"];
        showfood.dwStat=[res intForColumn:@"Stat"];
        showfood.dwCookWayProp=[res intForColumn:@"CookWayProp"];
        showfood.dwFlavorProp=[res intForColumn:@"FlavorProp"];
        showfood.dwSoldProp=[res intForColumn:@"SoldProp"];
        showfood.dwKindProp=[res intForColumn:@"KindProp"];
        showfood.dwStoredNum=[res intForColumn:@"StoredNum"];
        showfood.dwShopID=[res intForColumn:@"ShopID"];
        showfood.dwGroupID=[res intForColumn:@"GroupID"];
        showfood.dwDispOrder=[res intForColumn:@"DispOrder"];
        showfood.dwShowProp=[res intForColumn:@"ShowProp"];
        showfood.dwDiscount=[res intForColumn:@"Discount"];
        showfood.dwMinPrice=[res intForColumn:@"MinPrice"];
        showfood.dwIncSubFood=[res intForColumn:@"IncSubFood"];
        showfood.dwDefQuantity=[res intForColumn:@"DefQuantity"];
        showfood.szDispName = [res stringForColumn:@"DispName"];
        showfood.szFoodKindName = [res stringForColumn:@"FoodKindName"];
        showfood.szAbbrName = [res stringForColumn:@"AbbrName"];
        showfood.szUnit = [res stringForColumn:@"Unit"];
        showfood.szMemo = [res stringForColumn:@"Memo"];
        [dataArray addObject:showfood];
    }
    [_db close];
    return dataArray;
}

/**
 删除所有showfood
 */
-(void)deleteAllShowFood{
    [_db open];
    NSString*sql=[NSString stringWithFormat:@"DELETE FROM tblShowFood"];
    [_db executeUpdate:sql];
    [_db close];
}
-(void)deleteAllChosenFood{
    [_db open];
    NSString*sql=[NSString stringWithFormat:@"DELETE FROM tblChosenFood"];
    [_db executeUpdate:sql];
    [_db close];
}
-(void)deleteAllShowGroup{
    [_db open];
    NSString*sql=[NSString stringWithFormat:@"DELETE FROM tblShowGroup"];
    [_db executeUpdate:sql];
    [_db close];
}

-(void)deleteAllShopSubFood{
    [_db open];
    NSString*sql=[NSString stringWithFormat:@"DELETE FROM tblShopSubFood"];
    [_db executeUpdate:sql];
    [_db close];
}
- (NSMutableArray *)getAllShowGroup{
    [_db open];
    NSMutableArray*dataArray=[NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tblShowGroup ORDER BY DispOrder ASC"];
    FMResultSet*res=[_db executeQuery:sql];
    while ([res next]) {
        ShowGroup*showgroup=[[ShowGroup alloc]init];
        showgroup.szGroupName=[res stringForColumn:@"GroupName"];
        showgroup.szMemo=[res stringForColumn:@"Memo"];
        showgroup.dwGroupID=[res intForColumn:@"GroupID"];
        showgroup.dwShopID=[res intForColumn:@"ShopID"];
        showgroup.dwDispOrder=[res intForColumn:@"DispOrder"];
        showgroup.dwType=[res intForColumn:@"Type"];
        showgroup.dwProp=[res intForColumn:@"Prop"];
        [dataArray addObject:showgroup];
        
    }
    
    [_db close];
    return dataArray;
}
@end
