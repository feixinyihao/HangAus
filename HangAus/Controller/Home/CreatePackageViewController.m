//
//  CreatePackageViewController.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/20.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "CreatePackageViewController.h"
#import "DataBase.h"
#import <XXPickerView.h>
#import "DataBase.h"
#import "ShowGroup.h"
#import "ShowFood.h"
#import "ChosenFood.h"
#import "CommonFunc.h"
#import "UniHttpTool.h"
#import <MJExtension.h>
#import "ChosenFoodView.h"
#import "MBProgressHUD+MJ.h"
#import "CellWithView.h"
#import "WithTextCell.h"
#import "ShopSubFood.h"
@interface CreatePackageViewController ()<UITableViewDelegate,UITableViewDataSource,XXPickerViewDelegate,WithTextCellDelegate>
@property(nonatomic,strong)NSArray*titleArray;
@property(nonatomic,weak)UITableView*tableView;


/**
 pick显示的分类名称数组
 */
@property(nonatomic,strong)NSArray*groupNameArray;

/**
 showfood数组
 */
@property(nonatomic,strong)NSArray*showFoodArray;


/**
 showgroup数组
 */
@property(nonatomic,strong)NSMutableArray*showGroupArray;


/**
 pick显示的食物名称数组
 */
@property(nonatomic,strong)NSArray*showFoodNameArray;

/**
 添加的ChosenFood
 */
@property(nonatomic,strong)NSMutableArray*selectedChosenFood;


@property(nonatomic,assign)CGRect rect;

@property(nonatomic,weak)UITextField*priceField;

@property(nonatomic,assign)NSInteger totalPrice;

@property(nonatomic,weak)UITextField*dispNameField;

@property(nonatomic,strong)NSArray*lastSelRows;
@property(nonatomic,strong)NSMutableArray*modelArray;

@end

@implementation CreatePackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rect=CGRectMake(0, 0, 0, 0);
    self.title=@"新建套餐";
    [self setupUI];
    [self setupData];
    [self setupArray];
    ShowFood*tempshowfood=[[[DataBase sharedDataBase]getShowFoodEqual:@"8"] lastObject];
    ShowFood*tempshowfood2=[[[DataBase sharedDataBase]getAllShowFood]lastObject];
    DLog(@"%ld--%ld",tempshowfood.dwDispOrder,tempshowfood2.dwShowFoodID);

 

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
    
    NSDictionary*parm1=@{@"leftTitle":@"商品名称:",@"viewClass":@"UITextField"};
    NSDictionary*parm2=@{@"leftTitle":@"上传图片:",@"viewClass":@"UIImageView",@"imageName":@"plus"};
    NSDictionary*parm3=@{@"leftTitle":@"商品价格:",@"viewClass":@"UITextField",@"keyboard":@(1)};
    
    NSDictionary*parm4=@{@"leftTitle":@"备注:",@"viewClass":@"UITextField"};

    NSDictionary*parm5=@{@"leftTitle":@"套餐包含食物",@"viewClass":@"UIImageView",@"imageName":@"plus"};
    NSDictionary*parm6=@{@"chosenFoods":self.selectedChosenFood};
        
    NSDictionary*parm7=@{@"leftTitle":@"总价",@"viewClass":@"UILabel"};
    NSArray* temp=@[parm1,parm2,parm3,parm4,parm5,parm6,parm7];
    
    for (int i=0; i<temp.count; i++) {
        CellWithView*cell=[CellWithView mj_objectWithKeyValues:temp[i]];
        [self.modelArray addObject:cell];
    }
    
}
-(void)setupUI{
    UITableView*tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64)];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView=[[UIView alloc]init];
   
    
    UIButton*saveNextBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, kScreenH-64-50, kScreenW/2, 50)];
    [saveNextBtn setTitle:@"保存并继续创建" forState:UIControlStateNormal];
    saveNextBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [saveNextBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    saveNextBtn.tag=998;
    [saveNextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:saveNextBtn];
    
    UIButton*saveBackBtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenW/2, kScreenH-64-50, kScreenW/2, 50)];
    [saveBackBtn setTitle:@"保存并返回" forState:UIControlStateNormal];
    saveBackBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    saveBackBtn.tag=999;
    [saveBackBtn setBackgroundColor:KmainColor];
    [saveBackBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBackBtn];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    WithTextCell*cell=[WithTextCell initWithTableView:tableView];
    CellWithView*model=self.modelArray[indexPath.row];
    cell.cellWithView=model;
    cell.delegate=self;
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==4) {
        XXPickerView *picker = [[XXPickerView alloc] initWithTitle:@"添加套餐食物" delegate:self];
        picker.toolbarTintColor=KmainColor;
        picker.toolbarButtonColor=[UIColor whiteColor];
        [picker setTitlesForComponents:@[self.groupNameArray,self.showFoodNameArray]];
        [picker selectIndexes:self.lastSelRows animated:YES];
        [picker show];
    }
   
    
}
-(NSString*)returnPriceFromChosenFood:(NSArray*)chosenfoods{

    NSInteger price=0;
    for (int i=0; i<chosenfoods.count; i++) {
        ChosenFood*chosenfood=chosenfoods[i];
        ShowFood*chosenShowfood=[[DataBase sharedDataBase]getShowFoodWithID:chosenfood.dwShowFoodID];
        if (chosenShowfood.dwSoldProp==2) {
            chosenShowfood.dwDefQuantity=chosenfood.dwQuantity;
            price=price+[self returnPriceFromShowFood:chosenShowfood isDiscount:NO];
        }else{
            price=price+[self returnPriceFromShowFood:chosenShowfood isDiscount:NO]*chosenfood.dwQuantity;
        }
        
    }
    return [NSString stringWithFormat:@"%.2f",price/100.0];
}


