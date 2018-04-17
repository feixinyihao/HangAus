//
//  SettingViewController.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/2/7.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "SettingViewController.h"
#import "BaseNavigationController.h"
#import "ChangeTradingHourViewController.h"
#import "StaffInfo.h"
#import "UniHttpTool.h"
#import <MJExtension.h>
#import "ShopInfo.h"
#import "WithTextCell.h"
#import "CellWithView.h"
#import "MBProgressHUD+MJ.h"
#import <TZImagePickerController.h>
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate>
@property(nonatomic,weak)UITableView*tableView;


@property(nonatomic,strong)NSMutableArray*cellModelArray;

@property(nonatomic,strong)NSArray*dataArray;
@property(nonatomic,weak)UIImageView*shopImageview;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView*tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64) style:UITableViewStylePlain];
    tableView.tableFooterView=[[UIView alloc]init];
    self.tableView=tableView;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];

  
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    [self setupCellArray];
    [self setupData];
   
    
    
}
-(void)save{
    ShopInfo*shopinfo=[ShopInfo mj_objectWithKeyValues:self.dataArray[0]];
    for (int i=0; i<self.cellModelArray.count; i++) {
        CellWithView*model=self.cellModelArray[i];
       
        switch (i) {
            case 0:
                shopinfo.szShopName=model.text;
                break;
            case 1:
                shopinfo.szCompany=model.text;
                break;
            case 2:
                shopinfo.szTel=model.text;
                break;
            case 3:
                shopinfo.szRoad=model.text;
                break;
            case 4:
                shopinfo.szNumber=model.text;
                break;
            case 5:
                shopinfo.szSuburb=model.text;
                break;
            case 6:
                shopinfo.szState=model.text;
                break;
            default:
                
                break;
        }
    }
    [UniHttpTool getwithparameters:shopinfo.mj_keyValues option:SetShop success:^(id json) {
        if ([json[@"ret"] integerValue]==0) {
            [MBProgressHUD showText:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            KShowServerMessage(json[@"error"])
        }
    }];
}
-(void)setupData{
    
    [UniHttpTool getwithparameters:nil option:GetShop success:^(id json) {
        if ([json[@"ret"] integerValue]==0) {
            self.dataArray=json[@"data"];
            ShopInfo*shopinfo=[ShopInfo mj_objectWithKeyValues:self.dataArray[0]];
            for (int i=0; i<self.cellModelArray.count; i++) {
                CellWithView*cell=self.cellModelArray[i];
                switch (i) {
                    case 0:
                        cell.text=shopinfo.szShopName;
                        break;
                    case 1:
                        cell.text=shopinfo.szCompany;
                        break;
                    case 2:
                        cell.text=shopinfo.szTel;
                        break;
                    case 3:{
                        cell.text=shopinfo.szRoad;
                        
                    }break;
                    case 4:
                        cell.text=shopinfo.szNumber;
                        break;
                    case 5:
                        cell.text=shopinfo.szSuburb;
                        break;
                    case 6:
                        cell.text=shopinfo.szState;
                        break;
                    default:
                        break;
                }
            }
            [self.tableView reloadData];
            
        }
       
    }];
}

-(void)setupCellArray{
    NSDictionary*parm1=@{@"leftTitle":@"餐厅名称:",@"placeholder":@"请输入餐厅名称",@"viewClass":@"UITextField"};
    NSDictionary*parm2=@{@"leftTitle":@"餐厅简介:",@"placeholder":@"请输入餐厅简介",@"viewClass":@"UITextField"};
    NSDictionary*parm3=@{@"leftTitle":@"联系电话:",@"placeholder":@"请输入联系电话",@"viewClass":@"UITextField"};
   // NSDictionary*parm5=@{@"leftTitle":@"门店地址",@"viewClass":@"UILabel"};
    NSDictionary*parm6=@{@"leftTitle":@"街道地址:",@"viewClass":@"UITextField"};
    NSDictionary*parm7=@{@"leftTitle":@"门牌号:",@"viewClass":@"UITextField"};
    NSDictionary*parm8=@{@"leftTitle":@"城市:",@"viewClass":@"UITextField"};
     NSDictionary*parm9=@{@"leftTitle":@"洲:",@"viewClass":@"UITextField"};
    NSArray*temp=@[parm1,parm2,parm3,parm6,parm7,parm8,parm9];
    for (int i=0; i<temp.count; i++) {
        CellWithView*cell=[CellWithView mj_objectWithKeyValues:temp[i]];
        [self.cellModelArray addObject:cell];
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return self.cellModelArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    if (indexPath.section==1) {
        WithTextCell*cell=[WithTextCell initWithTableView:tableView];
        cell.cellWithView=self.cellModelArray[indexPath.row];
        if (indexPath.row==4) {
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        return cell;
        
    }else{
        UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        UIImageView*imageview=[[UIImageView alloc]init];
        self.shopImageview=imageview;
        self.shopImageview.frame=CGRectMake((kScreenW-150)/2, 0, 150, 150);
        [cell.contentView addSubview:self.shopImageview];
        
        UILabel*nameL=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 150)];
        nameL.text=@"点击上传图片";
        nameL.textAlignment=NSTextAlignmentCenter;
        [cell.contentView addSubview:nameL];
        return cell;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section?50:150;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section?0:20;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView*view=[[UIView alloc]init];
    view.backgroundColor=KColor(240, 240, 240);
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   if (indexPath.row==0){
        TZImagePickerController*pick=[[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
        pick.allowCrop=YES;
        pick.naviBgColor=KmainColor;
        [pick setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [self.shopImageview setImage:photos[0]];
            NSDictionary*parm=@{@"file_key":@"777"};
            NSData*data=UIImagePNGRepresentation(photos[0]);
            [UniHttpTool uploadWithparameters:parm filename:parm[@"file_key"] uploadData:data success:^(id json) {
                DLog(@"%@",json);
            }];
           
        }];
        [self presentViewController:pick animated:YES completion:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


-(NSMutableArray *)cellModelArray{
    if (!_cellModelArray) {
        _cellModelArray=[NSMutableArray array];
    }
    return _cellModelArray;
}
-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[NSArray array];
    }
    return _dataArray;
}

@end
