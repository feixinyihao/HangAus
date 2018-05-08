//
//  ChosenFoodPropView.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/4/2.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "ChosenFoodPropView.h"
#import "ShowFood.h"
#import "ShopFlavor.h"
#import "ShopCookway.h"
#import "ShopSubFood.h"
#import "OrderFood.h"
#import "FlavorButton.h"
#import "ChosenFood.h"
#import <BGFMDB.h>
#import "UniHttpTool.h"
#import <MJExtension.h>
#import "SubfoodBtn.h"
#import <PPNumberButton.h>
@interface ChosenFoodPropView()<SubfoodBtnDelegate,FlavorButtonDelegate>
@property(nonatomic,strong)ShowFood*showFood;
@property(nonatomic,weak)UIView*backgroundView;
@property(nonatomic,strong)NSArray*shopFlavorArray;
@property(nonatomic,strong)NSArray*shopCookwayArray;
@property(nonatomic,strong)NSArray*subfoodArray;

@property(nonatomic,assign)NSInteger dwSelCookWay;
@property(nonatomic,copy)NSString*szSelSubFood;
@property(nonatomic,copy)NSString*szSelFlavor;

@property(nonatomic,weak)UILabel*priceL;

@property(nonatomic,assign)NSInteger cookWayprop;

@property(nonatomic,assign)NSInteger dwCookPrice;

@property(nonatomic,assign)BOOL isPackage;

@property(nonatomic,assign)NSInteger price;
@property(nonatomic,assign)NSInteger priceOffset;
@property(nonatomic,assign)NSInteger cookwayPrice;

@property(nonatomic,weak)UIButton*addBtn;
@property(nonatomic,weak)PPNumberButton*ppBtn;
@end
@implementation ChosenFoodPropView

