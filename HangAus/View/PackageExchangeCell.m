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
@interface PackageExchangeCell()
@property(nonatomic,strong)UIImageView*foodImageView;
@property(nonatomic,strong)UILabel*foodNameL;
@property(nonatomic,strong)UIButton*editBtn;
@property(nonatomic,strong)UILabel*numL;
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
-(void)setShowfood:(ShowFood *)showfood{
    _showfood=showfood;
    [self setupView];
}
-(void)setupView{
    [self.foodImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg",KrootImagePath,[CommonFunc md5:[NSString stringWithFormat:@"%ld",self.showfood.dwShowFoodID]]]] placeholderImage:[UIImage imageNamed:@"coca"] options:SDWebImageRefreshCached];
    [self.contentView addSubview:self.foodImageView];
    
    self.foodNameL.text=self.showfood.szDispName;
    [self.contentView addSubview:self.foodNameL];
    
  
    
    if (self.showfood.dwDefQuantity>1) {
        [self.editBtn removeFromSuperview];
        self.numL.textColor=[UIColor orangeColor];
        self.numL.font=[UIFont systemFontOfSize:15];
        self.numL.textAlignment=NSTextAlignmentRight;
        self.numL.text=[NSString stringWithFormat:@"✘%ld",self.showfood.dwDefQuantity];
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
        _foodNameL=[[UILabel alloc]initWithFrame:CGRectMake(70, 10, kScreenW/2, 40)];
        _foodNameL.textColor=[UIColor orangeColor];
        _foodNameL.font=[UIFont systemFontOfSize:15];
    }
    return _foodNameL;
}
-(UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenW-60, 10, 40, 40)];
        _editBtn.tag=999;
        [_editBtn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    }
    return _editBtn;
}
-(UILabel *)numL{
    if (!_numL) {
        _numL=[[UILabel alloc]initWithFrame:CGRectMake(kScreenW-100, 10, 80, 40)];
    }
    return _numL;
}
@end
