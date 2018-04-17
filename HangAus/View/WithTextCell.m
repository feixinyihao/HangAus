//
//  WithTextCell.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/21.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "WithTextCell.h"
#import "CellWithView.h"
#import <UIImageView+WebCache.h>
#import "ChosenFoodView.h"
#import "ShopSubFood.h"
#import "ShopFlavor.h"
#import "ShopCookway.h"
#import "UniHttpTool.h"
#import <MJExtension.h>
#import "ChoseSubFoodView.h"
#import <BGFMDB.h>
@interface WithTextCell()<UITextFieldDelegate,ChosenFoodViewDelegate,ChoseSubFoodViewDelegate>
@property(nonatomic,strong)UILabel*label;
@property(nonatomic,strong)UITextField*textField;

@property(nonatomic,strong)UIImageView*rightImageView;

@property(nonatomic,strong)ChosenFoodView*foodView;

@property(nonatomic,strong)ChoseSubFoodView*subfoodView;
@end
@implementation WithTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(WithTextCell*)initWithTableView:(UITableView*)tableView{
    static NSString* ID=@"cell";
    WithTextCell* cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[WithTextCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}
-(void)setCellWithView:(CellWithView *)cellWithView{
    _cellWithView=cellWithView;
    [self setupUI];
}
-(void)setupUI{
    self.textLabel.text=self.cellWithView.leftTitle;
    self.textLabel.font=[UIFont systemFontOfSize:15];
    self.detailTextLabel.font=[UIFont systemFontOfSize:14];
    if (self.cellWithView.keyboard) {
        self.textField.keyboardType=UIKeyboardTypeDecimalPad;
    }
   // DLog(@"--%ld---%@",self.cellWithView.subfoodprop,self.cellWithView.chosenFoods);
    if ([NSStringFromClass([UILabel class]) isEqualToString:self.cellWithView.viewClass]) {
        
        self.label.frame=CGRectMake(kScreenW/2-40, 0, kScreenW/2, 60);
        self.label.textAlignment=NSTextAlignmentRight;
        self.label.font=[UIFont systemFontOfSize:15];
        self.label.textColor=[UIColor blackColor];
        self.label.text=self.cellWithView.text;
        [self.textField removeFromSuperview];
        [self.rightImageView removeFromSuperview];
        [self.foodView removeFromSuperview];
       // [self.contentView addSubview:self.label];
        if (self.cellWithView.prop) {
            switch (self.cellWithView.propNum) {
                case 1:
                     self.detailTextLabel.text=[self stringFromSubfood];
                    break;
                case 2:
                     self.detailTextLabel.text=[self stringFromFlavorProp];
                    break;
                case 4:
                    self.detailTextLabel.text=[self stringFromCookWayProp];
                    break;
                default:
                    break;
            }
           
        }else{
            self.detailTextLabel.text=self.cellWithView.text;
        }
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
    }else if ([NSStringFromClass([UITextField class]) isEqualToString:self.cellWithView.viewClass]){
        [self.label removeFromSuperview];
        [self.foodView removeFromSuperview];
        [self.rightImageView removeFromSuperview];
        self.textField.frame=CGRectMake(100, 0, kScreenW-120, 60);
        self.textField.font=[UIFont systemFontOfSize:15];
        self.textField.placeholder=[NSString stringWithFormat:@"请输入%@",self.cellWithView.leftTitle];
        self.textField.text=self.cellWithView.text;
        self.textField.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:self.textField];
        self.accessoryType=UITableViewCellAccessoryNone;
        //self.textField.delegate=self;
       [self.textField addTarget:self action:@selector(TextChange:) forControlEvents:UIControlEventEditingChanged];
        
    }else if ([NSStringFromClass([UIImageView class]) isEqualToString:self.cellWithView.viewClass]){
        [self.label removeFromSuperview];
        [self.foodView removeFromSuperview];
        [self.textField removeFromSuperview];
        if (self.cellWithView.imagePath) {
            [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.cellWithView.imagePath] placeholderImage:[UIImage imageNamed:@"coca"] options:SDWebImageRefreshCached];
        }else{
            [self.rightImageView setImage:[UIImage imageNamed:self.cellWithView.imageName]];
        }
       

        //[self.rightImageView setImage:[UIImage imageNamed:self.cellWithView.imageName]];
      
       
        self.rightImageView.frame=CGRectMake(kScreenW-50, 10, 40, 40);
        [self.contentView addSubview:self.rightImageView];
    }else if (self.cellWithView.chosenFoods!=NULL){
       // DLog(@"****%ld***%@",self.cellWithView.chosenFoods.count,[NSNull class]);
        for (UIView*view in self.contentView.subviews) {
            [view removeFromSuperview];
        }
        self.foodView.chosenFoods=[NSMutableArray arrayWithArray:self.cellWithView.chosenFoods];
        [self.foodView reload];
        [self.contentView addSubview:self.foodView];
    }else if (self.cellWithView.incSubfoodprop){
        for (UIView*view in self.contentView.subviews) {
            [view removeFromSuperview];
        }
        [self.contentView addSubview:self.subfoodView];
    }
    else{
        [self.label removeFromSuperview];
        [self.foodView removeFromSuperview];
        [self.textField removeFromSuperview];
        [self.imageView removeFromSuperview];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)TextChange:(UITextField*)textField{
    self.cellWithView.text=textField.text;
    if ([self.delegate respondsToSelector:@selector(TextCellEditing:)]) {
        [self.delegate TextCellEditing:self];
    }
}

