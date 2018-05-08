//
//  OrderBottonView.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/27.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "OrderBottonView.h"
#import "CartView.h"
#import "OrderFood.h"
@interface OrderBottonView()
@property(nonatomic,weak)CartView*cartview;
@property(nonatomic,weak)UIButton*submitBtn;
@property(nonatomic,weak)UILabel*priceL;
@end
@implementation OrderBottonView

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        if (self) {
            self.backgroundColor=[UIColor grayColor];
            UIButton*submitBtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenW-100, 0, 100, frame.size.height)];
            [submitBtn setBackgroundImage:[CommonFunc imageWithColor:KmainColor] forState:UIControlStateSelected];
            [submitBtn setBackgroundImage:[CommonFunc imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
            //选好了
            [submitBtn setTitle:KLocalizedString(@"6000009") forState:UIControlStateNormal];
            [self addSubview:submitBtn];
            self.submitBtn=submitBtn;
            
            CartView*cartView=[[CartView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
            [self addSubview:cartView];
            self.cartview=cartView;
            
            UILabel*priceL=[[UILabel alloc]init];
            priceL.textColor=[UIColor whiteColor];
            priceL.font=[UIFont systemFontOfSize:20];
            priceL.frame=CGRectMake(80, 5, kScreenW/2, 40);
            [self addSubview:priceL];
            self.priceL=priceL;
            
            UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            
            [self addGestureRecognizer:tapGesturRecognizer];

        }
    }
    return self;
}
-(void)tapAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(OrderBottonViewClick:)]) {
        [self.delegate OrderBottonViewClick:self];
    }
}
-(instancetype)init{
    return [self initWithFrame:CGRectNull];
}
-(void)setOrderfoods:(NSArray *)orderfoods{
    _orderfoods=orderfoods;
    self.submitBtn.selected=orderfoods.count;
    [UIView animateWithDuration:0.1 animations:^{
        self.cartview.transform=CGAffineTransformMakeScale(1.2,1.2);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.1 animations:^{
                self.cartview.transform=CGAffineTransformMakeScale(1,1);
            }];
            
        });
    }];
    if (orderfoods.count>0) {
        self.priceL.text=[NSString stringWithFormat:@"$%.2f",[self getPriceFromOrderfoods]/100.0];
    }else{
        self.cartview.num=0;
        self.priceL.text=@"";
    }
}
-(NSInteger)getPriceFromOrderfoods{
    NSInteger price=0;
    NSInteger foodNUm=0;
    for (int i=0; i<self.orderfoods.count; i++) {
        OrderFood*orderfood=self.orderfoods[i];
        if (orderfood.dwFoodType!=2) {
            foodNUm=foodNUm+orderfood.dwQuantity;
            price=price+(orderfood.dwFoodPrice+orderfood.dwCookPrice+orderfood.dwFlavorPrice+orderfood.dwSubFoodPrice-orderfood.dwFoodDiscount-orderfood.dwSubFoodDiscount)*orderfood.dwQuantity;
        }
       
    }
    self.cartview.num=foodNUm;
    return price;
}
@end
