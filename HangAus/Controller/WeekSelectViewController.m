//
//  WeekSelectViewController.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/16.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "WeekSelectViewController.h"

@interface WeekSelectViewController ()
@property(nonatomic,strong)NSArray*weekArr;
@property(nonatomic,strong)NSMutableArray*selWeekArray;
@end

@implementation WeekSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.weekArr=@[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
}
-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)save{
    
    if ([self.delegate respondsToSelector:@selector(WeekSelectViewControllerDidSave:)]) {
        [self.delegate WeekSelectViewControllerDidSave:self.selWeekArray];
        
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.weekArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    cell.textLabel.text=self.weekArr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryView) {
        [self.selWeekArray removeObject:self.weekArr[indexPath.row]];
    }else{
        [self.selWeekArray addObject:self.weekArr[indexPath.row]];
    }
    cell.accessoryView=cell.accessoryView?nil:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yes"]];
}
-(NSMutableArray *)selWeekArray{
    if (!_selWeekArray) {
        _selWeekArray=[NSMutableArray array];
    }
    return _selWeekArray;
}

@end
