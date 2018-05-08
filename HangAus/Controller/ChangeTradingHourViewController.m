//
//  ChangeTradingHourViewController.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/16.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "ChangeTradingHourViewController.h"
#import "UniHttpTool.h"
#import "StaffInfo.h"
#import "WeekSelectViewController.h"
#import "BaseNavigationController.h"
#import "TradingHour.h"
#import <MJExtension.h>
#import "TradingHourCell.h"
#import "MBProgressHUD+MJ.h"
#import <XXPickerView.h>
#import "MBProgressHUD+MJ.h"
@interface ChangeTradingHourViewController ()<WeekSelectViewControllerDelegate,TradingHourCellDelegate,XXPickerViewDelegate>


@property(nonatomic,strong)NSMutableArray*tradingHourArray;

@property(nonatomic,weak)UIButton*saveBtn;
@end

@implementation ChangeTradingHourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.title=@"修改营业时间";

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"plus"] style:UIBarButtonItemStyleDone target:self action:@selector(addHour)];
 
    UIButton*saveBtn=[[UIButton alloc]init];
    saveBtn.layer.masksToBounds=YES;
    saveBtn.layer.cornerRadius=5;
    [saveBtn setTitle:@"保存修改" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setBackgroundColor:KmainColor];
    self.saveBtn=saveBtn;
    [self.view addSubview:self.saveBtn];
    [self setupData];
    
}

