//
//  EditFoodKindViewController.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/27.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "EditFoodKindPropViewController.h"
#import "CellWithView.h"
#import "WithTextCell.h"
#import "FoodKind.h"
#import <MJExtension.h>
#import "SetFlavorViewController.h"
#import "SetCookWayViewController.h"
#import "SetSubFoodViewController.h"
#import "UniHttpTool.h"
#import "MBProgressHUD+MJ.h"
@interface EditFoodKindPropViewController ()
@property(nonatomic,strong)NSArray*cellModels;
@end

@implementation EditFoodKindPropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
  
}
-(void)save{
    FoodKind*foodkind=self.foodkind;
    for (int i=0; i<self.cellModels.count; i++) {
        CellWithView*model=self.cellModels[i];
        if (i==1) {
            foodkind.dwCookWayProp=model.prop;
        }else if (i==2){
            foodkind.dwFlavorProp=model.prop;
        }else if (i==3){
            foodkind.dwSubFoodProp=model.prop;
        }
    }
    NSDictionary*parm=foodkind.mj_keyValues;
    [UniHttpTool getwithparameters:parm option:SetFoodkind success:^(id json) {
        if ([json[@"ret"]integerValue]==0) {
            [MBProgressHUD showSuccess:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
           
        }
    }];
}
-(void)setupData{

    NSDictionary*parm1=@{@"leftTitle":@"kindname",
                         @"viewClass":@"UILabel",
                         @"text":self.foodkind.szFoodKindName};
    NSDictionary*parm2=@{@"leftTitle":@"烹饪方法:",
                         @"prop":@(self.foodkind.dwCookWayProp),
                         @"propNum":@"4",@"viewClass":@"UILabel"};
    NSDictionary*parm3=@{@"leftTitle":@"个人口味:",
                         @"prop":@(self.foodkind.dwFlavorProp),
                         @"propNum":@"2",@"viewClass":@"UILabel"};
    NSDictionary*parm4=@{@"leftTitle":@"可选配料:",@"prop":  @(self.foodkind.dwSubFoodProp),@"propNum":@"1",@"viewClass":@"UILabel"};
    NSArray*temp=@[parm1,parm2,parm3,parm4];
    NSMutableArray*tempArray=[NSMutableArray array];
    for (int i=0; i<temp.count; i++) {
        CellWithView*cellModel=[CellWithView mj_objectWithKeyValues:temp[i]];
        [tempArray addObject:cellModel];
    }
    self.cellModels=tempArray;


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

    return self.cellModels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WithTextCell*cell=[WithTextCell initWithTableView:tableView];
    CellWithView*cellModel=self.cellModels[indexPath.row];
    cell.cellWithView=cellModel;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CellWithView*model=self.cellModels[indexPath.row];
    switch (indexPath.row) {
        case 1:{
            SetCookWayViewController*cook=[[SetCookWayViewController alloc]init];
            cook.cookWayProp=model.prop;
            cook.VCBlock = ^(NSDictionary *vegDic) {
                DLog(@"%@",vegDic);
                model.prop=[vegDic[@"prop"] integerValue];
                NSArray<NSIndexPath*>*indexPathArray=@[indexPath];
                [tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
                
            };
            [self.navigationController pushViewController:cook animated:YES];
        }
            break;
        case 2:{
            SetFlavorViewController*flavor=[[SetFlavorViewController alloc]init];
            flavor.flavorProp=model.prop;
            flavor.VCBlock = ^(NSDictionary *vegDic) {
                DLog(@"%@",vegDic);
                model.prop=[vegDic[@"prop"] integerValue];
                NSArray<NSIndexPath*>*indexPathArray=@[indexPath];
                [tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
            };
            [self.navigationController pushViewController:flavor animated:YES];
            
        }
            break;
        case 3:{
            SetSubFoodViewController*subfood=[[SetSubFoodViewController alloc]init];
            subfood.subFoodProp=model.prop;
            subfood.VCBlock = ^(NSDictionary *vegDic) {
                DLog(@"%@",vegDic);
                model.prop=[vegDic[@"prop"] integerValue];
                NSArray<NSIndexPath*>*indexPathArray=@[indexPath];
                [tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
            };
            [self.navigationController pushViewController:subfood animated:YES];
        }
            break;
            
        default:
            break;
    }
}

-(NSArray *)cellModels{
    if (!_cellModels) {
        _cellModels=[NSArray array];
    }
    return _cellModels;
}
@end
