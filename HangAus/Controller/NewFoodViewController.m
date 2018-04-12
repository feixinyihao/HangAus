//
//  NewFoodViewController.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/23.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "NewFoodViewController.h"
#import "CellWithView.h"
#import "WithTextCell.h"
#import <MJExtension.h>
#import "ShowFood.h"
#import "UniHttpTool.h"
#import "SubFood.h"
#import "DataBase.h"
#import "ChosenFood.h"
#import <XXPickerView.h>
#import "ShowGroup.h"
#import "MBProgressHUD+MJ.h"
#import "SetSubFoodViewController.h"
#import "SetFlavorViewController.h"
#import "SetCookWayViewController.h"
#import "SoldFood.h"
#import "ShopSubFood.h"
@interface NewFoodViewController ()<XXPickerViewDelegate,WithTextCellDelegate>
@property(nonatomic,strong)NSMutableArray*modelArray;
@property(nonatomic,strong)NSArray*lastSelRows;
/**
 pick显示的分类名称数组
 */
@property(nonatomic,strong)NSArray*groupNameArray;
/**
 pick显示的食物名称数组
 */
@property(nonatomic,strong)NSArray*showFoodNameArray;

/**
 showfood数组
 */
@property(nonatomic,strong)NSArray*showFoodArray;


/**
 showgroup数组
 */
@property(nonatomic,strong)NSMutableArray*showGroupArray;

@property(nonatomic,assign)NSInteger balance;

@property(nonatomic,assign)NSInteger incSubfood;

@end

@implementation NewFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"编辑商品";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    self.tableView.tableFooterView=[[UIView alloc]init];
    [self setupArray];
    [self setupData];
    DLog(@"%@",[self returnPriceFromChosenFood:self.showFood.ChosenFoods]);
  
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}

