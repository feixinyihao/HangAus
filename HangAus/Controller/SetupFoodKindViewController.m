//
//  SetupFoodKindViewController.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/2.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "SetupFoodKindViewController.h"
#import "ChangeBalanceViewController.h"
#import "UniHttpTool.h"
#import "ShowGroup.h"
#import <MJExtension.h>
#import "MBProgressHUD+MJ.h"
@interface SetupFoodKindViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView*tableView;

@property(nonatomic,strong)NSMutableArray*showGroupArray;
@property(nonatomic,strong)NSMutableArray*selectedArray;
@end

@implementation SetupFoodKindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"食物类别";
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title = @"返回";
    self.navigationItem.backBarButtonItem = backbutton;
    
    UITableView*tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-84) style:UITableViewStylePlain];
    tableView.tableFooterView=[[UIView alloc]init];
    self.tableView=tableView;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.editing=YES;
    [self.view addSubview:self.tableView];
    [self setupData];
    
}

-(void)setupData{
    
    [UniHttpTool getwithparameters:nil option:GetShowGroup success:^(id json) {

        if ([json[@"ret"] integerValue]==0) {
            NSArray*dataArr=json[@"data"];
            for (NSDictionary*dict in dataArr) {
                ShowGroup*showGroup=[ShowGroup mj_objectWithKeyValues:dict];
                [self.showGroupArray addObject:showGroup];
                [self.selectedArray addObject:showGroup];
            }
            [self.tableView reloadData];
            [self setupUI];
            for (int i=0; i<self.showGroupArray.count; i++) {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
                
            }
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupUI{
    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(10, kScreenH-64-50, kScreenW-20, 40)];
    [btn setTitle:@"保存并下一步" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:KmainColor];
    btn.layer.cornerRadius=5;
    [self.view addSubview:btn];
    /*底部
    UILabel*progressL=[[UILabel alloc]initWithFrame:CGRectMake(0, kScreenH-64-20, kScreenW, 20)];
    progressL.font=[UIFont systemFontOfSize:16];
    progressL.textAlignment=NSTextAlignmentCenter;
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:@"修改密码—协议—门店信息—菜单类别—菜品信息"];
    NSRange blueRange = NSMakeRange([[noteStr string] rangeOfString:@"修改密码—"].location, [[noteStr string] rangeOfString:@"修改密码—协议—门店信息—菜单类别—"].length);
    //需要设置的位置
    [noteStr addAttribute:NSForegroundColorAttributeName value:jpBlue range:blueRange];
    //设置颜色
    [progressL setAttributedText:noteStr];
    
    [self.view addSubview:progressL];
     */
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showGroupArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"foodkind"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"foodkind"];
    }
    ShowGroup*showGroup=self.showGroupArray[indexPath.row];
    cell.textLabel.text=showGroup.szGroupName;

    return cell;
}
-(void)next{
    if (self.selectedArray.count==0) {
        [MBProgressHUD showError:@"请选择类型初始化"];
    }else{
        ChangeBalanceViewController*setupfood=[[ChangeBalanceViewController alloc]init];
        setupfood.selGroupArray=self.selectedArray;
        [self.navigationController pushViewController:setupfood animated:YES];
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    ShowGroup*showGroup=self.showGroupArray[indexPath.row];
    [self.selectedArray addObject:showGroup];
    DLog(@"%@",self.selectedArray);
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

    ShowGroup*showGroup=self.showGroupArray[indexPath.row];
    [self.selectedArray removeObject:showGroup];
    DLog(@"%@",self.selectedArray);
}
-(NSMutableArray *)showGroupArray{
    if (!_showGroupArray) {
        _showGroupArray=[NSMutableArray array];
    }
    return _showGroupArray;
}
-(NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray=[NSMutableArray array];
    }
    return _selectedArray;
}
@end
