//
//  SetLanTableViewController.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/2/27.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "SetLanTableViewController.h"
#import "Language.h"
#import "CommonFunc.h"
#import "MainViewController.h"
#import "MBProgressHUD+MJ.h"
@interface SetLanTableViewController ()
@property(nonatomic,weak)UITableViewCell*selectedCell;
@end

@implementation SetLanTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置语言";
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
}

-(void)finish{
    NSString* doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString* file=[doc stringByAppendingString:@"/language.data"];
    
    NSString*value=@"";
    NSString*desc=self.selectedCell.textLabel.text;
    NSString*code=@"";
    if ([desc isEqualToString:@"English"]) {
        value=@"0";
        code=@"en";
    }else if ([desc isEqualToString:@"简体中文"]){
        value=@"1";
        code=@"zh-Hans";
    }else if ([desc isEqualToString:@"繁体中文"]){
        value=@"2";
        code=@"zh-Hant";
    }
    NSDictionary*dic=@{@"value":value,@"code":code,@"desc":desc};
    Language * lan=[[Language alloc]initWithDic:dic];
    [NSKeyedArchiver archiveRootObject:lan toFile:file];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     MainViewController*main=[[MainViewController alloc]init];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        main.selectedIndex=1;
        self.view.window.rootViewController=main;
        
    });
    
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

    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"lan"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lan"];
    }
    NSString* doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString* file=[doc stringByAppendingString:@"/language.data"];
    Language * lan=[NSKeyedUnarchiver unarchiveObjectWithFile:file];
    if (lan) {
        if (lan.value==indexPath.row) {
            cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yes"]];
            self.selectedCell=cell;
        }
       
    }
   
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text=@"English";
            break;
        case 1:
            cell.textLabel.text=@"简体中文";
            break;
        case 2:
            cell.textLabel.text=@"繁体中文";
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.selectedCell) {
        self.selectedCell.accessoryView=nil;
    }
    cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yes"]];
    self.selectedCell=cell;
}


@end
