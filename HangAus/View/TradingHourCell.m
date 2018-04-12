//
//  TradingHourCell.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/16.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "TradingHourCell.h"
#import "TradingHour.h"
@interface TradingHourCell()
@property(nonatomic,strong)UIButton*startDayBtn;
@property(nonatomic,strong)UIButton*endDayBtn;
@property(nonatomic,strong)UIButton*startTimeBtn;
@property(nonatomic,strong)UIButton*endTimeBtn;
@property(nonatomic,strong)UIView*L1;
@property(nonatomic,strong)UIView*L2;
@end
@implementation TradingHourCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(TradingHourCell*)initWithTableView:(UITableView*)tableView{
    static NSString* ID=@"cell";
    TradingHourCell* cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[TradingHourCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)setTradingHour:(TradingHour *)tradingHour{
    _tradingHour=tradingHour;
    [self setupView];
}
-(void)setupView{
    NSArray*weekArray=[NSArray arrayWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日", nil];
    if (self.tradingHour.dwStartDay<7&&self.tradingHour.dwEndDay<7) {
        [self.startDayBtn setTitle:weekArray[self.tradingHour.dwStartDay] forState:UIControlStateNormal];
        [self.startDayBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.startDayBtn.tag=1000;
        self.startDayBtn.frame=CGRectMake(15, 10, 40, 30);
        [self.startDayBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.startDayBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.startDayBtn];
        
        self.L1.frame=CGRectMake(65, 24, 10, 2);
        self.L1.backgroundColor=[UIColor grayColor];
        [self.contentView addSubview:self.L1];
        
        [self.endDayBtn setTitle:weekArray[self.tradingHour.dwEndDay] forState:UIControlStateNormal];
        [self.endDayBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.endDayBtn.tag=2000;
        self.endDayBtn.frame=CGRectMake(85, 10, 40, 30);
        [self.endDayBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.endDayBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.endDayBtn];
        
        self.startTimeBtn.frame=CGRectMake(kScreenW-145, 10, 50, 30);
        NSString*startTimeTitle=[NSString stringWithFormat:@"%ld:%ld",self.tradingHour.dwBeginTime/100,self.tradingHour.dwBeginTime%100];
        if (self.tradingHour.dwBeginTime%100==0) {
            startTimeTitle=[NSString stringWithFormat:@"%ld:%ld0",self.tradingHour.dwBeginTime/100,self.tradingHour.dwBeginTime%100];
        }
        [self.startTimeBtn setTitle:startTimeTitle forState:UIControlStateNormal];
        [self.startTimeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.startTimeBtn.tag=3000;
        [self.startTimeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.startTimeBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.startTimeBtn];
        
        self.L2.frame=CGRectMake(kScreenW-85, 24, 10, 2);
        self.L2.backgroundColor=[UIColor grayColor];
        [self.contentView addSubview:self.L2];
        
        self.endTimeBtn.frame=CGRectMake(kScreenW-60, 10, 50, 30);
        self.endTimeBtn.tag=4000;
         NSString*endTimeTitle=[NSString stringWithFormat:@"%ld:%ld",self.tradingHour.dwEndTime/100,self.tradingHour.dwEndTime%100];
        if (self.tradingHour.dwEndTime%100==0) {
            endTimeTitle=[NSString stringWithFormat:@"%ld:%ld0",self.tradingHour.dwEndTime/100,self.tradingHour.dwEndTime%100];
        }
       
        [self.endTimeBtn setTitle:endTimeTitle forState:UIControlStateNormal];
        [self.endTimeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.endTimeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.endTimeBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.endTimeBtn];
        
    }
   
    
    
}

-(void)btnClick:(UIButton*)button{
    if ([self.delegate respondsToSelector:@selector(TradingHourCellBtnClick:withCell:)]) {
        [self.delegate TradingHourCellBtnClick:button withCell:self];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UIButton *)startDayBtn{
    if (!_startDayBtn) {
        _startDayBtn=[[UIButton alloc]init];
    }
    return _startDayBtn;
}
-(UIButton *)endDayBtn{
    if (!_endDayBtn) {
        _endDayBtn=[[UIButton alloc]init];
    }
    return _endDayBtn;
}
-(UIButton *)startTimeBtn{
    if (!_startTimeBtn) {
        _startTimeBtn=[[UIButton alloc]init];
    }
    return _startTimeBtn;
}
-(UIButton *)endTimeBtn{
    if (!_endTimeBtn) {
        _endTimeBtn=[[UIButton alloc]init];
    }
    return _endTimeBtn;
}
-(UIView *)L1{
    if (!_L1) {
        _L1=[[UIView alloc]init];
    }
    return _L1;
}
-(UIView *)L2{
    if (!_L2) {
        _L2=[[UIView alloc]init];
    }
    return _L2;
}
@end
