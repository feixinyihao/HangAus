//
//  ChangeBalanceCell.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/7.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "ChangeBalanceCell.h"
#import "ShowFood.h"
#import "ShopSubFood.h"
#import <BGFMDB.h>
#import "ShowFood.h"
#import "ChosenFood.h"
@interface ChangeBalanceCell()<UITextFieldDelegate>
@property(nonatomic,strong)UILabel*nameL;

@property(nonatomic,strong)UILabel*priceL;

@property(nonatomic,strong)UILabel*otherName;

@property(nonatomic,strong)UILabel*balanceL;

@property(nonatomic,strong)UITextField*balanceField;

@property(nonatomic,strong)UIButton*didBtn;

@property(nonatomic,strong)UIButton*updownBtn;

@end

@implementation ChangeBalanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setShowFood:(ShowFood *)showFood{
    _showFood=showFood;
    [self setupView];
}
+(ChangeBalanceCell*)initWithTableView:(UITableView*)tableView{
    static NSString* ID=@"cell";
    ChangeBalanceCell* cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[ChangeBalanceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)setupView{
    self.nameL.frame=CGRectMake(10, 10, 200, 20);
    self.nameL.text=self.showFood.szDispName;
    self.nameL.font=[UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.nameL];
    
    self.updownBtn.frame=CGRectMake(kScreenW-60, 10, 50, 25);
    self.updownBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    self.updownBtn.layer.cornerRadius=5;
    [self.updownBtn addTarget:self action:@selector(updownClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.showFood.dwStat==2) {
        [self.updownBtn setTitle:@"下架" forState:UIControlStateNormal];
        [self.updownBtn setBackgroundColor:[UIColor orangeColor]];
    }else{
        [self.updownBtn setTitle:@"上架" forState:UIControlStateNormal];
        [self.updownBtn setBackgroundColor:KmainColor];
    }
    [self.contentView addSubview:self.updownBtn];
    
    [self.contentView addSubview:self.priceL];
    if (self.showFood.dwShowProp==1||self.showFood.dwSoldProp==2) {
        self.priceL.frame=CGRectMake(10, 50, 100, 20);
        self.priceL.text=@"价格";
        self.priceL.font=[UIFont systemFontOfSize:15];
        self.priceL.textColor=[UIColor grayColor];
        
        
        self.balanceField.frame=CGRectMake(kScreenW-120, 50, 80, 25);
        self.balanceField.delegate=self;
        [self.balanceField addTarget:self action:@selector(change:) forControlEvents:UIControlEventEditingChanged];
        self.balanceField.layer.borderColor=[UIColor lightGrayColor].CGColor;
        self.balanceField.layer.borderWidth=1;
        self.balanceField.layer.cornerRadius=4;
        self.balanceField.text=[NSString stringWithFormat:@"%.2f",self.showFood.dwSoldPrice/100.0];
        self.balanceField.textColor=[UIColor redColor];
        self.balanceField.textAlignment=NSTextAlignmentCenter;
        self.balanceField.keyboardType=UIKeyboardTypeDecimalPad;
        self.balanceField.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.balanceField];
        
        self.didBtn.frame=CGRectMake(kScreenW-40, 48, 30, 30);
        [self.didBtn setImage:[UIImage imageNamed:@"finish_dis"] forState:UIControlStateNormal];
        [self.didBtn setImage:[UIImage imageNamed:@"finish_sel"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.didBtn];
        [self.didBtn addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
        
       
        
        
       
       
        [self.otherName removeFromSuperview];
    }else{
        [self.balanceL removeFromSuperview];
       // [self.updownBtn removeFromSuperview];
        [self.didBtn removeFromSuperview];
        [self.balanceField removeFromSuperview];
        self.priceL.frame=CGRectMake(10, 55, kScreenW, 40);
        self.priceL.numberOfLines=0;
        self.priceL.font=[UIFont systemFontOfSize:12];
        self.priceL.textColor=[UIColor grayColor];
      
        if (self.showFood.dwIncSubFood>0) {
             self.priceL.text=[NSString stringWithFormat:@"包含：%@",[self returnStringFromInc:self.showFood.dwIncSubFood]];
        }
 
        if (self.showFood.ChosenFoods.count>0) {
          
           self.priceL.text= [self returnFoodFromPackages];
            
        }
        
        self.otherName.frame=CGRectMake(10, 35, kScreenW/2, 20);
        [self.contentView addSubview:self.otherName];
        self.otherName.font=[UIFont systemFontOfSize:12];
        self.otherName.textColor=[UIColor grayColor];
        self.otherName.textAlignment=NSTextAlignmentLeft;
        self.otherName.text=[NSString stringWithFormat:@"销售价$%.2f,最低价:$%.2f",self.showFood.dwSoldPrice/100.0,self.showFood.dwMinPrice/100.0];
    }
}



-(NSString*)returnFoodFromPackages{
   
    NSString*str=@"包含:";
    for (int i=0; i<self.showFood.ChosenFoods.count; i++) {
        ChosenFood*chosenfood=self.showFood.ChosenFoods[i];
        if (chosenfood.dwShowProp==1&&chosenfood.dwQuantity>1) {
            str=[str stringByAppendingFormat:@"%ld✘%@,",chosenfood.dwQuantity,chosenfood.szDisFoodName];
        }else{
            str=[str stringByAppendingFormat:@"%@,",chosenfood.szDisFoodName];
           
        }
    }
    return [str substringToIndex:str.length-1];
}
-(NSString*)returnStringFromInc:(NSInteger)inc{
    NSArray*incArray=[ShopSubFood bg_findAll:nil];
    NSString*str=@"";
    for (int i=0; i<incArray.count; i++) {
        ShopSubFood*shopsubfood=incArray[i];
        if ((inc&shopsubfood.dwSFID)>0) {
            NSString*subfoodName=[shopsubfood.szName stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
            str=[str stringByAppendingFormat:@"%@,",subfoodName];
        }
    }
    return str;
}
-(void)updownClick:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(ChangeBalanceCellupdownBtnClick:withCell:)]) {
        [self.delegate ChangeBalanceCellupdownBtnClick:sender withCell:self];
    }
}
-(void)didClick:(UIButton*)sender{
    if (sender.selected) {
        sender.selected=NO;
        if ([self.delegate respondsToSelector:@selector(ChangeBalanceCellBtnClick:withCell:withStr:)]) {
            [self.delegate ChangeBalanceCellBtnClick:sender withCell:self withStr:self.balanceField.text];
        }
    }
}
-(NSString*)returnPrice{
    if (self.showFood.dwSoldProp==2) {
        if (self.showFood.dwDefQuantity==0) {
            return  [NSString stringWithFormat:@"%.2f",self.showFood.dwUnitPrice/100.0];
        }else{
            return  [NSString stringWithFormat:@"%.2f",self.showFood.dwUnitPrice*self.showFood.dwDefQuantity/100000.0];
        }
        
    }else{
        if (self.showFood.dwShowProp==2) {
            return [NSString stringWithFormat:@"%.2f",self.showFood.dwMinPrice/100.0];
        }else{
            return [NSString stringWithFormat:@"%.2f",self.showFood.dwUnitPrice/100.0];
        }
    }
}
-(void)change:(UITextField*)textField{
    if ([[self returnPrice] floatValue]*100!=[textField.text floatValue]*100) {
        self.didBtn.selected=YES;
    }else{
        self.didBtn.selected=NO;
    }
    if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        self.didBtn.selected=NO;
    }
   
    
}
#pragma mark getter/setter
-(UILabel *)nameL{
    if (!_nameL) {
        _nameL=[[UILabel alloc]init];
    }
    return _nameL;
}
-(UILabel *)priceL{
    if (!_priceL) {
        _priceL=[[UILabel alloc]init];
    }
    return _priceL;
}
-(UILabel *)otherName{
    if (!_otherName) {
        _otherName=[[UILabel alloc]init];
    }
    return _otherName;
}
-(UILabel *)balanceL{
    if (!_balanceL) {
        _balanceL=[[UILabel alloc]init];
    }
    return _balanceL;
}
-(UITextField *)balanceField{
    if (!_balanceField) {
        _balanceField=[[UITextField alloc]init];
    }
    return _balanceField;
}
-(UIButton *)didBtn{
    if (!_didBtn) {
        _didBtn=[[UIButton alloc]init];
    }
    return _didBtn;
}
-(UIButton *)updownBtn{
    if (!_updownBtn) {
        _updownBtn=[[UIButton alloc]init];
    }
    return _updownBtn;
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
