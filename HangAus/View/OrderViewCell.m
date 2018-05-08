//
//  OrderViewCell.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/5/2.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "OrderViewCell.h"
#import "OrderFood.h"
#import <PPNumberButton.h>
@interface OrderViewCell()
@property(nonatomic,strong)PPNumberButton*ppBtn;
@property(nonatomic,strong)UILabel*priceL;
@end
@implementation OrderViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
+(OrderViewCell*)initWithTableView:(UITableView*)tableView{
    static NSString* ID=@"cell";
    OrderViewCell* cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell==nil) {
        cell=[[OrderViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
-(void)setOrderfood:(OrderFood *)orderfood{
    _orderfood=orderfood;
    [self setupUI];
}
-(void)setupUI{
    self.detailTextLabel.textColor=[UIColor lightGrayColor];
    self.detailTextLabel.font=[UIFont systemFontOfSize:12];
    self.detailTextLabel.numberOfLines=0;
    self.textLabel.text=self.orderfood.szShowFoodName;
    if (self.orderfood.dwFoodType==1) {
        
        self.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@%@",self.orderfood.szSelCookWay,self.orderfood.szSelFlavor,self.orderfood.szSelSubFood];
        if ([[self.detailTextLabel.text  stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
            self.detailTextLabel.text=@"";
        }
    }else{
        self.detailTextLabel.text=self.orderfood.szMemo;
    }
    
    self.ppBtn.frame=CGRectMake(kScreenW-80, 20, 70, 20);
    self.ppBtn.decreaseHide = YES;
    self.ppBtn.shakeAnimation = YES;
    self.ppBtn.editing=NO;
    self.ppBtn.minValue=1;
    self.ppBtn.maxValue=10;
    self.ppBtn.currentNumber=self.orderfood.dwQuantity;
    self.ppBtn.increaseImage = [UIImage imageNamed:@"increase"];
    self.ppBtn.decreaseImage = [UIImage imageNamed:@"decrease"];
    self.ppBtn.longPressSpaceTime=CGFLOAT_MAX;
     __weak typeof(self) weakSelf = self;
    self.ppBtn.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus) {
        if ([weakSelf.delegate respondsToSelector:@selector(OrderViewCellAction:withStatus:withNum:)]) {
            [weakSelf.delegate OrderViewCellAction:weakSelf withStatus:increaseStatus withNum:number];
        }
    };
    [self.contentView addSubview:self.ppBtn];
    
    self.priceL.frame=CGRectMake(kScreenW-140, 20, 60, 20);
    self.priceL.font=[UIFont systemFontOfSize:15];
    self.priceL.textColor=[UIColor orangeColor];
    NSInteger totalPrice=(self.orderfood.dwCookPrice+
                         self.orderfood.dwFoodPrice+
                         self.orderfood.dwSubFoodPrice+
                         self.orderfood.dwFlavorPrice-
                         self.orderfood.dwFoodDiscount-
                         self.orderfood.dwSubFoodDiscount)*self.orderfood.dwQuantity;
    self.priceL.text=[NSString stringWithFormat:@"$%.2f",totalPrice/100.0];
    [self.contentView addSubview:self.priceL];
    
    if (self.orderfood.dwFoodType==4) {
        self.ppBtn.frame=CGRectMake(kScreenW-80, 5, 70, 20);
        self.priceL.frame=CGRectMake(kScreenW-140, 5, 60, 20);
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(PPNumberButton *)ppBtn{
    if (!_ppBtn) {
        _ppBtn=[[PPNumberButton alloc]init];
    }
    return _ppBtn;
}
-(UILabel *)priceL{
    if (!_priceL) {
        _priceL=[[UILabel alloc]init];
    }
    return _priceL;
}
@end
