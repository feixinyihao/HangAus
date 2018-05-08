//
//  ChosenSubfoodView.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/28.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "ChosenSubfoodView.h"
#import "SubfoodBtn.h"
#import "ShopSubFood.h"
#import "ShowFood.h"
#import <PPNumberButton.h>
#import "OrderFood.h"
@interface ChosenSubfoodView()<SubfoodBtnDelegate>
@property(nonatomic,strong)ShowFood*showfood;
@property(nonatomic,weak)PPNumberButton*ppBtn;
@property(nonatomic,weak)UIButton*cartBtn;
@property(nonatomic,weak)UILabel*priceL;

@property(nonatomic,assign)NSInteger priceOffset;

@property(nonatomic,strong)UIView*bottomView;

@property(nonatomic,strong)NSMutableArray*statusArray;

/**
 当前选择的食物
 */
@property(nonatomic,strong)OrderFood*currentOrderfood;

@end

@implementation ChosenSubfoodView

-(instancetype)initWithFrame:(CGRect)frame withShowFood:(ShowFood *)showfood{
    if ([super initWithFrame:frame]) {
        if (self) {
            self.showfood=showfood;
        }
    }
    return self;
}
-(void)setShopSubfoods:(NSArray *)shopSubfoods{
    _shopSubfoods=shopSubfoods;
    
    if (!self.showfood.orderNum) {
        [self setupFirstBuyUI];
        [self setupBottomUI];
    }
   
    
   
}
-(void)setOrderfoods:(NSMutableArray *)orderfoods{
    _orderfoods=orderfoods;
   
    if (self.showfood.orderNum) {
        [self setupRepertBugUI];
    }
    
   
}
-(void)setupRepertBugUI{
    CGRect rect=CGRectZero;
    NSInteger line=0;
    NSInteger quantity=0;
    for (int i=0; i<self.orderfoods.count; i++) {
        OrderFood*orderfood=self.orderfoods[i];
        if (orderfood.dwShowFoodID==self.showfood.dwShowFoodID) {
            for (int j=0; j<self.shopSubfoods.count; j++) {
                ShopSubFood*subfood=self.shopSubfoods[j];
                if ((self.showfood.dwSubFoodProp&subfood.dwSFID)==subfood.dwSFID) {
                    NSString*str=[subfood.szName stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
                    CGSize textSzie=[str sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
                    if ((rect.origin.x+rect.size.width+textSzie.width+30)>self.bounds.size.width) {
                        line=line+1;
                        rect=CGRectZero;
                    }
                    SubfoodBtn*subfoodBtn=[[SubfoodBtn alloc]initWithFrame:CGRectMake(rect.origin.x+rect.size.width+10, 30+line*50, textSzie.width+20, 35)];
                    subfoodBtn.subfood=subfood;
                    
                    subfoodBtn.subfoodPrice=subfood.dwUnitPrice;
                    subfoodBtn.value=0;
                    if ((self.showfood.dwIncSubFood&subfood.dwSFID)==subfood.dwSFID) {
                        subfoodBtn.selected=YES;
                        subfoodBtn.isDefInc=YES;
                        subfoodBtn.defValue=1;
                        subfoodBtn.value=1;
                    }
                   
                    subfoodBtn.tag=500+j;
                    subfoodBtn.delegate=self;
                    [self addSubview:subfoodBtn];
                    rect=subfoodBtn.frame;
                    //更改按钮的值为订单选择的值
                    NSArray*selsubfoodStrArray=[orderfood.szSelSubFoodArrayStr componentsSeparatedByString:@";"];
                    for (NSString*str in selsubfoodStrArray) {
                        NSArray*temp=[str componentsSeparatedByString:@":"];
                        if ([temp[0] integerValue]==subfood.dwSFID) {
                            subfoodBtn.value=[temp[1] integerValue];
                        }
                    }
                }
            }
           
            quantity=orderfood.dwQuantity;
            self.currentOrderfood=orderfood;
            break;
        }
        
    }
    CGFloat H=rect.origin.y+rect.size.height+100;
    self.superview.frame=CGRectMake(self.superview.frame.origin.x, (kScreenH-H)/2, self.superview.bounds.size.width, H);
    [self setupBottomUI];
    DLog(@"%ld",quantity);
    self.ppBtn.currentNumber=quantity;
    [self setupRepartPrice];
}
-(void)setupFirstBuyUI{
    CGRect rect=CGRectZero;
    NSInteger line=0;
    for (int i=0; i<self.shopSubfoods.count; i++) {
        ShopSubFood*subfood=self.shopSubfoods[i];
        if ((self.showfood.dwSubFoodProp&subfood.dwSFID)==subfood.dwSFID) {
            NSString*str=[subfood.szName stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
            CGSize textSzie=[str sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
            if ((rect.origin.x+rect.size.width+textSzie.width+30)>self.bounds.size.width) {
                line=line+1;
                rect=CGRectZero;
            }
            SubfoodBtn*subfoodBtn=[[SubfoodBtn alloc]initWithFrame:CGRectMake(rect.origin.x+rect.size.width+10, 30+line*50, textSzie.width+20, 35)];
            subfoodBtn.subfood=subfood;
            
            subfoodBtn.subfoodPrice=subfood.dwUnitPrice;
            if ((self.showfood.dwIncSubFood&subfood.dwSFID)==subfood.dwSFID) {
                subfoodBtn.selected=YES;
                subfoodBtn.isDefInc=YES;
                subfoodBtn.defValue=1;
                subfoodBtn.value=1;
                
            }else{
                subfoodBtn.value=0;
    
            }
            
            subfoodBtn.tag=500+i;
            subfoodBtn.delegate=self;
            [self addSubview:subfoodBtn];
            rect=subfoodBtn.frame;
        }
    }
    CGFloat H=rect.origin.y+rect.size.height+100;
    self.superview.frame=CGRectMake(self.superview.frame.origin.x, (kScreenH-H)/2, self.superview.bounds.size.width, H);
}

-(void)setupBottomUI{
    UILabel*SubFoodL=[[UILabel alloc]init];
    SubFoodL.frame=CGRectMake(10, 0, 100, 20);
    SubFoodL.text=@"配菜:";
    SubFoodL.font=[UIFont systemFontOfSize:15];
    [self addSubview:SubFoodL];
    
    //加入购物车的背景
    [self.superview addSubview:self.bottomView];
    
}
//如果是套餐
-(void)setupPackageButton{
    UIButton*addbtn=[[UIButton alloc]initWithFrame:CGRectMake(self.bottomView.bounds.size.width-110, 7, 100, 26)];
    self.cartBtn=addbtn;
    [addbtn addTarget:self action:@selector(order:) forControlEvents:UIControlEventTouchUpInside];
    [addbtn setBackgroundColor:KmainColor];
    addbtn.layer.masksToBounds=YES;
    [addbtn setTitle:@"确定" forState:UIControlStateNormal];
    addbtn.titleLabel.font=[UIFont systemFontOfSize:15];
    addbtn.layer.cornerRadius=13;
    [self.bottomView addSubview:addbtn];
}
-(void)setupButton{
    //如果已经加入购物车，显示数量
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
        self.currentOrderfood.dwQuantity=number;
        increaseStatus?(self.showfood.orderNum=self.showfood.orderNum+1):(self.showfood.orderNum=self.showfood.orderNum-1);
        if ([self.delegate respondsToSelector:@selector(ChosenSubfoodViewFinish:withView:withTag:)]) {
            [self.delegate ChosenSubfoodViewFinish:self.currentOrderfood withView:self.cartBtn withTag:increaseStatus];
        }
       
    };
    
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
    
    UILabel*priceL=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 40)];
    priceL.textColor=[UIColor redColor];
    priceL.font=[UIFont systemFontOfSize:18];
    [self.bottomView addSubview:priceL];
    priceL.text=[NSString stringWithFormat:@"$%.2f",self.showfood.dwSoldPrice/100.0];
    self.priceL=priceL;
    if (self.showfood.orderNum) {
        [self.cartBtn setHidden:YES];
        [self.ppBtn setHidden:NO];
    }else{
        [self.cartBtn setHidden:NO];
        [self.ppBtn setHidden:YES];
    }
}
//点击加入购物车
-(void)order:(UIButton*)sender{
    if (!self.isPackage) {
        self.cartBtn.hidden=YES;
        self.ppBtn.hidden=NO;
        self.ppBtn.currentNumber=1;
    }
    [self order];
}
-(void)order{
    OrderFood*orderfood=[[OrderFood alloc]init];
    orderfood.szSelSubFoodArrayStr=[self renturnSelSubFoodArrayStr];
    orderfood.szSelFlavor=@"";
    orderfood.szSelCookWay=@"";
    orderfood.szSelSubFood=[self renturnSelSubFood];
    orderfood.dwShowFoodID=self.showfood.dwShowFoodID;
    orderfood.dwSelCookWay=self.showfood.dwCookWayProp;
    orderfood.dwFoodType=1;
    orderfood.dwParentIndex=0;
    orderfood.dwQuantity=1;
    orderfood.dwFoodPrice=self.showfood.dwSoldPrice;
    orderfood.dwCookPrice=0;
    if (self.priceOffset>0) {
        orderfood.dwSubFoodPrice=self.priceOffset;
    }else{
        orderfood.dwSubFoodPrice=0;
    }
    orderfood.dwFlavorPrice=0;
    orderfood.dwFoodDiscount=0;
    orderfood.dwSubFoodDiscount=0;
    orderfood.szShowFoodName=self.showfood.szDispName;
    orderfood.dwGroupID=self.showfood.dwGroupID;
    self.currentOrderfood=orderfood;
    if ([self.delegate respondsToSelector:@selector(ChosenSubfoodViewFinish:withView:withTag:)]) {
        [self.delegate ChosenSubfoodViewFinish:orderfood withView:self.cartBtn withTag:-1];
    }
}
-(void)setupRepartPrice{
    NSInteger offset=0;
    for (SubfoodBtn*btnView in self.subviews) {
        if ([btnView isKindOfClass:[SubfoodBtn class]]) {
            if (btnView.subfood.dwUnitPrice>0) {
                if (btnView.value!=btnView.defValue) {
                    offset=offset+(btnView.value-btnView.defValue)*btnView.subfood.dwUnitPrice;
                }
            }

        }
    }
    self.priceOffset=offset;
    if (offset>0) {
        self.priceL.text=[NSString stringWithFormat:@"$%.2f",(self.showfood.dwSoldPrice+offset)/100.0];
    }else{
        if ((self.showfood.dwSoldPrice+offset)>self.showfood.dwMinPrice) {
            self.priceL.text=[NSString stringWithFormat:@"$%.2f",(self.showfood.dwSoldPrice+offset)/100.0];
        }else{
            self.priceL.text=[NSString stringWithFormat:@"$%.2f",self.showfood.dwMinPrice/100.0];
        }
        
    }
}
//点击口味按钮
-(void)SubfoodBtnClick:(SubfoodBtn*)button{
    NSInteger offset=0;
    for (SubfoodBtn*btnView in self.subviews) {
        if ([btnView isKindOfClass:[SubfoodBtn class]]) {
            if (btnView.subfood.dwUnitPrice>0) {
                if (btnView.value!=btnView.defValue) {
                    offset=offset+(btnView.value-btnView.defValue)*btnView.subfood.dwUnitPrice;
                }
            }
        }
    }
    self.priceOffset=offset;
    if (offset>0) {
         self.priceL.text=[NSString stringWithFormat:@"$%.2f",(self.showfood.dwSoldPrice+offset)/100.0];
    }else{
        if ((self.showfood.dwSoldPrice+offset)>self.showfood.dwMinPrice) {
            self.priceL.text=[NSString stringWithFormat:@"$%.2f",(self.showfood.dwSoldPrice+offset)/100.0];
        }else{
            self.priceL.text=[NSString stringWithFormat:@"$%.2f",self.showfood.dwMinPrice/100.0];
        }
        
    }
    
    
    for (int i=0; i<self.orderfoods.count; i++) {
        OrderFood*orderfood=self.orderfoods[i];
        if ((self.showfood.dwShowFoodID==orderfood.dwShowFoodID)&&([orderfood.szSelSubFood isEqualToString:[self renturnSelSubFood]])) {
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
-(NSString*)renturnSelSubFood{
    NSString*SelSubFood=@"";
    for (SubfoodBtn*btnView in self.subviews) {
        if ([btnView isKindOfClass:[SubfoodBtn class]]) {
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
    return SelSubFood;
}
-(NSString*)renturnSelSubFoodArrayStr{
    NSString*SelSubFood=@"";
    for (SubfoodBtn*btnView in self.subviews) {
        if ([btnView isKindOfClass:[SubfoodBtn class]]) {
            if (btnView.value!=btnView.defValue) {
                SelSubFood=[SelSubFood stringByAppendingFormat:@"%ld:%ld;",btnView.subfood.dwSFID,btnView.value];
                
            }
        }
    }
    if (SelSubFood.length>1) {
        return [SelSubFood substringToIndex:SelSubFood.length-1];
    }
    return SelSubFood;
}
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.superview.bounds.size.height-40, self.bounds.size.width, 40)];
        _bottomView.backgroundColor=KColor(240, 240, 240);
        self.isPackage?[self setupPackageButton]:[self setupButton];
       
    }
    return _bottomView;
}
-(NSMutableArray *)statusArray{
    if (!_statusArray) {
        _statusArray=[NSMutableArray array];
    }
    return _statusArray;
}
@end
