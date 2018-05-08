//
//  ChosenFlavorView.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/28.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "ChosenFlavorView.h"
#import "ShowFood.h"
#import "ShopCookway.h"
#import "ShopFlavor.h"
#import "FlavorButton.h"
#import "OrderFood.h"
#import <PPNumberButton.h>
@interface ChosenFlavorView()<FlavorButtonDelegate>
@property(nonatomic,strong)ShowFood*showfood;
@property(nonatomic,weak)UIView*bottomView;
@property(nonatomic,weak)UILabel*priceL;
@property(nonatomic,weak)UIButton*cartBtn;
@property(nonatomic,weak)PPNumberButton*ppBtn;

/**
 当前选择的食物
 */
@property(nonatomic,strong)OrderFood*currentOrderfood;
@end

@implementation ChosenFlavorView


-(instancetype)initWithFrame:(CGRect)frame withShowfood:(ShowFood*)showfood{
    if ([super initWithFrame:frame]) {
        if (self) {
            self.showfood=showfood;
        }
    }
    return self;
}
-(void)setShopCookWay:(NSArray *)shopCookWay{
    _shopCookWay=shopCookWay;
    UILabel*cookL=[[UILabel alloc]init];
    cookL.frame=CGRectMake(10, 0, self.bounds.size.width, 20);
    //烹饪方法
    cookL.text=KLocalizedString(@"6000007");
    cookL.font=[UIFont systemFontOfSize:15];
    [self addSubview:cookL];
    
    
    CGRect rect=CGRectZero;
    for (int i=0; i<self.shopCookWay.count; i++) {
        ShopCookway*cookway=self.shopCookWay[i];
        if ((self.showfood.dwCookWayProp&cookway.dwCWID)==cookway.dwCWID) {
            CGSize textSzie=[cookway.szShowName sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
            UIButton*cookWayBtn=[[UIButton alloc]initWithFrame:CGRectMake(rect.origin.x+rect.size.width+10, 30, textSzie.width+10, 40)];
            cookWayBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cookWayBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [cookWayBtn setBackgroundImage:[CommonFunc imageWithColor:[UIColor orangeColor]] forState:UIControlStateSelected];
            [cookWayBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [cookWayBtn setBackgroundImage:[CommonFunc imageWithColor:KColor(240, 240, 240)] forState:UIControlStateNormal];
            cookWayBtn.layer.masksToBounds=YES;
            cookWayBtn.layer.cornerRadius=10;
            cookWayBtn.tag=1000+i;
            if (rect.origin.x==0) {
                cookWayBtn.selected=YES;
            }
            cookWayBtn.titleLabel.font=[UIFont systemFontOfSize:15];
            [self addSubview:cookWayBtn];
            
            rect=cookWayBtn.frame;
            if (cookway.dwUnitPrice>0) {
                NSString*priceStr=[NSString stringWithFormat:@"$%.2f",cookway.dwUnitPrice/100.0];
                [cookWayBtn setTitle:[NSString stringWithFormat:@"%@ %@",cookway.szShowName,priceStr] forState:UIControlStateNormal];
            }else{
                [cookWayBtn setTitle:cookway.szShowName forState:UIControlStateNormal];
            }
            
        }
    }
    
}
//点击烹饪方式
-(void)click:(UIButton*)sender{
    if (sender.selected)return;
    for (int i=0; i<6; i++) {
        UIButton*btn=[self viewWithTag:1000+i];
        btn.selected=NO;
    }
    sender.selected=YES;
    ShopCookway*shopCookway=self.shopCookWay[sender.tag-1000];
    for (UIView*view in self.subviews) {
        if (view.tag>=2000) {
            [view removeFromSuperview];
        }
    }
    [self setupFlavorButtonWithCookWayProp:self.showfood.dwFlavorProp&shopCookway.dwSupFlavor];
    
    [self updatePrice];
    if (self.showfood.orderNum) {
        for (OrderFood*orderfood in self.orderfoods) {
            if ((orderfood.dwShowFoodID==self.showfood.dwShowFoodID)&&
                (orderfood.dwSelCookWay==shopCookway.dwCWID)&&
                [orderfood.szSelFlavor isEqualToString:@""]) {
                self.ppBtn.hidden=NO;
                self.ppBtn.currentNumber=orderfood.dwQuantity;
                self.cartBtn.hidden=YES;
                //当前选中
                self.currentOrderfood=orderfood;
                return;
            }
            self.ppBtn.hidden=YES;
            self.cartBtn.hidden=NO;
        }
    }
}
-(void)setShopFlavor:(NSArray *)shopFlavor{
    _shopFlavor=shopFlavor;
    UILabel*FlavorL=[[UILabel alloc]init];
    FlavorL.frame=CGRectMake(10, 80, self.bounds.size.width, 20);
    //个人口味
    FlavorL.text= KLocalizedString(@"6000008");
    FlavorL.font=[UIFont systemFontOfSize:15];
    [self addSubview:FlavorL];
    
    ShopCookway*shopCookway=[[ShopCookway alloc]init];
    for (int i=0; i<6; i++) {
        UIButton*btn=[self viewWithTag:1000+i];
        if (btn.selected) {
            shopCookway=self.shopCookWay[i];
            break;
        }
       
    }
    [self setupFlavorButtonWithCookWayProp:self.showfood.dwFlavorProp&shopCookway.dwSupFlavor];
    self.isPackage?[self setupPackageBottonView]:[self setupBottonView];
    

}
-(void)setOrderfoods:(NSMutableArray *)orderfoods{
    _orderfoods=orderfoods;
    if (self.showfood.orderNum) {
        for (OrderFood*orderfood in orderfoods) {
            if (orderfood.dwShowFoodID==self.showfood.dwShowFoodID) {
                self.ppBtn.currentNumber=orderfood.dwQuantity;
                self.currentOrderfood=orderfood;
                //设置按钮的值为已经加入购物车的值
                for (int i=0;i<self.shopCookWay.count;i++) {
                    ShopCookway*cookWay=self.shopCookWay[i];
                    if (cookWay.dwCWID==orderfood.dwSelCookWay) {
                        for (int j=0; j<6; j++) {
                            UIButton*btn=[self viewWithTag:j+1000];
                            if (j==i) {
                                [self click:btn];
                                for (FlavorButton*flvBtn in self.subviews) {
                                    if ([flvBtn isKindOfClass:[FlavorButton class]]) {
                                        NSArray*tempFlavorArray=[orderfood.szSelFlavorArrayStr componentsSeparatedByString:@";"];
                                        for (NSString*str in tempFlavorArray) {
                                            NSArray*temp=[str componentsSeparatedByString:@":"];
                                            if ([temp[0] integerValue]==flvBtn.shopflavor.dwFVID) {
                                                flvBtn.value=[temp[1] integerValue];
                                            }
                                        }
                                    }
                                }
                                break;
                            }
                            
                        }
                        
                        break;
                    }
                }
                self.ppBtn.hidden=NO;
                self.ppBtn.currentNumber=orderfood.dwQuantity;
                self.cartBtn.hidden=YES;
                [self updatePrice];
                break;
            }
        }
    }
}

//更新价格
-(void)updatePrice{
    ShopCookway*shopCookway=[[ShopCookway alloc]init];
    for (int i=0; i<6; i++) {
        UIButton*btn=[self viewWithTag:1000+i];
        if (btn.selected) {
            shopCookway=self.shopCookWay[i];
            break;
        }
    }
    self.priceL.text=[NSString stringWithFormat:@"$%.2f",([self returnFlavorPrice]+shopCookway.dwUnitPrice+self.showfood.dwSoldPrice)/100.0];
}
-(void)setupFlavorButtonWithCookWayProp:(NSInteger)prop{
    CGRect rect=CGRectZero;
    NSInteger line=0;
    for (int i=0; i<self.shopFlavor.count; i++) {
        ShopFlavor*shopflavor=self.shopFlavor[i];
        if ((prop&shopflavor.dwFVID)==shopflavor.dwFVID) {
            CGSize textSzie=[shopflavor.szName sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
            FlavorButton*propBtn=[[FlavorButton alloc]init];
            propBtn.delegate=self;
            if ((rect.origin.x+rect.size.width+textSzie.width+20)>self.bounds.size.width) {
                rect=CGRectZero;
                line=line+1;
            }
            propBtn.tag=2000+i;
            propBtn.frame =CGRectMake(rect.origin.x+rect.size.width+10, 110+line*60,textSzie.width+10, 50);
            propBtn.layer.masksToBounds=YES;
            propBtn.layer.cornerRadius=10;
            propBtn.shopflavor=shopflavor;
            [self addSubview:propBtn];
            rect=propBtn.frame;
        }
    }
    CGFloat H=rect.origin.y+rect.size.height+100;
    self.superview.frame=CGRectMake(self.superview.frame.origin.x, (kScreenH-H)/2, self.superview.bounds.size.width, H);
    self.bottomView.frame=CGRectMake(0, self.superview.bounds.size.height-40, self.bounds.size.width, 40);
    
   
}
//如果是套餐里的食物选择口味
-(void)setupPackageBottonView{
    UIView* bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.superview.bounds.size.height-40, self.bounds.size.width, 40)];
    self.bottomView=bottomView;
    bottomView.backgroundColor=KColor(240, 240, 240);
    //加入购物车
    UIButton*addbtn=[[UIButton alloc]initWithFrame:CGRectMake(self.bottomView.bounds.size.width-110, 7, 100, 26)];
    [addbtn addTarget:self action:@selector(order:) forControlEvents:UIControlEventTouchUpInside];
    [addbtn setBackgroundColor:KmainColor];
    addbtn.layer.masksToBounds=YES;
    self.cartBtn=addbtn;
    [addbtn setTitle:@"确定" forState:UIControlStateNormal];
    addbtn.titleLabel.font=[UIFont systemFontOfSize:15];
    addbtn.layer.cornerRadius=13;
    [bottomView addSubview:addbtn];
    [self.superview addSubview:bottomView];
}
-(void)setupBottonView{
    UIView* bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.superview.bounds.size.height-40, self.bounds.size.width, 40)];
    bottomView.backgroundColor=KColor(240, 240, 240);
    self.bottomView=bottomView;
    
    UILabel*priceL=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 40)];
    priceL.textColor=[UIColor redColor];
    priceL.font=[UIFont systemFontOfSize:18];
    [self.bottomView addSubview:priceL];
    priceL.text=[NSString stringWithFormat:@"$%.2f",self.showfood.dwSoldPrice/100.0];
    self.priceL=priceL;
    
    UIButton*addbtn=[[UIButton alloc]initWithFrame:CGRectMake(self.bottomView.bounds.size.width-110, 7, 100, 26)];
    self.cartBtn=addbtn;
    [addbtn addTarget:self action:@selector(order:) forControlEvents:UIControlEventTouchUpInside];
    [addbtn setBackgroundColor:KmainColor];
    addbtn.layer.masksToBounds=YES;
    //加入购物车
    [addbtn setTitle:KLocalizedString(@"6000006") forState:UIControlStateNormal];
    addbtn.titleLabel.font=[UIFont systemFontOfSize:15];
    addbtn.layer.cornerRadius=13;
    [self.bottomView addSubview:addbtn];
    [self.superview addSubview:self.bottomView];
    
    PPNumberButton*ppBtn=[[PPNumberButton alloc]init];
    self.ppBtn=ppBtn;
    self.ppBtn.frame=CGRectMake(self.bounds.size.width-100, 10, 80, 20);
    self.ppBtn.decreaseHide = YES;
    self.ppBtn.shakeAnimation = YES;
    self.ppBtn.editing=NO;
    self.ppBtn.minValue=1;
    self.ppBtn.maxValue=10;
    self.ppBtn.increaseImage = [UIImage imageNamed:@"increase"];
    self.ppBtn.decreaseImage = [UIImage imageNamed:@"decrease"];
    self.ppBtn.longPressSpaceTime=CGFLOAT_MAX;
    [self.bottomView addSubview:self.ppBtn];
    self.ppBtn.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus) {
        
        if (number==0) {
            self.cartBtn.hidden=NO;
            self.ppBtn.hidden=YES;
        }
        increaseStatus?(self.showfood.orderNum=self.showfood.orderNum+1):(self.showfood.orderNum=self.showfood.orderNum-1);
        self.currentOrderfood.dwQuantity=number;
        if ([self.delegate respondsToSelector:@selector(ChosenFlavorViewFinish:withView:withTag:)]) {
            [self.delegate ChosenFlavorViewFinish:self.currentOrderfood withView:self.cartBtn withTag:increaseStatus];
        }
    };
    [self.bottomView addSubview:self.ppBtn];

    self.ppBtn.hidden=!self.showfood.orderNum;
    self.cartBtn.hidden=self.showfood.orderNum;
    
}
//点击加入购物车
-(void)order:(UIButton*)sender{
    ShopCookway*shopCookway=[[ShopCookway alloc]init];
    for (int i=0; i<6; i++) {
        UIButton*btn=[self viewWithTag:1000+i];
        if (btn.selected) {
            shopCookway=self.shopCookWay[i];
            break;
        }
    }
    
    OrderFood*orderfood=[[OrderFood alloc]init];
    orderfood.szSelFlavor=[self returnSelFlavorStr];
    orderfood.szSelFlavorArrayStr=[self returnSelFlavorArrayStr];
    orderfood.szSelSubFood=@"";
    orderfood.dwShowFoodID=self.showfood.dwShowFoodID;
    orderfood.dwSelCookWay=shopCookway.dwCWID;
    orderfood.szSelCookWay=shopCookway.szShowName;
    orderfood.dwFoodType=1;
    orderfood.dwParentIndex=0;
    orderfood.dwQuantity=1;
    orderfood.dwFoodPrice=self.showfood.dwSoldPrice;
    orderfood.dwCookPrice=shopCookway.dwUnitPrice;
    orderfood.dwSubFoodPrice=0;
    orderfood.dwFlavorPrice=[self returnFlavorPrice];
    orderfood.dwFoodDiscount=0;
    orderfood.dwSubFoodDiscount=0;
    orderfood.szShowFoodName=self.showfood.szDispName;
    orderfood.dwGroupID=self.showfood.dwGroupID;
    if ([self.delegate respondsToSelector:@selector(ChosenFlavorViewFinish:withView:withTag:)]) {
        [self.delegate ChosenFlavorViewFinish:orderfood withView:self.cartBtn withTag:-1];
    }
    if (!self.isPackage) {
        self.ppBtn.currentNumber=1;
        self.ppBtn.hidden=NO;
        self.cartBtn.hidden=YES;
    }
    self.currentOrderfood=orderfood;
}
//返回口味价格
-(NSInteger)returnFlavorPrice{
    NSInteger flavorPrice=0;
    for (FlavorButton *flvBtn in self.subviews) {
        if ([flvBtn isKindOfClass:[FlavorButton class]]) {
            if (flvBtn.value>0&&flvBtn.shopflavor.dwDefValue==0&&flvBtn.shopflavor.dwUnitPrice>0) {
                flavorPrice=flavorPrice+flvBtn.shopflavor.dwUnitPrice;
            }
        }
    }
    return flavorPrice;
}
-(NSString*)returnSelFlavorStr{
    NSString*szSelFlavor=@"";
    for (FlavorButton*flvBtn in self.subviews) {
        if ([flvBtn isKindOfClass:[FlavorButton class]]) {
            if (flvBtn.value!=flvBtn.shopflavor.dwDefValue) {
                NSArray*tempArray=[flvBtn.shopflavor.szValueName componentsSeparatedByString:@";"];
                for (NSString*str in tempArray) {
                    if ([[str substringToIndex:1] integerValue]==flvBtn.value) {
                        szSelFlavor=[szSelFlavor stringByAppendingFormat:@"%@",[str substringFromIndex:2]];
                    }
                }
            }
        }
    }
    return szSelFlavor;
}