-(void)save{
    NSMutableDictionary*parm=self.showFood.mj_keyValues;
    NSInteger dwMinPrice=0;
    NSInteger totalPrice=0;
    NSInteger sellPrice=0;
    for (int i=0; i<self.modelArray.count; i++) {
         CellWithView*model=self.modelArray[i];
        switch (i) {
            case 0:
                [parm setValue:model.text forKey:@"szDispName"];
                break;
            case 2:
                if (self.showFood.dwShowProp==2) {
                  //   [parm setValue:[NSString stringWithFormat:@"%.f",[model.text floatValue]*100] forKey:@"dwMinPrice"];
                    dwMinPrice=[model.text floatValue]*100;
                    
                }else{
                    DLog(@"sellprice:%@",model.text);
                    sellPrice=[model.text floatValue]*100;
                  //   [parm setValue:[NSString stringWithFormat:@"%.f",[model.text floatValue]*100] forKey:@"dwUnitPrice"];
                    
                }
               
                break;
            case 3:{
                
                if (self.showFood.dwIncSubFood) {
                     dwMinPrice=[model.text floatValue]*100;
                }
              
            }
                break;
            case 4:{
                if (self.showFood.dwIncSubFood) {
                    totalPrice=[model.text floatValue]*100;
                }
                
//                if (self.showFood.dwShowProp==2) {
//
//                    [parm setValue:[CommonFunc returnStringWithArray:model.chosenFoods] forKey:@"ChosenFoods"];
//                    NSInteger dwUnitPrice=[[self returnPriceFromChosenFood:model.chosenFoods] floatValue]*100;
//                    [parm setValue:@(dwUnitPrice) forKey:@"dwUnitPrice"];
//                    NSInteger dwDiscount=[[self returnPriceFromChosenFood:model.chosenFoods] floatValue]*100-dwMinPrice;
//                    [parm setValue:[NSString stringWithFormat:@"%ld",dwDiscount] forKey:@"dwDiscount"];
//
//                }
            }break;
            
            default:
                break;
        }
    }
    [parm removeObjectForKey:@"imagePath"];
    //套餐
    if (self.showFood.dwShowProp==2) {
        [UniHttpTool postwithparameters:parm option:SetShowFood success:^(id json) {
            if ([json[@"ret"] integerValue]==0) {
                NSDictionary*dict=json[@"data"];
                [MBProgressHUD showText:@"保存成功"];
                self.showFood.szDispName=dict[@"szDispName"];
                self.showFood.dwMinPrice=[dict[@"dwMinPrice"] integerValue];
                NSMutableArray*temp=[NSMutableArray array];
                for (NSDictionary *parm in dict[@"ChosenFoods"]) {
                    ChosenFood*chosenfood=[ChosenFood mj_objectWithKeyValues:parm];
                    [temp addObject:chosenfood];
                }
                self.showFood.ChosenFoods=temp;
               
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                KShowServerMessage(json[@"error"]);
            }
        }];
    }else{
      
            if (sellPrice>totalPrice) {
                [MBProgressHUD showError:@"销售价格不能大于总价"];
            }else if (dwMinPrice>sellPrice){
                [MBProgressHUD showError:@"最小价格不能大于销售价格"];
            }else{
                [parm setValue:@(dwMinPrice) forKey:@"dwMinPrice"];
                [parm setValue:@(totalPrice-sellPrice) forKey:@"dwDiscount"];
                if (self.incSubfood) {
                    DLog(@"dddd");
                    [parm setValue:@(self.incSubfood) forKey:@"dwIncSubFood"];
                }
                DLog(@"%@---%ld---%ld---%ld",parm,dwMinPrice,totalPrice,sellPrice);
                [UniHttpTool postwithparameters:parm option:SetShowFood success:^(id json) {
                    if ([json[@"ret"] integerValue]==0) {
                        NSDictionary*dict=json[@"data"];
                        [MBProgressHUD showText:@"保存成功"];
                        self.showFood.dwUnitPrice=[dict[@"dwUnitPrice"] integerValue];
                        self.showFood.dwDiscount=[dict[@"dwDiscount"] integerValue];
                        self.showFood.dwMinPrice=[dict[@"dwMinPrice"] integerValue];
                        self.showFood.dwIncSubFood=[dict[@"dwIncSubFood"] integerValue];
                        [self.navigationController popViewControllerAnimated:YES];

                    }else{
                        KShowServerMessage(json[@"error"]);
                    }
                }];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
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
            total=total+[self returnPriceFromShowFood:chosenShowfood isDiscount:discount];
        }
        return total;
        //食物包含配料
    }else if (showfood.dwIncSubFood){
        return discount?[self returnTotalPrice:showfood.dwIncSubFood]-showfood.dwDiscount:[self returnTotalPrice:showfood.dwIncSubFood];
    }else{
        return discount?showfood.dwUnitPrice-showfood.dwDiscount:showfood.dwUnitPrice;
    }
}
-(void)setupArray{
    self.showGroupArray=[[DataBase sharedDataBase]getAllShowGroup];
    NSMutableArray*temp=[NSMutableArray array];
    
    ShowGroup*showGroupTemp=[[ShowGroup alloc]init];
    for (int i=0; i<self.showGroupArray.count; i++) {
        ShowGroup*showGroup=self.showGroupArray[i];
        if (![showGroup.szGroupName isEqualToString:@"Packages"]) {
            [temp addObject:showGroup.szGroupName];
        }else{
            showGroupTemp=showGroup;
        }
        
    }
    [self.showGroupArray removeObject:showGroupTemp];
    self.groupNameArray=[NSArray array];
    self.groupNameArray=temp;
    
    
    ShowGroup*showgroup=self.showGroupArray[0];
    self.showFoodArray=[[DataBase sharedDataBase]getShowFoodEqual:[NSString stringWithFormat:@"%ld",showgroup.dwGroupID]];
    
    NSMutableArray*foodTemp=[NSMutableArray array];
    for (int i=0; i<self.showFoodArray.count; i++) {
        ShowFood*showfood=self.showFoodArray[i];
        [foodTemp addObject:showfood.szDispName];
    }
    self.showFoodNameArray=foodTemp;
    
    
}
-(void)setupData{
    
    NSDictionary*parm1=@{@"leftTitle":@"商品名称:",@"viewClass":@"UILabel",@"text":    self.showFood.szDispName?self.showFood.szDispName:@""};
    NSDictionary*parm2=@{@"leftTitle":@"上传图片:",@"viewClass":@"UIImageView",@"imageName":@"plus"};
     NSString*priceStr=[NSString stringWithFormat:@""];
    if (self.showFood.dwShowProp==2) {
        priceStr=[NSString stringWithFormat:@"%.2f",self.showFood.dwMinPrice/100.0];
    }else{
        if (self.showFood.dwIncSubFood) {
            
            priceStr=[NSString stringWithFormat:@"%.2f",[self returnTotalPrice:self.showFood.dwIncSubFood]/100.0];
        }else{
             priceStr=[NSString stringWithFormat:@"%.2f",self.showFood.dwUnitPrice/100.0];
        }
       
       
    }
    if (self.showFood.dwSoldProp==2) {
        if (self.showFood.dwDefQuantity==0) {
            priceStr=[NSString stringWithFormat:@"%.2f",self.showFood.dwUnitPrice/100.0];
        }else{
            priceStr=[NSString stringWithFormat:@"%.2f",self.showFood.dwUnitPrice*self.showFood.dwDefQuantity/100000.0];
        }
        
    }

    NSDictionary*parm3=@{@"leftTitle":@"商品价格:",@"viewClass":@"UITextField",@"keyboard":@(1),@"text": [NSString stringWithFormat:@"%.2f",([self returnTotalPrice:self.showFood.dwIncSubFood]-self.showFood.dwDiscount)/100.0]};
    NSDictionary*parm4=@{@"leftTitle":@"最小销售价格:",@"viewClass":@"UITextField",@"keyboard":@(1),@"text": [NSString stringWithFormat:@"%.2f",self.showFood.dwMinPrice/100.0]};
    NSDictionary*parm5=@{@"leftTitle":@"总价:",@"viewClass":@"UILabel",@"text":[NSString stringWithFormat:@"%.2f",[self returnPriceFromShowFood:self.showFood isDiscount:NO]/100.0]};
    NSDictionary*parm9=@{@"leftTitle":@"备注:",@"viewClass":@"UITextField",@"text":self.showFood.szMemo?self.showFood.szMemo:@""};
    NSArray*temp=[NSArray array];
    if (self.showFood.dwShowProp==2) {
        NSDictionary*parm7=@{@"leftTitle":@"套餐包含食物",@"viewClass":@"UIImageView",@"imageName":@"plus"};
        NSDictionary*parm8=@{@"chosenFoods":self.showFood.ChosenFoods};
       
        NSDictionary*parm10=@{@"leftTitle":@"总价",@"text": [self returnPriceFromChosenFood:self.showFood.ChosenFoods],@"viewClass":@"UILabel"};
        temp=@[parm1,parm2,parm3, parm7,parm8,parm9,parm10];
    }else if (self.showFood.dwIncSubFood>0){
        NSDictionary*parm10=@{@"leftTitle":@"配菜",@"subfoodprop":@(self.showFood.dwSubFoodProp),@"incSubfoodprop":@(self.showFood.dwIncSubFood)};
        temp=@[parm1,parm2,parm3,parm4,parm5,parm9,parm10];
    }
    else{
        temp=@[parm1,parm2,parm3,parm9];
    }
    
    for (int i=0; i<temp.count; i++) {
        CellWithView*cell=[CellWithView mj_objectWithKeyValues:temp[i]];
        [self.modelArray addObject:cell];
    }
   
}
-(NSString*)returnPriceFromChosenFood:(NSArray*)chosenfoods{
    NSArray*showfoods=[[DataBase sharedDataBase]getAllShowFood];
    NSInteger price=0;
    for (ChosenFood*chosenFood in chosenfoods) {
        for (ShowFood*showFood in showfoods) {
            if (chosenFood.dwShowFoodID==showFood.dwShowFoodID) {
                price=price+showFood.dwUnitPrice;
                DLog(@"%ld",showFood.dwUnitPrice);
                break;
            }
        }
    }
    return [NSString stringWithFormat:@"%.2f",price/100.0];
}
- (void)xxPickerView:(XXPickerView *)pickerView didSelectTitles:(NSArray *)titles selectedRows:(NSArray *)rows{
    ShowFood*showfood=[self.showFoodArray objectAtIndex:[rows[1] integerValue]];
    
    ChosenFood*chosenfood=[[ChosenFood alloc]init];
    chosenfood.dwShowFoodID=showfood.dwShowFoodID;
    chosenfood.dwCookWayProp=showfood.dwCookWayProp;
    chosenfood.dwSubFoodProp=showfood.dwSubFoodProp;
    chosenfood.dwFlavorProp=showfood.dwFlavorProp;
    chosenfood.dwQuantity=showfood.dwDefQuantity;
    chosenfood.szMemo=showfood.szMemo;

    NSInteger DispOrder=0;
    for (int i=0; i<self.showFood.ChosenFoods.count; i++) {
        ChosenFood*choseFood=self.showFood.ChosenFoods[i];
        if (choseFood.dwDispOrder>DispOrder) {
            DispOrder=choseFood.dwDispOrder;
        }
    }
    chosenfood.dwDispOrder=DispOrder+1;
    chosenfood.dwParentID=self.showFood.dwShowFoodID;
    
    NSMutableArray*tempArray=[NSMutableArray arrayWithArray:self.modelArray];
    CellWithView*cellmodel=self.modelArray[4];
    NSMutableArray*temp=[NSMutableArray arrayWithArray:cellmodel.chosenFoods];
    [temp addObject:chosenfood];
    cellmodel.chosenFoods=temp;
    [tempArray replaceObjectAtIndex:4 withObject:cellmodel];
    CellWithView*cell6=self.modelArray[6];
    cell6.text=[self returnPriceFromChosenFood:temp];
    self.modelArray=tempArray;
    

    [self.tableView reloadData];
    self.lastSelRows=rows;
    
}
- (void)xxPickerView:(XXPickerView *)pickerView didChangeRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {
        ShowGroup*showgroup=self.showGroupArray[row];
        self.showFoodArray=[[DataBase sharedDataBase]getShowFoodEqual:[NSString stringWithFormat:@"%ld",showgroup.dwGroupID]];
        
        NSMutableArray*foodTemp=[NSMutableArray array];
        for (int i=0; i<self.showFoodArray.count; i++) {
            ShowFood*showfood=self.showFoodArray[i];
            [foodTemp addObject:showfood.szDispName];
        }
        self.showFoodNameArray=foodTemp;
        DLog(@"%ld--%ld----%ld",self.showFoodNameArray.count,row,component);
        [pickerView setTitlesForComponents:@[self.groupNameArray,self.showFoodNameArray]];
        [pickerView reloadComponent:1];
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WithTextCell*cell=[WithTextCell initWithTableView:tableView];
    cell.cellWithView=self.modelArray[indexPath.row];
    cell.delegate=self;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.showFood.dwShowProp==2) {
        if (indexPath.row==4) {
            return 120;
        }else{
            return 60;
        }
    }else{
        if (indexPath.row==6) {
            
            return 120;
        }else{
            return 60;
        }
    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==3&&self.showFood.dwShowProp==2) {
        XXPickerView *picker = [[XXPickerView alloc] initWithTitle:@"添加套餐食物" delegate:self];
        picker.toolbarTintColor=KmainColor;
        picker.toolbarButtonColor=[UIColor whiteColor];
        [picker setTitlesForComponents:@[self.groupNameArray,self.showFoodNameArray]];
        [picker selectIndexes:self.lastSelRows animated:YES];
        [picker show];
    }
    /*
    CellWithView*temp=self.modelArray[indexPath.row];
    
    if (self.showFood.dwShowProp==1&&indexPath.row==5) {
       
        SetSubFoodViewController*setSubfood=[[SetSubFoodViewController alloc]init];
        setSubfood.subFoodProp=temp.prop;
         DLog(@"***%ld**",temp.prop);
        setSubfood.VCBlock = ^(NSDictionary *vegDic) {
           
            if (![vegDic[@"prop"] isKindOfClass:[NSNull class]]) {
                temp.prop=[vegDic[@"prop"] integerValue];
                [self.modelArray replaceObjectAtIndex:indexPath.row withObject:temp];
                NSArray<NSIndexPath*>*indexPathArray=@[indexPath];
                [tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
            }
        };
        [self.navigationController pushViewController:setSubfood animated:YES];
    }else if (self.showFood.dwShowProp==1&&indexPath.row==4){
        SetFlavorViewController*flavor=[[SetFlavorViewController alloc]init];
        flavor.flavorProp=temp.prop;
        flavor.VCBlock = ^(NSDictionary *vegDic) {
            if (![vegDic[@"prop"] isKindOfClass:[NSNull class]]) {
                temp.prop=[vegDic[@"prop"] integerValue];
                [self.modelArray replaceObjectAtIndex:indexPath.row withObject:temp];
                NSArray<NSIndexPath*>*indexPathArray=@[indexPath];
                [tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
            }
        };
        [self.navigationController pushViewController:flavor animated:YES];
    }else if (self.showFood.dwShowProp==1&&indexPath.row==3){
        SetCookWayViewController*cookWay=[[SetCookWayViewController alloc]init];
        cookWay.cookWayProp=self.showFood.dwCookWayProp;
        [self.navigationController pushViewController:cookWay animated:YES];
    }
     */
}
-(void)DeleteChosenFood:(NSMutableArray *)chosenfoods{
    NSMutableArray*tempArray=[NSMutableArray arrayWithArray:self.modelArray];
    
    CellWithView*cellmodel=self.modelArray[4];
    cellmodel.chosenFoods=chosenfoods;
    [tempArray replaceObjectAtIndex:4 withObject:cellmodel];
    self.modelArray=tempArray;
    
    CellWithView*cell6=self.modelArray[6];
    cell6.text=[self returnPriceFromChosenFood:chosenfoods];
    NSIndexPath*indexpath=[NSIndexPath indexPathForRow:6 inSection:0];
    NSArray<NSIndexPath*>*indexPathArray=@[indexpath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
}
-(void)TextCellEditing:(WithTextCell *)cell{
    NSIndexPath*indexPath=[self.tableView indexPathForCell:cell];
    CellWithView*cellModel=self.modelArray[indexPath.row];
    DLog(@"%@",cellModel.text);
    if (indexPath.row==2) {
        self.balance=[cellModel.text floatValue]*100;
        DLog(@"%ld",self.balance);
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
    return subPrice+self.showFood.dwUnitPrice;
}
-(void)reloadTotalPrice:(NSInteger)incSubfood{
    CellWithView*model=self.modelArray[4];
    model.text=[NSString stringWithFormat:@"%.2f",[self returnTotalPrice:incSubfood]/100.0];
    NSIndexPath*indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
    NSArray<NSIndexPath*>*indexPathArray=@[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    //DLog(@"--%ld--",incSubfood);
    self.incSubfood=incSubfood;
}
-(ShowFood *)showFood{
    if (!_showFood) {
        _showFood=[[ShowFood alloc]init];
    }
    return _showFood;
}
-(NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray=[NSMutableArray array];
    }
    return _modelArray;
}
@end
