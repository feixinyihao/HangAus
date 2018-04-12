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
#import "DataBase.h"
#import "SubFood.h"
#import "UniHttpTool.h"
#import <MJExtension.h>
#import "ChoseSubFoodView.h"
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
                     self.detailTextLabel.text=[self stringFromFSubFoodProp];
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
            [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.cellWithView.imagePath]];
        }else{
            [self.rightImageView setImage:[UIImage imageNamed:self.cellWithView.imageName]];
        }
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

-(void)stringFromFSubFoodPropcomplete:(void (^)(NSString* str))complete{
    [UniHttpTool getwithparameters:nil option:GetSubFood success:^(id json) {
        if ([json[@"ret"]integerValue]==0) {
            NSMutableArray*temp=[NSMutableArray array];
            for (NSDictionary*dict in json[@"data"]) {
                SubFood*subfood=[SubFood mj_objectWithKeyValues:dict];
                [[DataBase sharedDataBase]addSubFood:subfood];
                [temp addObject:subfood];
            }
            NSString*str=@"";
            if (self.cellWithView.prop) {
                for (int i=1; i<=pow(2, temp.count-1); i++) {
                    if (((i-1)&i)==0) {
                        if ((self.cellWithView.prop&i)==i) {
                            NSInteger x=log2(i);
                            SubFood*subFood=temp[x];
                            str=[str stringByAppendingFormat:@"%@,",subFood.szName];
                            
                        }
                    }
                }
                if (complete) {
                    complete([str substringToIndex:str.length-1]);
                }
            }else{
                complete(@"编辑");
            }
        }
    }];
}
-(NSString*)stringFromFSubFoodProp{
    
    NSArray*subFoodArray=[[DataBase sharedDataBase]getAllSubFood];
    if (subFoodArray.count<1) {
        [self stringFromFSubFoodPropcomplete:^(NSString *str) {
             self.detailTextLabel.text=str;
        }];
        return @"";
    }else{
        NSString*str=@"";
        if (self.cellWithView.prop) {
            for (int i=0; i<subFoodArray.count; i++) {
                SubFood*subfood=subFoodArray[i];
                if ((self.cellWithView.prop&subfood.dwSFID)==subfood.dwSFID) {
                    str=[str stringByAppendingString:[NSString stringWithFormat:@"%@,",subfood.szName]];
                }
            }
            return [str substringToIndex:str.length-1];
        }else{
            return @"编辑";
        }
        
    }
    
   
}
-(NSString*)stringFromFlavorProp{
    NSArray*array=@[@"Cook Level",@"In Batter",@"Crumbed",@"Salt",@"Chicken Salt",@"Vinega",@"Sauce",@"Flour"];
    NSString*str=@"";
    if (self.cellWithView.prop) {
        for (int i=1; i<=128; i++) {
            if (((i-1)&i)==0) {
                if ((self.cellWithView.prop&i)==i) {
                    NSInteger x=log2(i);
                    str=[str stringByAppendingFormat:@"%@,",array[x]];
                   
                }
            }
        }
        return [str substringToIndex:str.length-1];
    }else{
        return @"编辑";
    }
}
-(NSString*)stringFromCookWayProp{
    NSString*str=@"";
    if (self.cellWithView.prop) {
        if ((self.cellWithView.prop&1)==1) {
            str=[str stringByAppendingString:@"Fried,"];
        }
        if ((self.cellWithView.prop&2)==2) {
            str=[str stringByAppendingString:@"Grilled,"];
        }
        if ((self.cellWithView.prop&4)==4) {
            str=[str stringByAppendingString:@"Steamed,"];
        }
        if ((self.cellWithView.prop&8)==8) {
            str=[str stringByAppendingString:@"Grilled,"];
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
    DLog(@"%ld",incSubfood);
    if ([self.delegate respondsToSelector:@selector(reloadTotalPrice:)]) {
        [self.delegate reloadTotalPrice:incSubfood];
    }
}
@end
