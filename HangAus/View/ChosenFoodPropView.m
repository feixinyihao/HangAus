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
#import "DataBase.h"
#import "ShopSubFood.h"
#import "OrderFood.h"
#import "FlavorButton.h"
#import "ChosenFood.h"
@interface ChosenFoodPropView()
@property(nonatomic,strong)ShowFood*showFood;
@property(nonatomic,weak)UIView*backgroundView;
@property(nonatomic,strong)NSArray*shopFlavorArray;
@property(nonatomic,strong)NSArray*shopCookwayArray;

@property(nonatomic,assign)NSInteger dwSelCookWay;
@property(nonatomic,copy)NSString*szSelSubFood;
@property(nonatomic,copy)NSString*szSelFlavor;

@property(nonatomic,weak)UILabel*priceL;

@property(nonatomic,assign)NSInteger cookWayprop;

@property(nonatomic,assign)NSInteger dwCookPrice;
@end
@implementation ChosenFoodPropView

-(instancetype)initWithShowFood:(ShowFood*)showfood withFlavorArray:(NSArray *)FlavorArray withCookwayArray:(NSArray *)cookwayArray{
    if ([super init]) {
        self.showFood=showfood;
        self.shopCookwayArray=cookwayArray;
        self.shopFlavorArray=FlavorArray;
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
        nameL.text=showfood.szDispName;
        [backgroundView addSubview:nameL];
        
        UIButton*delBtn=[[UIButton alloc]initWithFrame:CGRectMake(backgroundView.bounds.size.width-25, 0, 25, 25)];
        [delBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:delBtn];
        [self setupBottomWithSupView:backgroundView withShowfood:showfood];
        
        if (showfood.dwCookWayProp) {
            DLog(@"%ld",showfood.dwCookWayProp);
            UILabel*cookL=[[UILabel alloc]init];
            cookL.frame=CGRectMake(10, 50, 100, 20);
            cookL.text=@"烹饪方法:";
            cookL.font=[UIFont systemFontOfSize:15];
            [backgroundView addSubview:cookL];
            CGRect rect=CGRectZero;
            
            for (int i=0; i<self.shopCookwayArray.count; i++) {
                ShopCookway*cookway=self.shopCookwayArray[i];
                DLog(@"%@",cookway.szName);
                if ((showfood.dwCookWayProp&cookway.dwCWID)==cookway.dwCWID) {
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
                    [backgroundView addSubview:propBtn];
                    if (rect.origin.x==0) {
                        propBtn.selected=YES;
                        self.cookWayprop=cookway.dwCWID;
                        self.dwCookPrice=cookway.dwUnitPrice;
                        [self viewWithSupFlavor:(showfood.dwFlavorProp&cookway.dwSupFlavor) withbackgroundView:backgroundView];
                        self.priceL.text=[NSString stringWithFormat:@"$%.1f0",([self returnPriceFromShowFood:self.showFood isDiscount:YES]+cookway.dwUnitPrice)/100.0];
                        
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
        if (showfood.dwFlavorProp) {
            UILabel*FlavorL=[[UILabel alloc]init];
            FlavorL.frame=CGRectMake(10, 130, 100, 20);
            FlavorL.text=@"个人口味:";
            FlavorL.font=[UIFont systemFontOfSize:15];
            [backgroundView addSubview:FlavorL];
        }
        if (showfood.dwSubFoodProp) {
            UILabel*SubFoodL=[[UILabel alloc]init];
            SubFoodL.frame=CGRectMake(10, 50, 100, 20);
            SubFoodL.text=@"配菜:";
            SubFoodL.font=[UIFont systemFontOfSize:15];
            [backgroundView addSubview:SubFoodL];
            
            NSMutableArray*subfoodArray=[[DataBase sharedDataBase]getAllShopSubFood];
            CGRect rect=CGRectZero;
            NSInteger line=0;
            for (int i=0; i<subfoodArray.count; i++) {
                ShopSubFood*subfood=subfoodArray[i];
                if ((self.showFood.dwSubFoodProp&subfood.dwSFID)==subfood.dwSFID) {
                    CGSize textSzie=[subfood.szName sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
                    if ((rect.origin.x+rect.size.width+textSzie.width+20)>backgroundView.bounds.size.width) {
                        line=line+1;
                        rect=CGRectZero;
                    }
                    
                    UIButton*subfoodBtn=[[UIButton alloc]initWithFrame:CGRectMake(rect.origin.x+rect.size.width+10, 80+line*60, textSzie.width+10, 40)];
                    [subfoodBtn setTitle:subfood.szName forState:UIControlStateNormal];
                    [subfoodBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                    [subfoodBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];;
                    [subfoodBtn setBackgroundImage:[self imageWithColor:KmainColor] forState:UIControlStateSelected];
                     [subfoodBtn setBackgroundImage:[self imageWithColor:[UIColor yellowColor]] forState:UIControlStateNormal];
                    subfoodBtn.layer.masksToBounds=YES;
                    subfoodBtn.layer.cornerRadius=5;
                    subfoodBtn.titleLabel.font=[UIFont systemFontOfSize:15];
                    if ((self.showFood.dwIncSubFood&subfood.dwSFID)==subfood.dwSFID) {
                        subfoodBtn.selected=YES;
                    }
                    [backgroundView addSubview:subfoodBtn];
                    rect=subfoodBtn.frame;
                }
            }
        }
    }
    return self;
}

-(void)setupBottomWithSupView:(UIView*)supView withShowfood:(ShowFood*)showfood{
    UIView*bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, supView.bounds.size.height-50, supView.bounds.size.width, 50)];
    bottomView.backgroundColor=KColor(240, 240, 240);
    [supView addSubview:bottomView];
    
    UIButton*addbtn=[[UIButton alloc]initWithFrame:CGRectMake(bottomView.bounds.size.width-120, 10, 100, 30)];
    [addbtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addbtn addTarget:self action:@selector(order:) forControlEvents:UIControlEventTouchUpInside];
    [addbtn setBackgroundColor:KmainColor];
    addbtn.layer.masksToBounds=YES;
    addbtn.titleLabel.font=[UIFont systemFontOfSize:15];
    addbtn.layer.cornerRadius=15;
    [bottomView addSubview:addbtn];
    
    UILabel*priceL=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    priceL.textColor=[UIColor redColor];
    self.priceL=priceL;
    [bottomView addSubview:priceL];
}
//加入购物车
-(void)order:(UIButton*)sender{
    OrderFood*orderfood=[[OrderFood alloc]init];
    if (self.showFood.dwIncSubFood) {
        
    }else{
        NSString*szSelFlavor=@"";
        for (int i=2000; i<self.shopFlavorArray.count+2000; i++) {
            FlavorButton*button=[self.backgroundView viewWithTag:i];
            if (button) {
                if (button.value!=button.shopflavor.dwDefValue) {
                    NSArray*tempArray=[button.shopflavor.szValueName componentsSeparatedByString:@";"];
                    for (NSString*str in tempArray) {
                        if ([[str substringToIndex:1] integerValue]==button.value) {
                            szSelFlavor=[szSelFlavor stringByAppendingFormat:@"%@;",[str substringFromIndex:2]];
                        }
                    }
                    
                }
            }
            
        }
        if (szSelFlavor.length>1) {
            szSelFlavor=[szSelFlavor substringToIndex:szSelFlavor.length-1];
        }
        DLog(@"%@",szSelFlavor);
        orderfood.szSelFlavor=szSelFlavor;
        orderfood.dwShowFoodID=self.showFood.dwShowFoodID;
        orderfood.dwSelCookWay=self.cookWayprop;
        orderfood.dwFoodType=1;
        orderfood.dwParentIndex=0;
        orderfood.dwQuantity=1;
        orderfood.dwFoodPrice=[self returnPriceFromShowFood:self.showFood isDiscount:YES];
        orderfood.dwCookPrice=self.dwCookPrice;
        orderfood.dwSubFoodPrice=0;
        //口味价格先不考虑
        orderfood.dwFlavorPrice=0;
        orderfood.dwFoodDiscount=0;
        orderfood.dwSubFoodDiscount=0;
        
    }
    if ([self.delegate respondsToSelector:@selector(ChosenFoodPropViewOrderWithOrderFood:)]) {
        [self.delegate ChosenFoodPropViewOrderWithOrderFood:orderfood];
    }
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
                 
                    self.priceL.text=[NSString stringWithFormat:@"$%.1f0",([self returnPriceFromShowFood:self.showFood isDiscount:YES]+cookway.dwUnitPrice)/100.0];
                    
                   
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
//返回食物价格
-(NSInteger)returnPriceFromShowFood:(ShowFood*)showfood isDiscount:(BOOL)discount{
    //论重量卖
    if (showfood.dwSoldProp==2) {
        if (showfood.dwDefQuantity==0) {
            return discount?showfood.dwUnitPrice-showfood.dwDiscount: showfood.dwUnitPrice;
        }else{
            return discount?roundf(showfood.dwUnitPrice*showfood.dwDefQuantity/1000.0-showfood.dwDiscount):roundf(showfood.dwUnitPrice*showfood.dwDefQuantity/1000.0);
        }
        //套餐
    }else if (showfood.dwShowProp==2){
        NSInteger total=0;
        for (int i=0; i<showfood.ChosenFoods.count; i++) {
            ChosenFood*chosenfood=showfood.ChosenFoods[i];
            ShowFood*chosenShowfood=[[DataBase sharedDataBase]getShowFoodWithID:chosenfood.dwShowFoodID];
            if (chosenShowfood.dwSoldProp==2) {
                chosenShowfood.dwDefQuantity=chosenfood.dwQuantity;
                total=total+[self returnPriceFromShowFood:chosenShowfood isDiscount:NO];
            }else{
                total=total+[self returnPriceFromShowFood:chosenShowfood isDiscount:NO]*chosenfood.dwQuantity;
            }
        }
        return discount?total-showfood.dwDiscount:total;
        //食物包含配料
    }else if (showfood.dwIncSubFood){
        return discount?[self returnTotalPrice:showfood.dwIncSubFood]+showfood.dwUnitPrice-showfood.dwDiscount:[self returnTotalPrice:showfood.dwIncSubFood]+showfood.dwUnitPrice;
    }else{
        return discount?showfood.dwUnitPrice-showfood.dwDiscount:showfood.dwUnitPrice;
    }
}
-(NSInteger)returnTotalPrice:(NSInteger)incSubfood{
    NSArray*subfoodArray=[[DataBase sharedDataBase]getAllShopSubFood];
    NSInteger subPrice=0;
    for (int i=0; i<subfoodArray.count;i++) {
        ShopSubFood*subfood=subfoodArray[i];
        if ((incSubfood&subfood.dwSFID)==subfood.dwSFID) {
            subPrice=subPrice+subfood.dwUnitPrice;
        }
    }
    return subPrice;
}
@end