-(instancetype)initWithShowFood:(ShowFood*)showfood{
    if ([super init]) {
        self.priceOffset=0;
        self.szSelSubFood=@"";
        self.showFood=showfood;
        self.frame=[UIScreen mainScreen].bounds;
        self.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleTap];
        UIView*backgroundView=[[UIView alloc]initWithFrame:CGRectMake(40, 150, kScreenW-80, kScreenH-300)];
        backgroundView.backgroundColor=[UIColor whiteColor];
        self.backgroundView=backgroundView;
        backgroundView.layer.cornerRadius=5;
        backgroundView.layer.masksToBounds=YES;
        backgroundView.tag=999;
        [self addSubview:backgroundView];
        UILabel*nameL=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, backgroundView.bounds.size.width, 30)];
        nameL.textAlignment=NSTextAlignmentCenter;
        nameL.font=[UIFont systemFontOfSize:15];
        nameL.textColor=[UIColor blackColor];
        nameL.text=self.showFood.szDispName;
        [backgroundView addSubview:nameL];
        
        UIButton*delBtn=[[UIButton alloc]initWithFrame:CGRectMake(backgroundView.bounds.size.width-25, 0, 25, 25)];
        [delBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:delBtn];
        [self setupBottomWithSupView:backgroundView withShowfood:self.showFood];
        
        if ([ShopCookway bg_findAll:nil].count==0||[ShopSubFood bg_findAll:nil].count==0||[ShopFlavor bg_findAll:nil].count==0) {
            [self setupData];
        }else{
            self.shopCookwayArray=[ShopCookway bg_findAll:nil];
            self.shopFlavorArray=[ShopFlavor bg_findAll:nil];
            self.subfoodArray=[ShopSubFood bg_findAll:nil];
            [self viewInit];
            //检查是否要更新
            ShopSubFood*subfood=[self.subfoodArray firstObject];
            //大于10天更新
            DLog(@"%@",subfood.bg_updateTime);
            [self dataUpdate];
        }
    }
    return self;
}
-(instancetype)initWithShowFood:(ShowFood *)showfood isPackage:(BOOL)package{
    self.isPackage=package;
    return [self initWithShowFood:showfood];
}
-(void)dataUpdate{
    ShopSubFood*subfood=[self.subfoodArray firstObject];
    //大于1天更新
    if (([CommonFunc getCurrentDate]-[CommonFunc getTimestanps:subfood.bg_updateTime])>86400) {
        [UniHttpTool getwithparameters:nil option:GetShopSubFood success:^(id json) {
            for (NSDictionary *dict in json[@"data"]) {
                ShopSubFood*subfood=[ShopSubFood mj_objectWithKeyValues:dict];
                [subfood bg_saveOrUpdate];
            }
        }];
        
        [UniHttpTool getwithparameters:nil option:GetShopCookWay success:^(id json) {
            for (NSDictionary *dict in json[@"data"]) {
                ShopCookway*cookway=[ShopCookway mj_objectWithKeyValues:dict];
                [cookway bg_saveOrUpdate];
            }
        }];
        
        [UniHttpTool getwithparameters:nil option:GetShopFlavor success:^(id json) {
            for (NSDictionary *dict in json[@"data"]) {
                ShopFlavor*flavor=[ShopFlavor mj_objectWithKeyValues:dict];
                [flavor bg_saveOrUpdate];
            }
        }];
    }
}
-(void)setupData{
    NSMutableArray*tempSubfoods=[NSMutableArray array];
    NSMutableArray*tempCookWays=[NSMutableArray array];
    NSMutableArray*tempflavors=[NSMutableArray array];
    //初始化配菜
    [UniHttpTool getwithparameters:nil option:GetShopSubFood success:^(id json) {
        for (NSDictionary*dict in json[@"data"]) {
            ShopSubFood*shopsubfood=[ShopSubFood mj_objectWithKeyValues:dict];
            [tempSubfoods addObject:shopsubfood];
            [shopsubfood bg_saveOrUpdate];
        }
        self.subfoodArray=tempSubfoods;
        //初始化烹饪方式
        [UniHttpTool getwithparameters:nil option:GetShopCookWay success:^(id json) {
            for (NSDictionary*dict in json[@"data"]) {
                ShopCookway*cookway=[ShopCookway mj_objectWithKeyValues:dict];
                [tempCookWays addObject:cookway];
                [cookway bg_saveOrUpdate];
            }
            self.shopCookwayArray=tempCookWays;
            //初始口味
            [UniHttpTool getwithparameters:nil option:GetShopFlavor success:^(id json) {
                for (NSDictionary*dict in json[@"data"]) {
                    ShopFlavor*flavor=[ShopFlavor mj_objectWithKeyValues:dict];
                    [tempflavors addObject:flavor];
                    [flavor bg_saveOrUpdate];
                }
                self.shopFlavorArray=tempflavors;
                [self viewInit];
            }];
        }];
        
    }];
    
   
}
-(void)viewInit{
    
    if (self.showFood.dwCookWayProp) {
        [self setupCookWayView];
    }
    if (self.showFood.dwFlavorProp) {
        UILabel*FlavorL=[[UILabel alloc]init];
        FlavorL.frame=CGRectMake(10, 130, 100, 20);
        FlavorL.text=@"个人口味:";
        FlavorL.font=[UIFont systemFontOfSize:15];
        [self.backgroundView addSubview:FlavorL];
    }
    if (self.showFood.dwSubFoodProp) {
        [self setupSubFood];
    }
}
-(void)setupCookWayView{
    UILabel*cookL=[[UILabel alloc]init];
    cookL.frame=CGRectMake(10, 50, 100, 20);
    cookL.text=@"烹饪方法:";
    cookL.font=[UIFont systemFontOfSize:15];
    [self.backgroundView addSubview:cookL];
    CGRect rect=CGRectZero;
    for (int i=0; i<self.shopCookwayArray.count; i++) {
        ShopCookway*cookway=self.shopCookwayArray[i];
        DLog(@"%@",cookway.szName);
        if ((self.showFood.dwCookWayProp&cookway.dwCWID)==cookway.dwCWID) {
            CGSize textSzie=[cookway.szName sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
            UIButton*propBtn=[[UIButton alloc]initWithFrame:CGRectMake(rect.origin.x+rect.size.width+10, 80, textSzie.width+10, 40)];
            propBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            propBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [propBtn setBackgroundImage:[self imageWithColor:KmainColor] forState:UIControlStateSelected];
            [propBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [propBtn setBackgroundImage:[self imageWithColor:KColor(240, 240, 240)] forState:UIControlStateNormal];
            propBtn.layer.masksToBounds=YES;
            propBtn.layer.cornerRadius=10;
            propBtn.tag=1000+i;
            
            propBtn.titleLabel.font=[UIFont systemFontOfSize:15];
            [self.backgroundView addSubview:propBtn];
            if (rect.origin.x==0) {
                propBtn.selected=YES;
                self.cookWayprop=cookway.dwCWID;
                self.dwCookPrice=cookway.dwUnitPrice;
                [self viewWithSupFlavor:(self.showFood.dwFlavorProp&cookway.dwSupFlavor) withbackgroundView:self.backgroundView];
            }
            rect=propBtn.frame;
            if (cookway.dwUnitPrice>0) {
                NSString*priceStr=[NSString stringWithFormat:@"$%.2f",cookway.dwUnitPrice/100.0];
                [propBtn setTitle:[NSString stringWithFormat:@"%@ %@",cookway.szName,priceStr] forState:UIControlStateNormal];
            }else{
                [propBtn setTitle:cookway.szName forState:UIControlStateNormal];
            }
            
        }
    }
}
-(void)setupSubFood{
    UILabel*SubFoodL=[[UILabel alloc]init];
    SubFoodL.frame=CGRectMake(10, 30, 100, 20);
    SubFoodL.text=@"配菜:";
    SubFoodL.font=[UIFont systemFontOfSize:15];
    [self.backgroundView addSubview:SubFoodL];
    CGRect rect=CGRectZero;
    NSInteger line=0;
    for (int i=0; i<self.subfoodArray.count; i++) {
        ShopSubFood*subfood=self.subfoodArray[i];
        if ((self.showFood.dwSubFoodProp&subfood.dwSFID)==subfood.dwSFID) {
            NSString*str=[subfood.szName stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
            CGSize textSzie=[str sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
            if ((rect.origin.x+rect.size.width+textSzie.width+20)>self.backgroundView.bounds.size.width) {
                line=line+1;
                rect=CGRectZero;
            }
            SubfoodBtn*subfoodBtn=[[SubfoodBtn alloc]initWithFrame:CGRectMake(rect.origin.x+rect.size.width+10, 60+line*50, textSzie.width+20, 35)];
            subfoodBtn.subfood=subfood;
            
            subfoodBtn.subfoodPrice=subfood.dwUnitPrice;
            if ((self.showFood.dwIncSubFood&subfood.dwSFID)==subfood.dwSFID) {
                subfoodBtn.selected=YES;
                subfoodBtn.isDefInc=YES;
                subfoodBtn.defValue=1;
                subfoodBtn.value=1;
            }else{
                subfoodBtn.value=0;
            }
            
            
           
            subfoodBtn.tag=500+i;
            subfoodBtn.delegate=self;
            [self.backgroundView addSubview:subfoodBtn];
            rect=subfoodBtn.frame;
        }
    }
}


-(void)setupBottomWithSupView:(UIView*)supView withShowfood:(ShowFood*)showfood{
    UIView*bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, supView.bounds.size.height-50, supView.bounds.size.width, 50)];
    bottomView.backgroundColor=KColor(240, 240, 240);
    [supView addSubview:bottomView];
    
    UIButton*addbtn=[[UIButton alloc]initWithFrame:CGRectMake(bottomView.bounds.size.width-120, 10, 100, 30)];
    
    [addbtn addTarget:self action:@selector(order:) forControlEvents:UIControlEventTouchUpInside];
    [addbtn setBackgroundColor:KmainColor];
    addbtn.layer.masksToBounds=YES;
    addbtn.titleLabel.font=[UIFont systemFontOfSize:15];
    addbtn.layer.cornerRadius=15;
    self.addBtn=addbtn;
    [bottomView addSubview:addbtn];
    
    UILabel*priceL=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    priceL.textColor=[UIColor redColor];
    self.priceL=priceL;
    self.price=self.showFood.dwSoldPrice;
    self.priceL.text=[NSString stringWithFormat:@"$%.2f",self.price/100.0];
    
    PPNumberButton*ppBtn=[[PPNumberButton alloc]init];
    self.ppBtn=ppBtn;
    self.ppBtn.frame=CGRectMake(bottomView.bounds.size.width-100, 15, 80, 20);
    self.ppBtn.decreaseHide = YES;
    self.ppBtn.shakeAnimation = YES;
    self.ppBtn.minValue=1;
    self.ppBtn.maxValue=10;
    self.ppBtn.currentNumber=self.showFood.orderNum;
    self.ppBtn.increaseImage = [UIImage imageNamed:@"increase"];
    self.ppBtn.decreaseImage = [UIImage imageNamed:@"decrease"];
    self.ppBtn.longPressSpaceTime=CGFLOAT_MAX;
    [bottomView addSubview:self.ppBtn];
    if (self.isPackage) {
        [addbtn setTitle:@"确定" forState:UIControlStateNormal];
    }else{
        if (self.showFood.orderNum) {
            self.addBtn.hidden=YES;
           
        }else{
            self.ppBtn.hidden=YES;
            [addbtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        }
        [bottomView addSubview:priceL];
       
    }
    
}

-(void)order{
    OrderFood*orderfood=[[OrderFood alloc]init];
    if (self.showFood.dwIncSubFood) {
        orderfood.szSelFlavor=@"";
        orderfood.szSelSubFood=[self renturnSelSubFood];
        orderfood.dwShowFoodID=self.showFood.dwShowFoodID;
        orderfood.dwSelCookWay=self.cookWayprop;
        orderfood.dwFoodType=1;
        orderfood.dwParentIndex=0;
        orderfood.dwQuantity=1;
        orderfood.dwFoodPrice=self.showFood.dwSoldPrice;
        orderfood.dwCookPrice=0;
        if (self.priceOffset>0) {
            orderfood.dwSubFoodPrice=self.priceOffset;
        }else{
            orderfood.dwSubFoodPrice=0;
        }
        orderfood.dwFlavorPrice=0;
        orderfood.dwFoodDiscount=0;
        orderfood.dwSubFoodDiscount=0;
        orderfood.szShowFoodName=self.showFood.szDispName;
        orderfood.dwGroupID=self.showFood.dwGroupID;
    }else{
        NSString*szSelFlavor=@"";
        NSInteger flavorprice=0;
        for (FlavorButton*flvBtn in self.backgroundView.subviews) {
            if ([flvBtn isKindOfClass:[FlavorButton class]]) {
                if (flvBtn.value!=flvBtn.shopflavor.dwDefValue) {
                    NSArray*tempArray=[flvBtn.shopflavor.szValueName componentsSeparatedByString:@";"];
                    for (NSString*str in tempArray) {
                        if ([[str substringToIndex:1] integerValue]==flvBtn.value) {
                            szSelFlavor=[szSelFlavor stringByAppendingFormat:@"%@",[str substringFromIndex:2]];
                        }
                    }
                    if (flvBtn.value>0&&flvBtn.shopflavor.dwDefValue==0&&flvBtn.shopflavor.dwUnitPrice>0) {
                        flavorprice=flavorprice+flvBtn.shopflavor.dwUnitPrice;
                    }
                    
                }
            }
        }
        orderfood.szSelFlavor=szSelFlavor;
        orderfood.dwShowFoodID=self.showFood.dwShowFoodID;
        orderfood.dwSelCookWay=self.cookWayprop;
        orderfood.dwFoodType=1;
        orderfood.dwParentIndex=0;
        orderfood.dwQuantity=1;
        orderfood.dwFoodPrice=self.showFood.dwSoldPrice;
        orderfood.dwCookPrice=self.dwCookPrice;
        orderfood.dwSubFoodPrice=0;
        
        orderfood.dwFlavorPrice=flavorprice;
        orderfood.dwFoodDiscount=0;
        orderfood.dwSubFoodDiscount=0;
        orderfood.szShowFoodName=self.showFood.szDispName;
        orderfood.dwGroupID=self.showFood.dwGroupID;
        
    }
    if ([self.delegate respondsToSelector:@selector(ChosenFoodPropViewOrderWithOrderFood:withIndexPath:)]) {
        [self.delegate ChosenFoodPropViewOrderWithOrderFood:orderfood withIndexPath:self.indexPath];
    }
}
//加入购物车
-(void)order:(UIButton*)sender{
    [self order];
    self.ppBtn.hidden=NO;
    DLog(@"%ld",self.showFood.orderNum);
    self.ppBtn.currentNumber=1;
    self.addBtn.hidden=YES;
    self.ppBtn.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus) {
        if (increaseStatus) {
            [self order];
        }
    };
    
}
-(void)handleSingleTap:(id)sender{
    [self removeFromSuperview];
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *touchedView = [super hitTest:point withEvent:event];
    if (touchedView.tag==999) {
        return [[UIView alloc]init];
    }
    
    return touchedView;
}

-(void)delete{
    [self removeFromSuperview];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f); //宽高 1.0只要有值就够了
    UIGraphicsBeginImageContext(rect.size); //在这个范围内开启一段上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);//在这段上下文中获取到颜色UIColor
    CGContextFillRect(context, rect);//用这个颜色填充这个上下文
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//从这段上下文中获取Image属性,,,结束
    UIGraphicsEndImageContext();
    
    return image;
}
-(void)click:(UIButton*)btn{
    if (btn.tag<2000) {
        if (btn.selected) {
            return;
        }else{
            for (int i=1000; i<=1004; i++) {
                UIButton*propbtn=[self.backgroundView viewWithTag:i];
                if (propbtn.selected==YES) {
                    propbtn.selected=NO;
                    break;
                }
            }
            btn.selected=YES;
            for (int j=0; j<self.shopFlavorArray.count; j++) {
                UIButton*btn=[self.backgroundView viewWithTag:j+2000];
                [btn removeFromSuperview];
            }
            for (int i=0; i<self.shopCookwayArray.count; i++) {
                ShopCookway*cookway=self.shopCookwayArray[i];
                if (btn.tag==1000+i) {
                    self.cookWayprop=cookway.dwCWID;
                    self.dwCookPrice=cookway.dwUnitPrice;
                    [self viewWithSupFlavor:(self.showFood.dwFlavorProp&cookway.dwSupFlavor) withbackgroundView:self.backgroundView];
                    self.cookwayPrice=cookway.dwUnitPrice;
                    self.priceL.text=[NSString stringWithFormat:@"$%.2f",(self.showFood.dwSoldPrice+cookway.dwUnitPrice)/100.0];
                    
                   
                    break;
                }
            
            }
            
        }
    }else{
        btn.selected=!btn.selected;
    }
    
}

-(void)viewWithSupFlavor:(NSInteger)FlavorProp withbackgroundView:(UIView*)view{
    CGRect rect=CGRectZero;
    NSInteger line=0;
    for (int i=0; i<self.shopFlavorArray.count; i++) {
        ShopFlavor*shopflavor=self.shopFlavorArray[i];
        if ((FlavorProp&shopflavor.dwFVID)==shopflavor.dwFVID) {
            CGSize textSzie=[shopflavor.szName sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
            FlavorButton*propBtn=[[FlavorButton alloc]init];
            propBtn.delegate=self;
            if ((rect.origin.x+rect.size.width+textSzie.width+20)>view.bounds.size.width) {
                rect=CGRectZero;
                line=line+1;
            }
            propBtn.tag=2000+i;
            propBtn.frame =CGRectMake(rect.origin.x+rect.size.width+10, 160+line*60,textSzie.width+10, 50);
            propBtn.layer.masksToBounds=YES;
            propBtn.layer.cornerRadius=10;
            propBtn.shopflavor=shopflavor;
            [view addSubview:propBtn];
            rect=propBtn.frame;
        }
       
       
    }
}

-(NSInteger)returnTotalPrice:(NSInteger)incSubfood{
    NSArray*subfoodArray=[ShopSubFood bg_findAll:nil];
    NSInteger subPrice=0;
    for (int i=0; i<subfoodArray.count;i++) {
        ShopSubFood*subfood=subfoodArray[i];
        if ((incSubfood&subfood.dwSFID)==subfood.dwSFID) {
            subPrice=subPrice+subfood.dwUnitPrice;
        }
    }
    return subPrice;
}

-(NSString*)renturnSelSubFood{
    NSString*SelSubFood=@"";
    for (SubfoodBtn*btnView in self.backgroundView.subviews) {
        if ([btnView isKindOfClass:[SubfoodBtn class]]) {
            if (btnView.subfood.dwUnitPrice>0) {
                if (btnView.value!=btnView.defValue) {
                    NSString*str=[btnView.subfood.szValueName stringByReplacingOccurrencesOfString:@" " withString:@""];
                    str=[str stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
                    NSArray*tempArray=[str componentsSeparatedByString:@";"];
                    for (NSString*str in tempArray) {
                        if ([[str substringToIndex:1] integerValue]==btnView.value) {
                            SelSubFood=[SelSubFood stringByAppendingFormat:@"%@",[str substringFromIndex:2]];
                        }
                    }
                }
            }
        }
    }
    return SelSubFood;
}
#pragma mark delegate
-(void)SubfoodBtnClick:(SubfoodBtn *)button{
    NSInteger offset=0;
    for (SubfoodBtn*btnView in self.backgroundView.subviews) {
        if ([btnView isKindOfClass:[SubfoodBtn class]]) {
            if (btnView.subfood.dwUnitPrice>0) {
                if (btnView.value!=btnView.defValue) {
                    offset=offset+(btnView.value-btnView.defValue)*btnView.subfood.dwUnitPrice;
                }
            }
        }
    }
    self.priceOffset=offset;
    self.price=self.showFood.dwSoldPrice+offset;
    if (self.price<self.showFood.dwMinPrice) {
        self.price=self.showFood.dwMinPrice;
        self.priceL.text=[NSString stringWithFormat:@"$%.2f",self.showFood.dwMinPrice/100.0];
    }else{
        self.priceL.text=[NSString stringWithFormat:@"$%.2f",(self.showFood.dwSoldPrice+offset)/100.0];
    }
}

-(void)FlavorButtonClick:(FlavorButton *)button{
    NSInteger offset=0;
    for (FlavorButton*btnView in self.backgroundView.subviews) {
        if ([btnView isKindOfClass:[FlavorButton class]]) {
            if (btnView.shopflavor.dwUnitPrice>0) {
                if (btnView.value>btnView.shopflavor.dwDefValue) {
                    offset=offset+btnView.shopflavor.dwUnitPrice;
                }else{
                    offset=offset-btnView.shopflavor.dwUnitPrice;
                }
            }
        }
    }
    if (offset>0) {
        self.priceL.text=[NSString stringWithFormat:@"$%.2f",(self.showFood.dwSoldPrice+offset+self.cookwayPrice)/100.0];
    }else{
         self.priceL.text=[NSString stringWithFormat:@"$%.2f",(self.showFood.dwSoldPrice+self.cookwayPrice)/100.0];
    }
}
-(NSArray *)shopFlavorArray{
    if (!_shopFlavorArray) {
        _shopFlavorArray=[NSArray array];
    }
    return _shopFlavorArray;
}
-(NSArray *)shopCookwayArray{
    if (!_shopCookwayArray) {
        _shopCookwayArray=[NSArray array];
    }
    return _shopCookwayArray;
}
-(NSArray *)subfoodArray{
    if (!_subfoodArray) {
        _subfoodArray=[NSArray array];
    }
    return _subfoodArray;
}
@end
