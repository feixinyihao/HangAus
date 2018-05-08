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
#import "ShopSubFood.h"
#import <MJExtension.h>
#import "UniHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import <TZImagePickerController.h>
#import <BGFMDB.h>
#import <XXPickerView.h>
#import "ShowGroup.h"
@interface EditFoodViewController ()<WithTextCellDelegate,TZImagePickerControllerDelegate,XXPickerViewDelegate>
@property(nonatomic,strong)NSArray*cellModelArray;

@property(nonatomic,assign)NSInteger incSubfood;
/**
 showgroup数组
 */
@property(nonatomic,strong)NSMutableArray*showGroupArray;

/**
showfood数组
*/
@property(nonatomic,strong)NSArray*showFoodArray;

/**
 pick显示的分类名称数组
 */
@property(nonatomic,strong)NSArray*groupNameArray;

/**
 pick显示的食物名称数组
 */
@property(nonatomic,strong)NSArray*showFoodNameArray;



@property(nonatomic,strong)NSArray*lastSelRows;
@end

@implementation EditFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.incSubfood=self.showFood.dwIncSubFood;
    self.title=@"编辑";
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    [self setupData];
    [self setupArray];
}
-(void)setupArray{
    self.showGroupArray=[NSMutableArray arrayWithArray:[ShowGroup bg_findAll:nil]];
    if (self.showGroupArray.count<1) {
        return;
    }
    NSMutableArray*temp=[NSMutableArray array];
    
    ShowGroup*showGroupTemp=[[ShowGroup alloc]init];
    for (int i=0; i<self.showGroupArray.count; i++) {
        ShowGroup*showGroup=self.showGroupArray[i];
        if (showGroup.dwGroupID!=8) {
            [temp addObject:showGroup.szGroupName];
        }else{
            showGroupTemp=showGroup;
        }
        
    }
    [self.showGroupArray removeObject:showGroupTemp];
    self.groupNameArray=[NSArray array];
    self.groupNameArray=temp;
    
    
    ShowGroup*showgroup=self.showGroupArray[0];
    self.showFoodArray=[ShowFood bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"dwGroupID"),bg_sqlValue(@(showgroup.dwGroupID))]];
    
    NSMutableArray*foodTemp=[NSMutableArray array];
    for (int i=0; i<self.showFoodArray.count; i++) {
        ShowFood*showfood=self.showFoodArray[i];
        [foodTemp addObject:showfood.szDispName];
    }
    self.showFoodNameArray=foodTemp;
    
    
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
                         @"imagePath":[NSString stringWithFormat:@"%@%@.jpg",KrootImagePath,[CommonFunc md5:[NSString stringWithFormat:@"%ld",self.showFood.dwShowFoodID]]]};
    NSDictionary*parm3=@{@"leftTitle":@"销售价格:",
                         @"viewClass":@"UITextField",
                         @"keyboard":@(1),
                         @"text": [NSString stringWithFormat:@"%.1f0",self.showFood.dwSoldPrice/100.0]};
    NSDictionary*parm4=@{@"leftTitle":@"备注:",
                         @"viewClass":@"UITextField",
                         @"text":self.showFood.szMemo?self.showFood.szMemo:@""};
    NSDictionary*parm5=@{@"leftTitle":@"最低价格:",
                         @"viewClass":@"UITextField",
                         @"keyboard":@(1),
                         @"text": [NSString stringWithFormat:@"%.1f0",self.showFood.dwMinPrice/100.0]};
    NSDictionary*parm7=@{@"leftTitle":@"总价",
                         @"text": [NSString stringWithFormat:@"%.1f0",
                                   self.showFood.dwTotalPrice/100.0],
                         @"viewClass":@"UILabel"};
    NSArray*temp=[NSArray array];
    if (self.showFood.dwShowProp==1&&!self.showFood.dwIncSubFood) {
        temp=@[parm1,parm2,parm3,parm4];
    }else if (self.showFood.dwShowProp==2){
        NSDictionary*parm9=@{@"leftTitle":@"套餐包含食物",
                             @"viewClass":@"UIImageView",
                             @"imageName":@"plus"};
        NSDictionary*parm10=@{@"chosenFoods":self.showFood.ChosenFoods};
        temp=@[parm1,parm2,parm9,parm10,parm3,parm5,parm7,parm4];
    }else if (self.showFood.dwIncSubFood){
         NSDictionary*parm8=@{@"leftTitle":@"配菜",
                              @"subfoodprop":@(self.showFood.dwSubFoodProp),
                              @"incSubfoodprop":@(self.showFood.dwIncSubFood)};
         temp=@[parm1,parm2,parm8,parm3,parm7,parm5,parm4];
    }
    NSMutableArray*tempArray=[NSMutableArray array];
    for (int i=0; i<temp.count; i++) {
        CellWithView*cell=[CellWithView mj_objectWithKeyValues:temp[i]];
        
        [tempArray addObject:cell];
    }
    self.cellModelArray=tempArray;
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
            return 140;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==1) {
        
        TZImagePickerController*pick=[[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
        pick.allowCrop=YES;
        pick.naviBgColor=KmainColor;
        [pick setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,
                                                NSArray *assets,
                                                BOOL isSelectOriginalPhoto) {
        
           
        
            
            NSDictionary*parm=@{@"file_key":[CommonFunc md5:[NSString stringWithFormat:@"%ld",self.showFood.dwShowFoodID]]};
            NSData*data=UIImagePNGRepresentation(photos[0]);
            [UniHttpTool uploadWithparameters:parm filename:parm[@"file_key"] uploadData:data success:^(id json) {
                CellWithView*model=self.cellModelArray[1];
                model.imagePath=[NSString stringWithFormat:@"%@%@.jpg",KrootImagePath,[CommonFunc md5:[NSString stringWithFormat:@"%ld",self.showFood.dwShowFoodID]]];
                NSArray<NSIndexPath*>*indexPathArray=@[indexPath];
                [tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
            }];
            
        }];
        
        [self presentViewController:pick animated:YES completion:nil];
      
    }else if (indexPath.row==2&&self.showFood.dwShowProp==2){
        XXPickerView *picker = [[XXPickerView alloc] initWithTitle:@"添加套餐食物" delegate:self];
        picker.toolbarTintColor=KmainColor;
        picker.toolbarButtonColor=[UIColor whiteColor];
        [picker setTitlesForComponents:@[self.groupNameArray,self.showFoodNameArray]];
        [picker selectIndexes:self.lastSelRows animated:YES];
        [picker show];
    }
    
}
-(NSInteger)returnTotalPrice:(NSInteger)incSubfood{
    NSArray*subfoodArray=[ShopSubFood bg_findAll:nil];
    NSInteger subPrice=0;
    for (int i=0; i<subfoodArray.count;i++) {
        ShopSubFood*subfood=subfoodArray[i];
        if ((incSubfood&subfood.dwSFID)==subfood.dwSFID) {
            subPrice=subPrice+subfood.dwUnitPrice;
        }
    }
    DLog(@"%ld---%ld",subPrice,self.showFood.dwTotalPrice);
    return subPrice;
}
-(void)reloadTotalPrice:(NSInteger)incSubfood{
    CellWithView*model=self.cellModelArray[4];
    if (incSubfood>0) {
       
         model.text=[NSString stringWithFormat:@"%.2f",([model.text floatValue]*100+[self returnTotalPrice:incSubfood])/100.0];
    }else{
         model.text=[NSString stringWithFormat:@"%.2f",([model.text floatValue]*100-[self returnTotalPrice:-incSubfood])/100.0];
    }
   
    NSIndexPath*indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
    NSArray<NSIndexPath*>*indexPathArray=@[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    self.incSubfood= self.incSubfood+incSubfood;
}
-(void)DeleteChosenFood:(NSMutableArray *)chosenfoods{
    
    
    CellWithView*cellmodel=self.cellModelArray[3];
    cellmodel.chosenFoods=chosenfoods;
//    NSInteger total=0;
//    for (int i=0; i<chosenfoods.count; i++) {
//        ChosenFood*chosenfood=chosenfoods[i];
//        NSArray*array=[ShowFood bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"dwShowFoodID"),bg_sqlValue(@(chosenfood.dwShowFoodID))]];
//        ShowFood*chosenShowfood=[array firstObject];
//        DLog(@"%@---%ld",chosenShowfood.szDispName,chosenShowfood.dwSoldPrice);
//        if (chosenShowfood.dwSoldProp==2) {
//            chosenShowfood.dwDefQuantity=chosenfood.dwQuantity;
//            total=total+[self returnPriceFromShowFood:chosenShowfood isDiscount:YES];
//        }else{
//            total=total+chosenShowfood.dwSoldPrice;
//        }
//
//    }
    CellWithView*cellmodel6=self.cellModelArray[6];
    cellmodel6.text=[self returnPriceFromChosenFood:chosenfoods];
    NSIndexPath*indexpath=[NSIndexPath indexPathForRow:6 inSection:0];
    NSArray<NSIndexPath*>*indexPathArray=@[indexpath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
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
            NSArray*array=[ShowFood bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"dwShowFoodID"),bg_sqlValue(@(chosenfood.dwShowFoodID))]];
            ShowFood*chosenShowfood=[array firstObject];
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
-(void)save{
    NSDictionary*parm=self.showFood.mj_keyValues;
    NSInteger sellPrice=0;
    NSInteger total=0;
    NSInteger minPrice=0;
    if (self.showFood.dwIncSubFood) {
        CellWithView*model=self.cellModelArray[3];
        sellPrice=roundf([model.text floatValue]*100) ;
        CellWithView*model4=self.cellModelArray[4];
        CellWithView*model5=self.cellModelArray[5];
        total=roundf([model4.text floatValue]*100);
        minPrice=roundf([model5.text floatValue]*100);
        if (sellPrice>total||minPrice>sellPrice) {
            [MBProgressHUD showError:@"价格有误"];
        }else{
            if (self.incSubfood!=self.showFood.dwIncSubFood) {
                [parm setValue:@(self.incSubfood) forKey:@"dwIncSubFood"];
                [UniHttpTool postwithparameters:parm option:SetShowFood success:^(id json) {
                    
                    NSDictionary*dict=@{@"dwShowFoodID":@(self.showFood.dwShowFoodID),
                                        @"dwSoldPrice":@(sellPrice),
                                        @"dwMinPrice":@(minPrice),
                                        @"dwUnitPrice":@(self.showFood.dwUnitPrice)
                                        };
                    [UniHttpTool getwithparameters:dict option:SetShowfoodprice success:^(id json) {
                        NSDictionary*dataDic=json[@"data"];
                        ShowFood*resultShowfood=[ShowFood mj_objectWithKeyValues:dataDic];
                        self.showFood.dwIncSubFood=resultShowfood.dwIncSubFood;
                        self.showFood.dwMinPrice=resultShowfood.dwMinPrice;
                        self.showFood.dwTotalPrice=resultShowfood.dwTotalPrice;
                        self.showFood.dwSoldPrice=resultShowfood.dwSoldPrice;
                        [resultShowfood bg_saveOrUpdate];
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    
                }];
            }else{
                NSDictionary*dict=@{@"dwShowFoodID":@(self.showFood.dwShowFoodID),
                                    @"dwSoldPrice":@(sellPrice),
                                    @"dwMinPrice":@(minPrice),
                                    @"dwUnitPrice":@(self.showFood.dwUnitPrice)
                                    };
                [UniHttpTool getwithparameters:dict option:SetShowfoodprice success:^(id json) {
                    NSDictionary*dataDic=json[@"data"];
                    ShowFood*resultShowfood=[ShowFood mj_objectWithKeyValues:dataDic];
                    self.showFood.dwIncSubFood=resultShowfood.dwIncSubFood;
                    self.showFood.dwMinPrice=resultShowfood.dwMinPrice;
                    self.showFood.dwTotalPrice=resultShowfood.dwTotalPrice;
                    self.showFood.dwSoldPrice=resultShowfood.dwSoldPrice;
                    [resultShowfood bg_saveOrUpdate];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
            
        }
       //套餐
    }else if (self.showFood.dwShowProp==2){
        CellWithView*model=self.cellModelArray[3];
        [parm setValue:[CommonFunc returnStringWithArray:model.chosenFoods] forKey:@"ChosenFoods"];
        
        CellWithView*model4=self.cellModelArray[4];
        CellWithView*model5=self.cellModelArray[5];
        CellWithView*model6=self.cellModelArray[6];
        sellPrice=[model4.text floatValue]*100;
        minPrice=[model5.text floatValue]*100;
        total=[model6.text floatValue]*100;
        DLog(@"%ld--%ld",total,sellPrice);
       
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
              
                self.showFood.ChosenFoods=temp;
                NSDictionary*dic=@{@"dwShowFoodID":@(self.showFood.dwShowFoodID),
                                    @"dwSoldPrice":@(sellPrice),
                                    @"dwMinPrice":@(minPrice),
                                    };
                [UniHttpTool getwithparameters:dic option:SetShowfoodprice success:^(id json) {
                    ShowFood*resultShowfood=[ShowFood mj_objectWithKeyValues:json[@"data"]];
                    self.showFood.dwIncSubFood=resultShowfood.dwIncSubFood;
                    self.showFood.dwMinPrice=resultShowfood.dwMinPrice;
                    self.showFood.dwTotalPrice=resultShowfood.dwTotalPrice;
                    self.showFood.dwSoldPrice=resultShowfood.dwSoldPrice;
                    [resultShowfood bg_saveOrUpdate];
                    
                    self.showFood.dwSoldPrice=resultShowfood.dwSoldPrice;
                    [self.navigationController popViewControllerAnimated:YES];
                }];
               

            }];
        }
    }else if (self.showFood.dwSoldProp==2){
        CellWithView*model=self.cellModelArray[2];
        sellPrice=roundf([model.text floatValue]*100) ;
        NSDictionary*dict=@{@"dwShowFoodID":@(self.showFood.dwShowFoodID),
                            @"dwSoldPrice":@(sellPrice),
                            @"dwUnitPrice":@(self.showFood.dwUnitPrice)
                            };
        [UniHttpTool getwithparameters:dict option:SetShowfoodprice success:^(id json) {
            ShowFood*resultShowfood=[ShowFood mj_objectWithKeyValues:json[@"data"]];
            self.showFood.dwIncSubFood=resultShowfood.dwIncSubFood;
            self.showFood.dwMinPrice=resultShowfood.dwMinPrice;
            self.showFood.dwTotalPrice=resultShowfood.dwTotalPrice;
            self.showFood.dwSoldPrice=resultShowfood.dwSoldPrice;
            [resultShowfood bg_saveOrUpdate];
            
            self.showFood.dwSoldPrice=resultShowfood.dwSoldPrice;
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
    }
    else{
    
        CellWithView*model=self.cellModelArray[2];
        sellPrice=[model.text floatValue]*100;
        NSDictionary*dict=@{@"dwShowFoodID":@(self.showFood.dwShowFoodID),
                            @"dwSoldPrice":@(sellPrice),
                            @"dwUnitPrice":@(sellPrice),
                            @"dwMinPrice":@(sellPrice),
                            };
        [UniHttpTool getwithparameters:dict option:SetShowfoodprice success:^(id json) {
            ShowFood*resultShowfood=[ShowFood mj_objectWithKeyValues:json[@"data"]];
            self.showFood.dwIncSubFood=resultShowfood.dwIncSubFood;
            self.showFood.dwMinPrice=resultShowfood.dwMinPrice;
            self.showFood.dwTotalPrice=resultShowfood.dwTotalPrice;
            self.showFood.dwSoldPrice=resultShowfood.dwSoldPrice;
            [resultShowfood bg_saveOrUpdate];
            
            self.showFood.dwSoldPrice=resultShowfood.dwSoldPrice;
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
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
    
    chosenfood.dwDispOrder=1;
    chosenfood.dwParentID=self.showFood.dwShowFoodID;
    
    CellWithView*cell3=self.cellModelArray[3];
    NSMutableArray*temp=[NSMutableArray arrayWithArray:cell3.chosenFoods];
    [temp addObject:chosenfood];
    cell3.chosenFoods=temp;
    DLog(@"%ld",temp.count);
    
    CellWithView*cell6=self.cellModelArray[6];
    cell6.text=[self returnPriceFromChosenFood:temp];
    
    [self.tableView reloadData];
    
}
- (void)xxPickerView:(XXPickerView *)pickerView didChangeRow:(NSInteger)row inComponent:(NSInteger)component{
    self.lastSelRows=@[@(row),@(component)];
    DLog(@"%ld--%ld",row,component);
    if (component==0) {
        self.lastSelRows=@[@(row),@(0)];
        ShowGroup*showgroup=self.showGroupArray[row];
        self.showFoodArray=[ShowFood bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"dwGroupID"),bg_sqlValue(@(showgroup.dwGroupID))]];
        
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
-(NSString*)returnPriceFromChosenFood:(NSArray*)chosenfoods{
    
    NSInteger price=0;
    for (int i=0; i<chosenfoods.count; i++) {
        ChosenFood*chosenfood=chosenfoods[i];
        NSArray*array=[ShowFood bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"dwShowFoodID"),bg_sqlValue(@(chosenfood.dwShowFoodID))]];
        ShowFood*chosenShowfood=[array firstObject];
        if (chosenShowfood.dwSoldProp==2) {
            price=price+chosenfood.dwQuantity*chosenShowfood.dwUnitPrice/1000;
        }else{
            price=price+chosenShowfood.dwSoldPrice*chosenfood.dwQuantity;
        }
        DLog(@"****%ld****",price);
        
    }
    return [NSString stringWithFormat:@"%.1f0",price/100.0];
}
@end
