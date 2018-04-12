//
//  SetCookWayViewController.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/25.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "SetCookWayViewController.h"

@interface SetCookWayViewController ()
@property(nonatomic,strong)NSArray*cookWayArray;
@property(nonatomic,strong)NSMutableArray*isSelectedArray;
@property(nonatomic,strong)NSMutableDictionary*propDict;
@end

@implementation SetCookWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cookWayArray=@[@"Fried",@"Grilled",@"Steamed",@"Grilled"];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    [self setupArray];
}
-(void)save{
    [self .navigationController popViewControllerAnimated:YES];
    if (self.VCBlock){
        self.VCBlock(self.propDict);
        
    }
}
-(void)setupArray{
    for (int i=1; i<=pow(2, self.cookWayArray.count); i++) {
        if (((i-1)&i)==0) {
            if ((self.cookWayProp&i)==i) {
                [self.isSelectedArray addObject:[NSNumber numberWithBool:YES]];
            }else{
                [self.isSelectedArray addObject:[NSNumber numberWithBool:NO]];
            }
        }
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cookWayArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text=self.cookWayArray[indexPath.row];
    cell.accessoryView=[self.isSelectedArray[indexPath.row] boolValue]?[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yes"]]:nil;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BOOL isSelected=[self.isSelectedArray[indexPath.row] boolValue];
    [self.isSelectedArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:!isSelected]];
    NSArray<NSIndexPath*>*indexPathArray=@[indexPath];
    [tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    if (isSelected) {
        self.cookWayProp=self.cookWayProp-pow(2, indexPath.row);
        [self.propDict setObject:@(self.cookWayProp) forKey:@"prop"];
    }else{
        self.cookWayProp=self.cookWayProp+pow(2, indexPath.row);
        [self.propDict setObject:@(self.cookWayProp) forKey:@"prop"];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSMutableArray *)isSelectedArray{
    if (!_isSelectedArray) {
        _isSelectedArray=[NSMutableArray array];
    }
    return _isSelectedArray;
}
-(NSMutableDictionary *)propDict{
    if (!_propDict) {
        _propDict=[NSMutableDictionary dictionary];
    }
    return _propDict;
}
@end