-(NSString*)returnSelFlavorArrayStr{
    NSString*szSelFlavor=@"";
    for (FlavorButton*flvBtn in self.subviews) {
        if ([flvBtn isKindOfClass:[FlavorButton class]]) {
            if (flvBtn.value!=flvBtn.shopflavor.dwDefValue) {
                szSelFlavor=[szSelFlavor stringByAppendingFormat:@"%ld:%ld;",flvBtn.shopflavor.dwFVID,flvBtn.value];
            }
        }
    }
    if (szSelFlavor.length>0) {
        return [szSelFlavor substringToIndex:szSelFlavor.length-1];
    }
    return szSelFlavor;
}
//点击口味按钮
-(void)FlavorButtonClick:(FlavorButton *)button{
    ShopCookway*shopCookway=[[ShopCookway alloc]init];
    for (int i=0; i<6; i++) {
        UIButton*btn=[self viewWithTag:1000+i];
        if (btn.selected) {
            shopCookway=self.shopCookWay[i];
            break;
        }
    }
    [self updatePrice];
    if (self.showfood.orderNum) {
        for (OrderFood*orderfood in self.orderfoods) {
            if (orderfood.dwShowFoodID==self.showfood.dwShowFoodID&&
                orderfood.dwSelCookWay==shopCookway.dwCWID&&
                [orderfood.szSelFlavor isEqualToString:[self returnSelFlavorStr]]) {
                self.ppBtn.hidden=NO;
                self.ppBtn.currentNumber=orderfood.dwQuantity;
                self.cartBtn.hidden=YES;
                self.currentOrderfood=orderfood;
                return;
            }
        }
        self.ppBtn.hidden=YES;
        self.cartBtn.hidden=NO;
    }
    
}
@end
