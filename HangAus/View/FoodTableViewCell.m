//
//  FoodTableViewCell.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/2/7.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "FoodTableViewCell.h"
#import "ShowFood.h"
#import <UIImageView+WebCache.h>
#import <PPNumberButton.h>
#import "ShopSubFood.h"
#import "DataBase.h"
#import "ChosenFood.h"
@interface FoodTableViewCell()
@property(nonatomic,strong)UIImageView*foodImage;

@property(nonatomic,strong)UILabel*foodName;

@property(nonatomic,strong)UILabel*foodBalance;

@property(nonatomic,strong)UIButton*editBtn;

@property(nonatomic,strong)UIButton*downBtn;

@property(nonatomic,strong)UILabel*shadow;

@property(nonatomic,strong)PPNumberButton*ppBtn;

@property(nonatomic,strong)UIButton*packgesBtn;
@end
@implementation FoodTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
+(FoodTableViewCell*)initWithTableView:(UITableView*)tableView{
    static NSString* ID=@"cell";
    FoodTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[FoodTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
-(void)setFood:(ShowFood *)food{
    _food=food;
    [self setupView];
}

-(void)setupView{
    self.foodImage.frame=CGRectMake(10, 10, 80, 80);
    [self.foodImage sd_setImageWithURL:[NSURL URLWithString:self.food.imagePath]];
    [self.contentView addSubview:self.foodImage];
    
    self.foodName.frame=CGRectMake(100, 10, self.frame.size.width-100, 30);
    self.foodName.text=self.food.szDispName;
    [self.contentView addSubview:self.foodName];
    
    self.foodBalance.frame=CGRectMake(100, 40, 100, 30);
   
    self.foodBalance.text=[NSString stringWithFormat:@"$%.1f0",[self returnPriceFromShowFood:self.food isDiscount:YES]/100.0];
    self.foodBalance.textColor=[UIColor orangeColor];
    [self.contentView addSubview:self.foodBalance];
    
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.editBtn.layer.cornerRadius=4;
    self.editBtn.frame=CGRectMake((kScreenW*0.75-90)/7+90, 70, (kScreenW*0.75-90)*2/7, 30);
    [self.editBtn setBackgroundColor:KColor(233, 237, 240)];
    self.editBtn.tag=800;
    [self.editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.editBtn];
    
   
    self.downBtn.layer.cornerRadius=4;
    self.downBtn.tag=801;
    [self.downBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.downBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.downBtn.frame=CGRectMake((kScreenW*0.75-90)*4/7+90, 70, (kScreenW*0.75-90)*2/7, 30);
    [self.downBtn setBackgroundColor:KColor(233, 237, 240)];
    [self.contentView addSubview:self.downBtn];
    [self.foodImage addSubview:self.shadow];
    if ((self.food.dwStat&2)==2) {
        [self.downBtn setTitle:@"下架" forState:UIControlStateNormal];
        self.shadow.frame=CGRectMake(0, 60, 80, 20);
        self.shadow.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2];
        self.shadow.textColor=[UIColor orangeColor];
        self.shadow.font=[UIFont systemFontOfSize:12];
        self.shadow.textAlignment=NSTextAlignmentCenter;
        self.shadow.text=@"售卖中";
       
    }else{
         [self.downBtn setTitle:@"上架" forState:UIControlStateNormal];
         self.shadow.frame=CGRectMake(0, 0, 80, 80);
         self.shadow.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2];
         self.shadow.textColor=[UIColor grayColor];
         self.shadow.font=[UIFont systemFontOfSize:12];
         self.shadow.textAlignment=NSTextAlignmentCenter;
         self.shadow.text=@"停止售卖";
        
    }
    if (self.isSales) {
        [self.downBtn removeFromSuperview];
        [self.editBtn removeFromSuperview];
       
        if (self.food.dwShowProp==2) {
            [self.contentView addSubview:self.packgesBtn];
            [self.packgesBtn addTarget:self action:@selector(packageOrder:) forControlEvents:UIControlEventTouchUpInside];
            [self.ppBtn removeFromSuperview];
        }else{
            self.ppBtn.frame=CGRectMake(kScreenW*0.75-20-80, 60, 80, 20);
            self.ppBtn.decreaseHide = YES;
            self.ppBtn.shakeAnimation = YES;
            self.ppBtn.currentNumber=self.food.orderNum;
            self.ppBtn.increaseImage = [UIImage imageNamed:@"increase"];
            self.ppBtn.decreaseImage = [UIImage imageNamed:@"decrease"];
            __weak typeof(self) weakSelf = self;
            self.ppBtn.resultBlock = ^(NSInteger number, BOOL increaseStatus) {
                //DLog(@"%ld---%d",number,increaseStatus);
                
                if ([weakSelf.delegate respondsToSelector:@selector(ppNumDidClickWithCell:withIncreaseStatus:)]) {
                    [weakSelf.delegate ppNumDidClickWithCell:weakSelf withIncreaseStatus:increaseStatus];
                }
            };
            [self.packgesBtn removeFromSuperview];
            [self.contentView addSubview:self.ppBtn];
        }

    }else{
        [self.ppBtn removeFromSuperview];
    }
    
}
-(void)packageOrder:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(FoodTableViewCellOrderPackages:withShowfood:)]) {
        [self.delegate FoodTableViewCellOrderPackages:self withShowfood:self.food];
    }
}
-(NSInteger)returnPriceFromShowFood:(ShowFood*)showfood isDiscount:(BOOL)discount{
    //论重量卖
    if (showfood.dwSoldProp==2) {
        if (showfood.dwDefQuantity==0) {
            return discount?showfood.dwUnitPrice-showfood.dwDiscount: showfood.dwUnitPrice;
        }else{
            return discount?roundf(showfood.dwUnitPrice*showfood.dwDefQuantity/1000.0-showfood.dwDiscount):roundf(showfood.dwUnitPrice*showfood.dwDefQuantity/1000.0);
        }
        //套餐
    }else if (showfood.dwShowProp==2){
        NSInteger total=0;
        for (int i=0; i<showfood.ChosenFoods.count; i++) {
            ChosenFood*chosenfood=showfood.ChosenFoods[i];
            ShowFood*chosenShowfood=[[DataBase sharedDataBase]getShowFoodWithID:chosenfood.dwShowFoodID];
            if (chosenShowfood.dwSoldProp==2) {
                chosenShowfood.dwDefQuantity=chosenfood.dwQuantity;
                 total=total+[self returnPriceFromShowFood:chosenShowfood isDiscount:NO];
            }else{
                 total=total+[self returnPriceFromShowFood:chosenShowfood isDiscount:NO]*chosenfood.dwQuantity;
            }
        }
        return discount?total-showfood.dwDiscount:total;
        //食物包含配料
    }else if (showfood.dwIncSubFood){
        return discount?[self returnTotalPrice:showfood.dwIncSubFood]+showfood.dwUnitPrice-showfood.dwDiscount:[self returnTotalPrice:showfood.dwIncSubFood]+showfood.dwUnitPrice;
    }else{
        return discount?showfood.dwUnitPrice-showfood.dwDiscount:showfood.dwUnitPrice;
    }
}
-(NSInteger)returnTotalPrice:(NSInteger)incSubfood{
    NSArray*subfoodArray=[[DataBase sharedDataBase]getAllShopSubFood];
    NSInteger subPrice=0;
    for (int i=0; i<subfoodArray.count;i++) {
        ShopSubFood*subfood=subfoodArray[i];
        if ((incSubfood&subfood.dwSFID)==subfood.dwSFID) {
            subPrice=subPrice+subfood.dwUnitPrice;
        }
    }
    return subPrice;
}

