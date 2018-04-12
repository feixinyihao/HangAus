//
//  ChangeBalanceCell.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/7.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "ChangeBalanceCell.h"
#import "ShowFood.h"
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
    
    self.priceL.frame=CGRectMake(10, 50, 100, 20);
    self.priceL.text=@"价格";
    self.priceL.font=[UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.priceL];
    
    self.otherName.frame=CGRectMake(kScreenW-110, 10, 100, 20);
    self.otherName.text=@"别名选择";
    self.otherName.textAlignment=NSTextAlignmentRight;
    self.otherName.font=[UIFont systemFontOfSize:15];
   // [self.contentView addSubview:self.otherName];
    
    self.balanceField.frame=CGRectMake(kScreenW-120, 50, 80, 25);
    self.balanceField.delegate=self;
    [self.balanceField addTarget:self action:@selector(change:) forControlEvents:UIControlEventEditingChanged];
    self.balanceField.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.balanceField.layer.borderWidth=1;
    self.balanceField.layer.cornerRadius=4;
    self.balanceField.text=[self returnPrice];
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
    
    self.updownBtn.frame=CGRectMake(kScreenW-60, 10, 50, 25);
    self.updownBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    if (self.showFood.dwStat==2) {
        [self.updownBtn setTitle:@"下架" forState:UIControlStateNormal];
         [self.updownBtn setBackgroundColor:[UIColor redColor]];
    }else{
        [self.updownBtn setTitle:@"上架" forState:UIControlStateNormal];
        [self.updownBtn setBackgroundColor:KmainColor];
    }
    
   
    self.updownBtn.layer.cornerRadius=5;
    [self.updownBtn addTarget:self action:@selector(updownClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.updownBtn];
    
    
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
