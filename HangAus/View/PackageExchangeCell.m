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
@interface PackageExchangeCell()
@property(nonatomic,strong)UIImageView*foodImageView;
@property(nonatomic,strong)UILabel*foodNameL;
@property(nonatomic,strong)UIButton*editBtn;

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
-(void)setPackage:(PackageExchange *)package{
    _package=package;
    [self setupView];
}
-(void)setupView{
    [self.foodImageView setImage:[UIImage imageNamed:@"coca"]];
    [self.contentView addSubview:self.foodImageView];
    
    self.foodNameL.text=self.package.chosenShowFood.szDispName;
    [self.contentView addSubview:self.foodNameL];
    
    [self.contentView addSubview:self.editBtn];

    
    for (int i=0; i<self.package.sameGroupFoods.count; i++) {
        ShowFood*showfood=self.package.sameGroupFoods[i];
        UIButton*foodBtn=[self.contentView viewWithTag:1000+i];
        if (foodBtn) {
            [foodBtn setImage:[UIImage imageNamed:@"coca"] forState:UIControlStateNormal];
            [foodBtn setTitle:showfood.szDispName forState:UIControlStateNormal];
        }else{
            UIButton*foodBtn=[[UIButton alloc]init];
            CGFloat space=20;
            CGFloat w=(kScreenW-4*space)/3;
            foodBtn.frame=CGRectMake(space+(i%3)*(w+space), 60+(i/3)*90, w, 80);
            foodBtn.tag=1000+i;
            [foodBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [self.contentView addSubview:foodBtn];
            [foodBtn setImage:[UIImage imageNamed:@"coca"] forState:UIControlStateNormal];
            [foodBtn setTitle:showfood.szDispName forState:UIControlStateNormal];
            
        }
       
        self.package.cellHigh=foodBtn.frame.origin.y+foodBtn.frame.size.height+10;
        
        
    }
    if (self.package.sameGroupFoods.count<1) {
        self.package.cellHigh=50;
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
        [_editBtn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    }
    return _editBtn;
}
@end