-(void)save:(UIButton*)button{
    ShowFood*tempshowfood=[[[DataBase sharedDataBase]getShowFoodEqual:@"8"] lastObject];
    ShowFood*tempshowfood2=[[[DataBase sharedDataBase]getAllShowFood]lastObject];

    NSMutableDictionary*parm=[NSMutableDictionary dictionary];
    parm[@"dwCookWayProp"]=@(0);
    parm[@"dwDefQuantity"]=@(1);
    
    parm[@"dwDispOrder"]=@(tempshowfood.dwDispOrder+1);
    parm[@"dwFlavorProp"]=@(1);
    parm[@"dwFoodID"]=@(0);
    parm[@"dwFoodKindID"]=@(0);
    parm[@"dwGroupID"]=@(8);
    parm[@"dwIncSubFood"]=@(0);
    parm[@"dwKindProp"]=@(0);
  
    parm[@"dwProp"]=@(0);
    parm[@"dwShopID"]=@(1);
  //  parm[@"dwShowFoodID"]=@(tempshowfood2.dwShowFoodID+1);
    parm[@"dwShowProp"]=@(2);
    parm[@"dwSoldProp"]=@(0);
    parm[@"dwStat"]=@(2);
    parm[@"dwStoredNum"]=@(0);
    parm[@"dwSubFoodProp"]=@(0);
   
    parm[@"dwUnitWeight"]=@(0);
    parm[@"szDispAbbr"]=@"Packages";
    parm[@"szMemo"]=@"Packages";
    parm[@"ChosenFoods"]=[CommonFunc returnStringWithArray:self.selectedChosenFood];
    
    NSInteger minPrice=0;
    for (int i=0; i<self.modelArray.count; i++) {
        CellWithView*model=self.modelArray[i];
        switch (i) {
            case 0:{
               
                if ([model.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0) {
                    [MBProgressHUD showError:@"名称不能为空"];
                    return;
                }else{
                    parm[@"szDispName"]=model.text;
                }
            }
                break;
            case 2:{
                if ([model.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0) {
                    [MBProgressHUD showError:@"价格不能为空"];
                    return;
                }else{
                    parm[@"dwMinPrice"]=[NSString stringWithFormat:@"%.f",[model.text floatValue]*100];
                    minPrice=[model.text floatValue]*100;
                }
            }break;
            case 6:{
                parm[@"dwDiscount"]=[NSString stringWithFormat:@"%.f",[model.text floatValue]*100-minPrice];
                parm[@"dwUnitPrice"]=[NSString stringWithFormat:@"%.f",[model.text floatValue]*100];
            }break;
            default:
                break;
        }
    }

    
    [UniHttpTool postwithparameters:parm option:SetShowFood success:^(id json) {
            if ([json[@"ret"] integerValue]==0) {
                [MBProgressHUD showSuccess:@"创建成功"];
                if (button.tag==999) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else if (button.tag==998){
                    for (int i=0; i<self.modelArray.count; i++) {
                        CellWithView*model=self.modelArray[i];
                        model.text=@"";
                        model.chosenFoods=nil;
                        [self.tableView reloadData];
                    }
                }
               
            }else{
                KShowServerMessage(json[@"error"]);
            }
        }];
   // DLog(@"%@",parm);
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
- (void)xxPickerView:(XXPickerView *)pickerView didSelectTitles:(NSArray *)titles selectedRows:(NSArray *)rows{
    ShowFood*showfood=[self.showFoodArray objectAtIndex:[rows[1] integerValue]];
    ShowFood*tempshowfood=[[[DataBase sharedDataBase]getAllShowFood]lastObject];
    ChosenFood*chosenfood=[[ChosenFood alloc]init];
    chosenfood.dwShowFoodID=showfood.dwShowFoodID;
    chosenfood.dwCookWayProp=showfood.dwCookWayProp;
    chosenfood.dwSubFoodProp=showfood.dwSubFoodProp;
    chosenfood.dwFlavorProp=showfood.dwFlavorProp;
    chosenfood.dwQuantity=1;
    chosenfood.szMemo=showfood.szMemo;
    
    chosenfood.dwDispOrder=1;
   // chosenfood.dwParentID=tempshowfood.dwShowFoodID+1;
    
    [self.selectedChosenFood addObject:chosenfood];
    CellWithView*cell5=self.modelArray[5];
    cell5.chosenFoods=self.selectedChosenFood;
   
   
    CellWithView*cell6=self.modelArray[6];
    cell6.text=[self returnPriceFromChosenFood:self.selectedChosenFood];
    
    [self.tableView reloadData];
    
}
- (void)xxPickerView:(XXPickerView *)pickerView didChangeRow:(NSInteger)row inComponent:(NSInteger)component{
    self.lastSelRows=@[@(row),@(component)];
    DLog(@"%ld--%ld",row,component);
    if (component==0) {
        self.lastSelRows=@[@(row),@(0)];
        ShowGroup*showgroup=self.showGroupArray[row];
        self.showFoodArray=[[DataBase sharedDataBase]getShowFoodEqual:[NSString stringWithFormat:@"%ld",showgroup.dwGroupID]];
        
        NSMutableArray*foodTemp=[NSMutableArray array];
        for (int i=0; i<self.showFoodArray.count; i++) {
            ShowFood*showfood=self.showFoodArray[i];
            [foodTemp addObject:showfood.szDispName];
        }
        self.showFoodNameArray=foodTemp;
        [pickerView setTitlesForComponents:@[self.groupNameArray,self.showFoodNameArray]];
        [pickerView reloadComponent:1];
    }
    if (component==1) {
         self.lastSelRows=@[self.lastSelRows[0],@(row)];
    }
}

-(void)DeleteChosenFood:(NSMutableArray *)chosenfoods{
    self.selectedChosenFood=chosenfoods;
    CellWithView*model=self.modelArray[5];
    model.chosenFoods=chosenfoods;
    CellWithView*model7=self.modelArray[6];
    model7.text=[self returnPriceFromChosenFood:chosenfoods];
    [self.tableView reloadData];
    DLog(@"%@",self.selectedChosenFood);
}
-(NSMutableArray *)selectedChosenFood{
    if (!_selectedChosenFood) {
        _selectedChosenFood=[NSMutableArray array];
    }
    return _selectedChosenFood;
}

-(NSArray *)lastSelRows{
    if (!_lastSelRows) {
        _lastSelRows=[NSArray array];
    }
    return _lastSelRows;
}
-(NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray=[NSMutableArray array];
    }
    return _modelArray;
}
@end