-(NSString*)stringFromSubfood{
    NSArray*subfoodArray=[ShopSubFood bg_findAll:nil];
    NSString*result=@",";
    if (self.cellWithView.prop) {
        for (int i=0; i<subfoodArray.count; i++) {
            ShopSubFood*subfood=subfoodArray[i];
            if ((self.cellWithView.prop&subfood.dwSFID)==subfood.dwSFID) {
                result=[result stringByAppendingFormat:@"%@,",subfood.szName];
            }
        }
        return [result substringToIndex:result.length-1];
    }else{
        return @"编辑";
    }
}

-(NSString*)stringFromFlavorProp{
    NSArray*array=[ShopFlavor bg_findAll:nil];
    NSString*str=@",";
    if (self.cellWithView.prop) {
        for (int i=0; i<array.count; i++) {
            ShopFlavor*flavor=array[i];
            if ((self.cellWithView.prop&flavor.dwFVID)==flavor.dwFVID) {
                [str stringByAppendingFormat:@"%@,",flavor.szName];
            }
        }
        return [str substringToIndex:str.length-1];
    }else{
        return @"编辑";
    }
}
-(NSString*)stringFromCookWayProp{

    NSArray*array=[ShopCookway bg_findAll:nil];
    NSString*str=@",";
    if (self.cellWithView.prop) {
        for (int i=0; i<array.count; i++) {
            ShopCookway*cookway=array[i];
            if ((self.cellWithView.prop&cookway.dwCWID)==cookway.dwCWID) {
                [str stringByAppendingFormat:@"%@,",cookway.szName];
            }
        }
        return [str substringToIndex:str.length-1];
    }else{
        return @"编辑";
    }
    
}

-(UILabel *)label{
    if (!_label) {
        _label=[[UILabel alloc]init];
    }
    return _label;
}
-(UITextField *)textField{
    if (!_textField) {
        _textField=[[UITextField alloc]init];
    }
    return _textField;
}
-(UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView=[[UIImageView alloc]init];
    }
    return _rightImageView;
}
-(ChosenFoodView *)foodView{
    if (!_foodView) {
        _foodView=[[ChosenFoodView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
        _foodView.delegate=self;
    }
    return _foodView;
}
-(ChoseSubFoodView *)subfoodView{
    if (!_subfoodView) {
        _subfoodView=[[ChoseSubFoodView alloc]initWithFrame:CGRectMake(60, 0, kScreenW-60, 120) incSubfood:self.cellWithView.incSubfoodprop withSubfood:self.cellWithView.subfoodprop];
        _subfoodView.delegate=self;
    }
    return _subfoodView;
}
-(void)ChosenFoodViewBtnClick:(UIButton *)button withChosenFoods:(NSMutableArray *)chosenFoods{
    if ([self.delegate respondsToSelector:@selector(DeleteChosenFood:)]) {
        [self.delegate DeleteChosenFood:chosenFoods];
    }
}
-(void)ChoseSubFoodViewBtnClick:(UIButton *)button withincSubfood:(NSInteger)incSubfood{

    if ([self.delegate respondsToSelector:@selector(reloadTotalPrice:)]) {
        [self.delegate reloadTotalPrice:incSubfood];
    }
}
@end