-(void)editBtnClick:(UIButton*)btn{
    if ([self.delegate respondsToSelector:@selector(FoodTableViewCelleditBtnClick:withCell: )]) {
        [self.delegate FoodTableViewCelleditBtnClick:btn withCell:self];
       
    }
}

#pragma mark setter/getter
-(UIImageView *)foodImage{
    if (!_foodImage) {
        _foodImage=[[UIImageView alloc]init];
    }
    return _foodImage;
}

-(UILabel *)foodName{
    if (!_foodName) {
        _foodName=[[UILabel alloc]init];
    }
    return _foodName;
}

-(UILabel *)foodBalance{
    if (!_foodBalance) {
        _foodBalance=[[UILabel alloc]init];
    }
    return _foodBalance;
}
-(UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn=[[UIButton alloc]init];
    }
    return _editBtn;
}
-(UIButton *)downBtn{
    if (!_downBtn) {
        _downBtn=[[UIButton alloc]init];
    }
    return _downBtn;
}
-(UILabel *)shadow{
    if (!_shadow) {
        _shadow=[[UILabel alloc]init];
    }
    return _shadow;
}
-(PPNumberButton *)ppBtn{
    if (!_ppBtn) {
        _ppBtn=[[PPNumberButton alloc]init];
        [_ppBtn setEditing:NO];
    }
    return _ppBtn;
}
-(UIButton *)packgesBtn{
    if (!_packgesBtn) {
        _packgesBtn=[[UIButton alloc]init];
        [_packgesBtn setTitle:@"随心配" forState:UIControlStateNormal];
        _packgesBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [_packgesBtn setTitleColor:KmainColor forState:UIControlStateNormal];
        _packgesBtn.layer.cornerRadius=5;
        _packgesBtn.layer.masksToBounds=YES;
        _packgesBtn.layer.borderColor=KmainColor.CGColor;
        _packgesBtn.layer.borderWidth=1;
        _packgesBtn.frame=CGRectMake((kScreenW*0.75-90)*4/7+90, 70, (kScreenW*0.75-90)*2/7, 30);
    }
    return _packgesBtn;
}
@end