-(void)setupData{
    [MBProgressHUD showHUDAddedTo:nil animated:YES];
    [UniHttpTool getwithparameters:nil option:GetShopTradinghour success:^(id json) {
        for (NSDictionary*dict in json[@"data"]) {
            TradingHour*th=[TradingHour mj_objectWithKeyValues:dict];
            [self.tradingHourArray addObject:th];
        }
        [self.tableView reloadData];
        self.saveBtn.frame=CGRectMake(20, self.tradingHourArray.count*50+50, kScreenW-40, 50);
        [MBProgressHUD hideHUDForView:nil animated:YES];
    }];
    
   

   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)save{
    
    
    NSDictionary*parm=@{@"dwShopID":@"1",@"TradingHour":[CommonFunc returnStringWithArray:self.tradingHourArray]};
    [UniHttpTool postwithparameters:parm option:SetShopTradinghour success:^(id json) {
        if ([json[@"ret"] integerValue]==0) {
            [MBProgressHUD showText:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.tradingHourArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TradingHour*tradingHour=self.tradingHourArray[indexPath.row];
    TradingHourCell*cell=[TradingHourCell initWithTableView:tableView];
    cell.delegate=self;
    cell.tradingHour=tradingHour;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*view=[[UIView alloc]init];
    view.backgroundColor=KColor(240, 240, 240);
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenW, 30)];
    label.font=[UIFont systemFontOfSize:12];
    label.textColor=[UIColor lightGrayColor];
    label.text=@"自定义营业时间";
    [view addSubview:label];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tradingHourArray.count==1) {
        [MBProgressHUD showText:@"至少保留一条营业时间"];
    }else{
        NSMutableArray*temp=[NSMutableArray arrayWithArray:self.tradingHourArray];
        [temp removeObjectAtIndex:indexPath.row];
        NSDictionary*parm=@{@"dwShopID":@"1",@"TradingHour":[CommonFunc returnStringWithArray:temp]};
        [UniHttpTool postwithparameters:parm option:SetShopTradinghour success:^(id json) {
            if ([json[@"ret"] integerValue]==0) {
                // 修改模型
                [self.tradingHourArray removeObjectAtIndex:indexPath.row];
                // 刷新表格
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                [UIView animateWithDuration:0.25 animations:^{
                    CGRect rect=self.saveBtn.frame;
                    self.saveBtn.frame=CGRectMake(rect.origin.x, rect.origin.y-50, rect.size.width, rect.size.height);
                }];
               
            }
        }];
       
    }
   
   
}


-(void)TradingHourCellBtnClick:(UIButton *)button withCell:(TradingHourCell *)cell{
    NSIndexPath *indexPath=[self.tableView indexPathForCell:cell];
    XXPickerView*picker=[[XXPickerView alloc]initWithTitle:@"" delegate:self];
    picker.toolbarTintColor=KmainColor;
    picker.tag=button.tag+indexPath.row;
    picker.toolbarButtonColor=[UIColor whiteColor];
   
    if (button.tag==3000||button.tag==4000) {
        [picker setTitlesForComponents:@[@[@"0点",@"1点", @"2点", @"3点", @"4点", @"5点",@"6点",@"7点",@"8点",@"9点",@"10点",@"11点",@"12点",@"13点", @"14点", @"15点", @"16点", @"17点",@"18点",@"19点",@"20点",@"21点",@"22点",@"23点"],
                                         @[@"00分", @"10分", @"20分", @"30分", @"40分",@"50分"]]];
        if (button.tag==3000) {
            [picker selectIndexes:@[@(cell.tradingHour.dwBeginTime/100),@(cell.tradingHour.dwBeginTime%100/10)] animated:YES];
        }else if (button.tag==4000){
            [picker selectIndexes:@[@(cell.tradingHour.dwEndTime/100),@(cell.tradingHour.dwEndTime%100/10)] animated:YES];
        }
       
    }else{
        [picker setTitlesForComponents:@[@[@"周一",@"周二", @"周三", @"周四", @"周五", @"周六",@"周日"]
                                         ]];
        if (button.tag==1000) {
            [picker selectIndexes:@[@(cell.tradingHour.dwStartDay)] animated:YES];
        }else if (button.tag==2000){
            [picker selectIndexes:@[@(cell.tradingHour.dwEndDay)] animated:YES];
        }
    }
    
    [picker show];
}
-(void)addHour{
//    WeekSelectViewController*week=[[WeekSelectViewController alloc]init];
//    week.delegate=self;
//    BaseNavigationController*nav=[[BaseNavigationController alloc]initWithRootViewController:week];
//    [self presentViewController:nav animated:YES completion:nil];
    
    NSMutableArray*tempArray=[[NSMutableArray alloc]initWithObjects:@(0),@(1),@(2),@(3),@(4),@(5),@(6), nil];
    for (int i=0; i<self.tradingHourArray.count; i++) {
        TradingHour*hour=self.tradingHourArray[i];
        
        for (NSInteger j=hour.dwStartDay; j<=hour.dwEndDay; j++) {
            if (tempArray != nil && ![tempArray isKindOfClass:[NSNull class]] && tempArray.count != 0) {
                 [tempArray removeObject:@(j)];
            }
           
        }
    }
    if (tempArray.count==0) {
        [MBProgressHUD showText:@"如要添加，请先修改当前营业时间"];
    }else{
       
        [UIView animateWithDuration:0.25 animations:^{
            TradingHour*tr=[[TradingHour alloc]init];
            tr.dwStartDay=[tempArray[0] integerValue];
            tr.dwEndDay=[tempArray[0] integerValue];
            tr.dwOpenFlag=1;
            tr.dwBeginTime=1000;
            tr.dwEndTime=2000;
            [self.tradingHourArray addObject:tr];
            CGRect rect=self.saveBtn.frame;
            self.saveBtn.frame=CGRectMake(rect.origin.x, rect.origin.y+50, rect.size.width, rect.size.height);
            [self.tableView reloadData];
        }];
    }
    
    
    
}
- (void)xxPickerView:(XXPickerView *)pickerView didSelectTitles:(NSArray *)titles selectedRows:(NSArray *)rows{
    TradingHour*th=self.tradingHourArray[pickerView.tag%1000];
    switch (pickerView.tag/1000) {
        case 1:
            if (th.dwEndDay>=[rows[0] integerValue]) {
                th.dwStartDay=[rows[0] integerValue];
            }else{
                [MBProgressHUD showError:@"结束时间必须大于开始时间"];
            }
           
            break;
        case 2:
            if (th.dwStartDay<=[rows[0] integerValue]) {
                 th.dwEndDay=[rows[0] integerValue];
            }else{
                 [MBProgressHUD showError:@"结束时间必须大于开始时间"];
            }
           
            break;
        case 3:
            if (th.dwEndTime>=([rows[0] integerValue]*100+[rows[1] integerValue]*10)) {
                
                th.dwBeginTime=[rows[0] integerValue]*100+[rows[1] integerValue]*10;
            }else{
                [MBProgressHUD showError:@"结束时间必须大于开始时间"];
            }
           
            break;
        case 4:
            if (th.dwStartDay<=([rows[0] integerValue]*100+[rows[1] integerValue]*10)) {
                th.dwEndTime=[rows[0] integerValue]*100+[rows[1] integerValue]*10;
            }else{
                [MBProgressHUD showError:@"结束时间必须大于开始时间"];
            }
            
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

-(void)WeekSelectViewControllerDidSave:(NSArray *)weekArray{
   
    
}
-(NSMutableArray *)tradingHourArray{
    if (!_tradingHourArray) {
        _tradingHourArray=[NSMutableArray array];
    }
    return _tradingHourArray;
}
@end
