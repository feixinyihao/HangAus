//
//  SubFoodCell.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/4/8.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "SubFoodCell.h"
#import "ShopSubFood.h"
#import "SoldFood.h"
#import "ShopCookway.h"
#import "ShopFlavor.h"
@interface SubFoodCell()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField*priceField;
@property(nonatomic,strong)UIButton* didBtn;
@end
@implementation SubFoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(SubFoodCell*)initWithTableView:(UITableView*)tableView{
    static NSString* ID=@"cell";
    SubFoodCell* cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[SubFoodCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)setSubfood:(ShopSubFood *)subfood{
    _subfood=subfood;
    [self setupView];
}
-(void)setSoldfood:(SoldFood *)soldfood{
    _soldfood=soldfood;
    [self setupView];
}
-(void)setCookway:(ShopCookway *)cookway{
    _cookway=cookway;
    [self setupView];
}
-(void)setShopFlavor:(ShopFlavor *)shopFlavor{
    _shopFlavor=shopFlavor;
    [self setupView];
}
-(void)setupView{
   
    self.priceField.frame=CGRectMake(kScreenW-120, 5, 60, 50);
    if (self.subfood) {
        self.priceField.text=[NSString stringWithFormat:@"%.2f",self.subfood.dwUnitPrice/100.0];
        self.textLabel.text=self.subfood.szName;
    }else if(self.soldfood){
        self.priceField.text=[NSString stringWithFormat:@"%.2f",self.soldfood.dwUnitPrice/100.0];
        self.textLabel.text=self.soldfood.szFoodName;
    }else if (self.cookway){
        self.priceField.text=[NSString stringWithFormat:@"%.2f",self.cookway.dwUnitPrice/100.0];
        self.textLabel.text=self.cookway.szName;
    }else if (self.shopFlavor){
        self.priceField.text=[NSString stringWithFormat:@"%.2f",self.shopFlavor.dwUnitPrice/100.0];
        self.textLabel.text=self.shopFlavor.szName;
    }
    
    self.priceField.layer.borderWidth=1;
    self.priceField.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.priceField.layer.cornerRadius=5;
    self.priceField.keyboardType=UIKeyboardTypeDecimalPad;
    self.priceField.delegate=self;
    [self.priceField addTarget:self action:@selector(change:) forControlEvents:UIControlEventEditingChanged];
    self.priceField.textAlignment=NSTextAlignmentCenter;
    self.priceField.textColor=[UIColor redColor];
    [self.contentView addSubview:self.priceField];
    
    self.didBtn.frame=CGRectMake(kScreenW-55, 5, 50, 50);
    [self.didBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.didBtn setImage:[UIImage imageNamed:@"finish_dis"] forState:UIControlStateNormal];
    [self.didBtn setImage:[UIImage imageNamed:@"finish_sel"] forState:UIControlStateSelected];
    self.didBtn.selected=NO;
    [self.contentView addSubview:self.didBtn];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)btnClick:(UIButton*)sender{
    if (sender.selected) {
        if ([self.delegate respondsToSelector:@selector(SubFoodCellBtnClick:withCell:withStr:)]) {
            [self.delegate SubFoodCellBtnClick:sender withCell:self withStr:self.priceField.text];
            sender.selected=NO;
        }
    }
    
}
-(UIButton *)didBtn{
    if (!_didBtn) {
        _didBtn=[[UIButton alloc]init];
    }
    return _didBtn;
}
-(UITextField *)priceField{
    if (!_priceField) {
        _priceField=[[UITextField alloc]init];
    }
    return _priceField;
}
-(void)change:(UITextField*)textField{
    if (self.subfood) {
        if (self.subfood.dwUnitPrice!=[textField.text floatValue]*100) {
            self.didBtn.selected=YES;
        }else{
            self.didBtn.selected=NO;
        }
    }else if(self.soldfood){
        if (self.soldfood.dwUnitPrice!=[textField.text floatValue]*100) {
            self.didBtn.selected=YES;
        }else{
            self.didBtn.selected=NO;
        }
    }else if (self.cookway){
        if (self.cookway.dwUnitPrice!=[textField.text floatValue]*100) {
            self.didBtn.selected=YES;
        }else{
            self.didBtn.selected=NO;
        }
    }else if (self.shopFlavor){
        if (self.shopFlavor.dwUnitPrice!=[textField.text floatValue]*100) {
            self.didBtn.selected=YES;
        }else{
            self.didBtn.selected=NO;
        }
    }
    
    if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        self.didBtn.selected=NO;
    }

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    BOOL isHaveDian=YES;
    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
        isHaveDian=NO;
    }
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length]==0){
                if(single == '.'){
                    //[self alertView:@"亲，第一个数字不能为小数点"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                if (single == '0') {
                    textField.text=@"0.";
                    return NO;
                }
            }
            if (single=='.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian=YES;
                    return YES;
                }else
                {
                    //[self alertView:@"亲，您已经输入过小数点了"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (isHaveDian)//存在小数点
                {
                    
                    //判断小数点的位数
                    NSRange ran=[textField.text rangeOfString:@"."];
                    NSInteger tt=range.location-ran.location;
                    if (tt <= 2){
                        return YES;
                    }else{
                        //[self alertView:@"亲，您最多输入两位小数"];
                        return NO;
                    }
                }
                else
                {
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}
@end
