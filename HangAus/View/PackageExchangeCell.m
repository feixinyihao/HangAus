//
//  PackageExchangeCell.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/12.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "PackageExchangeCell.h"
#import "PackageExchange.h"
#import "ShowFood.h"
#import <UIImageView+WebCache.h>
#import <PPNumberButton.h>
#import "OrderFood.h"
@interface PackageExchangeCell()
@property(nonatomic,strong)UIImageView*foodImageView;
@property(nonatomic,strong)UILabel*foodNameL;
@property(nonatomic,strong)UIButton*editBtn;
@property(nonatomic,strong)UILabel*numL;
@property(nonatomic,strong)UILabel*detailTextL;
@end
@implementation PackageExchangeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
+(PackageExchangeCell*)initWithTableView:(UITableView*)tableView{
    static NSString* ID=@"cell";
    PackageExchangeCell* cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[PackageExchangeCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)setOrderfood:(OrderFood *)orderfood{
    _orderfood=orderfood;
    [self setupView];
}
-(void)setupView{
    [self.foodImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg",KrootImagePath,[CommonFunc md5:[NSString stringWithFormat:@"%ld",self.orderfood.dwShowFoodID]]]] placeholderImage:[UIImage imageNamed:@"coca"] options:SDWebImageRefreshCached];
    self.foodImageView.layer.cornerRadius=5;
    self.foodImageView.layer.masksToBounds=YES;
    [self.contentView addSubview:self.foodImageView];
    
    self.foodNameL.text=self.orderfood.szShowFoodName;
    [self.contentView addSubview:self.foodNameL];
    
    self.detailTextL.text=[NSString stringWithFormat:@"%@ %@%@",self.orderfood.szSelCookWay,self.orderfood.szSelFlavor,self.orderfood.szSelSubFood];
    if ([[self.detailTextL.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]
        ||!self.detailTextL.text||!self.detailTextL.text.length||[self.detailTextL.text isEqual:[NSNull null]]) {
        self.detailTextL.text=@"Default";
    }
    [self.contentView addSubview:self.detailTextL];
  
    
    if (self.orderfood.dwQuantity>1) {
        [self.editBtn removeFromSuperview];
        self.numL.textColor=[UIColor orangeColor];
        self.numL.font=[UIFont systemFontOfSize:15];
        self.numL.textAlignment=NSTextAlignmentRight;
        self.numL.text=[NSString stringWithFormat:@"✘%ld",self.orderfood.dwQuantity];
        [self.contentView addSubview:self.numL];
    }else{
        [self.numL removeFromSuperview];
        [self.contentView addSubview:self.editBtn];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(UIImageView *)foodImageView{
    if (!_foodImageView) {
        _foodImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
    }
    return _foodImageView;
}
-(UILabel *)foodNameL{
    if (!_foodNameL) {
        _foodNameL=[[UILabel alloc]initWithFrame:CGRectMake(70, 10, kScreenW/2, 20)];
        _foodNameL.textColor=[UIColor orangeColor];
        _foodNameL.font=[UIFont systemFontOfSize:17];
    }
    return _foodNameL;
}
-(UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenW-60, 10, 40, 40)];
        _editBtn.tag=999;
        [_editBtn setImage:[UIImage imageNamed:@"exchange"] forState:UIControlStateNormal];
    }
    return _editBtn;
}
-(UILabel *)numL{
    if (!_numL) {
        _numL=[[UILabel alloc]initWithFrame:CGRectMake(kScreenW-100, 10, 80, 40)];
    }
    return _numL;
}

-(UILabel *)detailTextL{
    if (!_detailTextL) {
        _detailTextL=[[UILabel alloc]init];
        _detailTextL.frame=CGRectMake(70, 30,0.7*kScreenW, 20);
        _detailTextL.textColor=[UIColor grayColor];
        _detailTextL.font=[UIFont systemFontOfSize:12];
    }
    return _detailTextL;
}
@end
