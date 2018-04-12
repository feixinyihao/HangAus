//
//  EditFoodViewController.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/10.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "EditFoodViewController.h"
#import "CellWithView.h"
#import "WithTextCell.h"
#import "ShowFood.h"
#import "ChosenFood.h"
#import "DataBase.h"
#import "ShopSubFood.h"
#import <MJExtension.h>
#import "UniHttpTool.h"
#import "MBProgressHUD+MJ.h"
@interface EditFoodViewController ()<WithTextCellDelegate>
@property(nonatomic,strong)NSArray*cellModelArray;

@property(nonatomic,assign)NSInteger incSubfood;
@end

@implementation EditFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"编辑";
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    [self setupData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupData{
    NSDictionary*parm1=@{@"leftTitle":@"商品名称:",
                         @"viewClass":@"UILabel",
                         @"text": self.showFood.szDispName?self.showFood.szDispName:@""};
    NSDictionary*parm2=@{@"leftTitle":@"上传图片:",
                         @"viewClass":@"UIImageView",
                         @"imageName":@"plus"};
    NSDictionary*parm3=@{@"leftTitle":@"销售价格:",
                         @"viewClass":@"UITextField",
                         @"keyboard":@(1),
                         @"text": [NSString stringWithFormat:@"%.1f0",[self returnPriceFromShowFood:self.showFood isDiscount:YES]/100.0]};
    NSDictionary*parm4=@{@"leftTitle":@"备注:",
                         @"viewClass":@"UITextField",
                         @"text":self.showFood.szMemo?self.showFood.szMemo:@""};
    
    NSDictionary*parm7=@{@"leftTitle":@"总价",
                         @"text": [NSString stringWithFormat:@"%.1f0",
                                   [self returnPriceFromShowFood:self.showFood isDiscount:NO]/100.0],
                         @"viewClass":@"UILabel"};
    NSArray*temp=[NSArray array];
    if (self.showFood.dwShowProp==1&&!self.showFood.dwIncSubFood) {
        temp=@[parm1,parm2,parm3,parm4];
    }else if (self.showFood.dwShowProp==2){
        NSDictionary*parm5=@{@"leftTitle":@"套餐包含食物",
                             @"viewClass":@"UIImageView",
                             @"imageName":@"plus"};
        NSDictionary*parm6=@{@"chosenFoods":self.showFood.ChosenFoods};
        temp=@[parm1,parm2,parm5,parm6,parm3,parm7,parm4];
    }else if (self.showFood.dwIncSubFood){
         NSDictionary*parm8=@{@"leftTitle":@"配菜",
                              @"subfoodprop":@(self.showFood.dwSubFoodProp),
                              @"incSubfoodprop":@(self.showFood.dwIncSubFood)};
         temp=@[parm1,parm2,parm8,parm3,parm7,parm4];
    }
    NSMutableArray*tempArray=[NSMutableArray array];
    for (int i=0; i<temp.count; i++) {
        CellWithView*cell=[CellWithView mj_objectWithKeyValues:temp[i]];
        [tempArray addObject:cell];
    }
    self.cellModelArray=tempArray;
}
-(NSInteger)returnPriceFromShowFood:(ShowFood*)showfood isDiscount:(BOOL)discount{
    //论重量卖
    if (showfood.dwSoldProp==2) {
        if (showfood.dwDefQuantity==0) {
            return discount?showfood.dwUnitPrice-showfood.dwDiscount: showfood.dwUnitPrice;
        }else{
            return discount?showfood.dwUnitPrice*showfood.dwDefQuantity/1000.0-showfood.dwDiscount:showfood.dwUnitPrice*showfood.dwDefQuantity/1000.0;
        }
        //套餐
    }else if (showfood.dwShowProp==2){
        NSInteger total=0;
        for (int i=0; i<showfood.ChosenFoods.count; i++) {
            ChosenFood*chosenfood=showfood.ChosenFoods[i];
            ShowFood*chosenShowfood=[[DataBase sharedDataBase]getShowFoodWithID:chosenfood.dwShowFoodID];
            if (chosenShowfood.dwSoldProp==2) {
                chosenShowfood.dwDefQuantity=chosenfood.dwQuantity;
                total=total+[self returnPriceFromShowFood:chosenShowfood isDiscount:NO];
            }else{
                total=total+[self returnPriceFromShowFood:chosenShowfood isDiscount:NO]*chosenfood.dwQuantity;
            }
            
        }
        return discount?total-showfood.dwDiscount:total;
        //食物包含配料
    }else if (showfood.dwIncSubFood){
        return discount?[self returnTotalPrice:showfood.dwIncSubFood]+showfood.dwUnitPrice-showfood.dwDiscount:[self returnTotalPrice:showfood.dwIncSubFood]+showfood.dwUnitPrice;
    }else{
        return discount?showfood.dwUnitPrice-showfood.dwDiscount:showfood.dwUnitPrice;
    }
}
-(NSInteger)returnTotalPrice:(NSInteger)incSubfood{
    NSArray*subfoodArray=[[DataBase sharedDataBase]getAllShopSubFood];
    NSInteger subPrice=0;
    for (int i=0; i<subfoodArray.count;i++) {
        ShopSubFood*subfood=subfoodArray[i];
        if ((incSubfood&subfood.dwSFID)==subfood.dwSFID) {
            subPrice=subPrice+subfood.dwUnitPrice;
        }
    }
    return subPrice;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellModelArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.showFood.dwIncSubFood) {
        if (indexPath.row==2) {
            return 120;
        }else{
            return 60;
        }
    }else if(self.showFood.dwShowProp==2){
        if (indexPath.row==3) {
            return 120;
        }else{
            return 60;
        }
    }else{
        return 60;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WithTextCell*cell=[WithTextCell initWithTableView:tableView];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.cellWithView=self.cellModelArray[indexPath.row];
    cell.delegate=self;
    return cell;
}

-(void)reloadTotalPrice:(NSInteger)incSubfood{
    CellWithView*model=self.cellModelArray[4];
    model.text=[NSString stringWithFormat:@"%.1f0",[self returnTotalPrice:incSubfood]/100.0];
    NSIndexPath*indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
    NSArray<NSIndexPath*>*indexPathArray=@[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    //DLog(@"--%ld--",incSubfood);
    self.incSubfood=incSubfood;
}
-(void)DeleteChosenFood:(NSMutableArray *)chosenfoods{
    
    
    CellWithView*cellmodel=self.cellModelArray[3];
    cellmodel.chosenFoods=chosenfoods;
    NSInteger total=0;
    for (int i=0; i<chosenfoods.count; i++) {
        ChosenFood*chosenfood=chosenfoods[i];
        ShowFood*chosenShowfood=[[DataBase sharedDataBase]getShowFoodWithID:chosenfood.dwShowFoodID];
        if (chosenShowfood.dwSoldProp==2) {
            chosenShowfood.dwDefQuantity=chosenfood.dwQuantity;
            total=total+[self returnPriceFromShowFood:chosenShowfood isDiscount:NO];
        }else{
            total=total+[self returnPriceFromShowFood:chosenShowfood isDiscount:NO]*chosenfood.dwQuantity;
        }
        
    }
     CellWithView*cellmodel5=self.cellModelArray[5];
    cellmodel5.text=[NSString stringWithFormat:@"%.1f0",total/100.0];
    NSIndexPath*indexpath=[NSIndexPath indexPathForRow:5 inSection:0];
    NSArray<NSIndexPath*>*indexPathArray=@[indexpath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
}

-(void)save{
    NSDictionary*parm=self.showFood.mj_keyValues;
    NSInteger sellPrice=0;
    NSInteger total=0;
    if (self.showFood.dwIncSubFood) {
       
        CellWithView*model=self.cellModelArray[3];
        sellPrice=[model.text floatValue]*100;
        CellWithView*model2=self.cellModelArray[4];
        total=[model2.text floatValue]*100;
        [parm setValue:@(total-sellPrice) forKey:@"dwDiscount"];
        [parm setValue:@(sellPrice) forKey:@"dwMinPrice"];
        if (self.incSubfood) {
            [parm setValue:@(self.incSubfood) forKey:@"dwIncSubFood"];
        }
        if (sellPrice>total) {
            [MBProgressHUD showError:@"销售价格不能大于总价"];
        }else{
            [UniHttpTool postwithparameters:parm option:SetShowFood success:^(id json) {
                
                NSDictionary*dict=json[@"data"];
                [MBProgressHUD showText:@"保存成功"];
                self.showFood.dwUnitPrice=[dict[@"dwUnitPrice"] integerValue];
                self.showFood.dwDiscount=[dict[@"dwDiscount"] integerValue];
                self.showFood.dwMinPrice=[dict[@"dwMinPrice"] integerValue];
                self.showFood.dwIncSubFood=[dict[@"dwIncSubFood"] integerValue];
                [self.navigationController popViewControllerAnimated:YES];
    
            }];
        }
       //套餐
    }else if (self.showFood.dwShowProp==2){
        CellWithView*model=self.cellModelArray[3];
        [parm setValue:[CommonFunc returnStringWithArray:model.chosenFoods] forKey:@"ChosenFoods"];
        
        CellWithView*model4=self.cellModelArray[4];
        CellWithView*model5=self.cellModelArray[5];
        sellPrice=[model4.text floatValue]*100;
        total=[model5.text floatValue]*100;
        DLog(@"%ld--%ld",total,sellPrice);
        [parm setValue:@(total-sellPrice) forKey:@"dwDiscount"];
        [parm setValue:@(sellPrice) forKey:@"dwMinPrice"];
       
        if (sellPrice>total) {
             [MBProgressHUD showError:@"销售价格不能大于总价"];
        }else{
            DLog(@"%@",parm);
            [UniHttpTool postwithparameters:parm option:SetShowFood success:^(id json) {

                NSDictionary*dict=json[@"data"];
                NSMutableArray*temp=[NSMutableArray array];
                for (NSDictionary*dic in dict[@"ChosenFoods"]) {
                    ChosenFood*chosenfood=[ChosenFood mj_objectWithKeyValues:dic];
                    [temp addObject:chosenfood];
                }
                [MBProgressHUD showText:@"保存成功"];
                self.showFood.dwUnitPrice=[dict[@"dwUnitPrice"] integerValue];
                self.showFood.dwDiscount=[dict[@"dwDiscount"] integerValue];
                self.showFood.dwMinPrice=[dict[@"dwMinPrice"] integerValue];
                self.showFood.ChosenFoods=temp;
                [self.navigationController popViewControllerAnimated:YES];

            }];
        }
        //还有论斤的需要考虑
    }else if (self.showFood.dwSoldProp==2){
        
    }
    else{
        CellWithView*model=self.cellModelArray[2];
        sellPrice=[model.text floatValue]*100;
        [parm setValue:@(sellPrice) forKey:@"dwUnitPrice"];
        [UniHttpTool getwithparameters:parm option:SetSoldFood success:^(id json) {
            NSDictionary*dict=json[@"data"];
            self.showFood.dwUnitPrice=[dict[@"dwUnitPrice"] integerValue];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}
@end
