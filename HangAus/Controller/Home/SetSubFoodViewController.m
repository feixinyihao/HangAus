//
//  SetSubFoodViewController.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/23.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "SetSubFoodViewController.h"
#import "DataBase.h"
#import "SubFood.h"
@interface SetSubFoodViewController ()
@property(nonatomic,strong)NSArray*subFoodArray;
@property(nonatomic,strong)NSMutableArray*isSelectedArray;
@property(nonatomic,strong)NSMutableDictionary*propDict;
@end

@implementation SetSubFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"可选配菜";
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.subFoodArray=[[DataBase sharedDataBase]getAllSubFood];
    [self setupData];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
}

-(void)save{
    [self .navigationController popViewControllerAnimated:YES];
    if (self.VCBlock){
        self.VCBlock(self.propDict);
        
    }
}
-(void)setupData{
    
    for (int i=1; i<=pow(2, self.subFoodArray.count); i++) {
        if (((i-1)&i)==0) {
            if ((self.subFoodProp&i)==i) {
                [self.isSelectedArray addObject:[NSNumber numberWithBool:YES]];
            }else{
                [self.isSelectedArray addObject:[NSNumber numberWithBool:NO]];
            }
        }
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.subFoodArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    SubFood*subfood=self.subFoodArray[indexPath.row];
    cell.textLabel.text=subfood.szName;
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
        self.subFoodProp=self.subFoodProp-pow(2, indexPath.row);
        [self.propDict setObject:@(self.subFoodProp) forKey:@"prop"];
    }else{
        self.subFoodProp=self.subFoodProp+pow(2, indexPath.row);
        [self.propDict setObject:@(self.subFoodProp) forKey:@"prop"];
    }
    DLog(@"%ld",self.subFoodProp);
}
-(NSArray *)subFoodArray{
    if (!_subFoodArray) {
        _subFoodArray=[NSArray array];
    }
    return _subFoodArray;
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
        [_propDict setObject:@(self.subFoodProp) forKey:@"prop"];
    }
    return _propDict;
}
@end
