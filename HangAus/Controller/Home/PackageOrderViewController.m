//
//  PackageOrderViewController.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/11.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "PackageOrderViewController.h"
#import "ShowFood.h"
#import "ChosenFood.h"
#import <BGFMDB.h>
#import "ShopSubFood.h"
#import "PackageExchange.h"
#import "PackageExchangeCell.h"
#import "UniHttpTool.h"
#import "ChosenFoodPropView.h"
#import "ChosenFoodPropView.h"
#import "UIView+cxr.h"
#import "OrderFood.h"
#import "ShopCookway.h"
@interface PackageOrderViewController ()<UITableViewDelegate,UITableViewDataSource,ChosenFoodPropViewDelegate>
@property(nonatomic,weak)UITableView*tableView;
@property(nonatomic,weak)UILabel*totalL;

@property(nonatomic,assign)NSInteger selectedRow;

@property(nonatomic,strong)NSArray*showfoods;

@property(nonatomic,strong)NSIndexPath *cellIndexPath;

@property(nonatomic,assign)NSInteger cellH;

@property(nonatomic,assign)BOOL isRepeatClick;

@property(nonatomic,strong)NSArray*sameGroupFoods;
@property(nonatomic,assign)NSInteger oldFoodSoldPrice;
@property(nonatomic,strong)NSArray*orderFoods;
@end

@implementation PackageOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedRow=-1;
    self.view.backgroundColor=[UIColor whiteColor];
    [self setupTable];
    self.title=self.showfood.szDispName;
    [self setupBottomView];
    [self setupData];
    [self setupOrderfoods];
    
}
-(void)setupTable{
    UITableView*tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64-50) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.tableFooterView=[[UIView alloc]init];
    self.tableView=tableView;
    [self.view addSubview:tableView];
}
-(void)setupOrderfoods{
    OrderFood*orderfoodPackage=[[OrderFood alloc]init];
    orderfoodPackage.dwFoodIndex=self.orderfoodscount+1;
    orderfoodPackage.dwParentIndex=0;
    orderfoodPackage.dwShowFoodID=self.showfood.dwShowFoodID;
    orderfoodPackage.dwStat=0x12;
    orderfoodPackage.dwFoodType=0x4;
    orderfoodPackage.dwSelCookWay=self.showfood.dwCookWayProp;
    orderfoodPackage.szSelSubFood=@"";
    orderfoodPackage.szSelFlavor=@"";
    orderfoodPackage.dwQuantity=1;
    orderfoodPackage.dwFoodPrice=self.showfood.dwTotalPrice;
    orderfoodPackage.dwCookPrice=0;
    orderfoodPackage.dwSubFoodPrice=0;
    orderfoodPackage.dwFlavorPrice=0;
    orderfoodPackage.dwFoodDiscount=self.showfood.dwDiscount;
    orderfoodPackage.dwSubFoodDiscount=0;
    NSMutableArray*temp=[NSMutableArray array];
    [temp addObject:orderfoodPackage];
    for (int i=0; i<self.showfoods.count; i++) {
        ShowFood*chosenShowfood=self.showfoods[i];
        OrderFood*orderfood=[[OrderFood alloc]init];
        orderfood.dwFoodIndex=self.orderfoodscount+i+2;
        orderfood.dwParentIndex=self.orderfoodscount+1;
        orderfood.dwShowFoodID=chosenShowfood.dwShowFoodID;
        orderfood.dwStat=0x12;
        orderfood.dwFoodType=0x2;
        for (ShopCookway*cookway in [ShopCookway bg_findAll:nil]) {
            if ((chosenShowfood.dwCookWayProp&cookway.dwCWID)==cookway.dwCWID) {
                orderfood.dwSelCookWay=cookway.dwCWID;
                break;
            }
        }
        orderfood.szSelSubFood=@"";
        orderfood.szSelFlavor=@"";
        orderfood.dwQuantity=chosenShowfood.dwDefQuantity;
        orderfood.dwFoodPrice=chosenShowfood.dwTotalPrice;
        orderfood.dwCookPrice=0;
        orderfood.dwSubFoodPrice=0;
        orderfood.dwFlavorPrice=0;
        orderfood.dwFoodDiscount=chosenShowfood.dwDiscount;
        orderfood.dwSubFoodDiscount=0;
        [temp addObject:orderfood];
    }
    self.orderFoods=temp;
}
-(void)setupData{
    NSMutableArray*temp=[NSMutableArray array];
    for (int i=0; i<self.showfood.ChosenFoods.count; i++) {
        ChosenFood*chosenfood=self.showfood.ChosenFoods[i];
        NSArray*array=[ShowFood bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"dwShowFoodID"),bg_sqlValue(@(chosenfood.dwShowFoodID))]];
        ShowFood*showfood=[array firstObject];
        if (showfood.dwSoldProp==2) {
            showfood.dwSoldPrice=roundf(chosenfood.dwQuantity*showfood.dwUnitPrice/1000.0);
            showfood.dwDefQuantity=0;
        }else if (chosenfood.dwQuantity>1){
            showfood.dwDefQuantity=chosenfood.dwQuantity;
        }
        [temp addObject: showfood];
    }
    self.showfoods=temp;
}
-(void)setupBottomView{
    UIView*bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-64-50, kScreenW, 50)];
    bottomView.backgroundColor=KmainColor;
    [self.view addSubview:bottomView];
    
    UILabel*totalL=[[UILabel alloc]init];
    totalL.frame=CGRectMake(20, 0, kScreenW/2, 50);
    totalL.textColor=[UIColor whiteColor];
    totalL.text=[NSString stringWithFormat:@"合计:$%.2f(优惠:$%.2f)",self.showfood.dwSoldPrice/100.0,self.showfood.dwDiscount/100.0];
    self.totalL=totalL;
    [bottomView addSubview:totalL];
    
    UIButton*didBtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenW*2/3, 0, kScreenW/3, 50)];
    [didBtn setTitle:@"选好了" forState:UIControlStateNormal];
    [didBtn addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:didBtn];
}
-(void)didClick:(UIButton*)sender{
    self.showfood.orderNum=self.showfood.orderNum+1;
    if (self.VCBlock) {
        self.VCBlock(self.orderFoods);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showfood.ChosenFoods.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PackageExchangeCell*cell=[PackageExchangeCell initWithTableView:tableView];
    cell.showfood=self.showfoods[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath==self.cellIndexPath&&!self.isRepeatClick) {
        return self.cellH;
    }else{
        return 50;
    }
    
   
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PackageExchangeCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    
    if (self.selectedRow==indexPath.row&&!self.isRepeatClick) {
        self.cellIndexPath=nil;
        self.isRepeatClick=YES;
        for (UIView*view in cell.contentView.subviews) {
            if ([view isKindOfClass:[UIButton class]]&&view.tag!=999) {
                 [view removeFromSuperview];
            }
           
        }
    }else{
        //食物属性选择
        self.isRepeatClick=NO;
        ShowFood*food=self.showfoods[indexPath.row];
        if (food.dwIncSubFood||food.dwFlavorProp) {

             ChosenFoodPropView*propview=[[ChosenFoodPropView alloc]initWithShowFood:food isPackage:YES];
            propview.delegate=self;
            [self.navigationController.view addSubviewWithAnimation:propview];
        }
        if (food.dwDefQuantity>1) {
            return;
        }
        self.oldFoodSoldPrice=food.dwSoldPrice;
        NSArray*sameGroupfoods=[ShowFood bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"dwGroupID"),bg_sqlValue(@(food.dwGroupID))]];
        self.sameGroupFoods=sameGroupfoods;
       //如果有展开的食物，删除
        if (self.selectedRow!=indexPath.row) {
            NSIndexPath*oldIndexPath=[NSIndexPath indexPathForRow:self.selectedRow inSection:0];
            PackageExchangeCell*cell=[tableView cellForRowAtIndexPath:oldIndexPath];
            for (UIView*view in cell.contentView.subviews) {
                if ([view isKindOfClass:[UIButton class]]&&view.tag!=999) {
                    [view removeFromSuperview];
                }
                
            }
        }
        CGFloat space=20;
        CGFloat btnW=(kScreenW-4*space)/3;
        CGFloat btnH=120;
        for (int i=0; i<sameGroupfoods.count; i++) {
            ShowFood*showfood=sameGroupfoods[i];
            UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(space+(i%3)*(btnW+space), 60+(i/3)*(btnH+10), btnW, btnH)];
            btn.layer.masksToBounds=YES;
            btn.layer.cornerRadius=5;
            [btn setTitleColor:KmainColor forState:UIControlStateNormal];
            btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            if (showfood.dwShowFoodID==food.dwShowFoodID) {
                btn.selected=YES;

            }
            if (showfood.dwSoldProp==2&&showfood.dwDefQuantity==0) {
                for (int j=0; j<self.showfood.ChosenFoods.count; j++) {
                    ChosenFood*chosenfood=self.showfood.ChosenFoods[j];
                    if (showfood.dwShowFoodID==chosenfood.dwShowFoodID) {
                        showfood.dwSoldPrice=roundf(chosenfood.dwQuantity*showfood.dwUnitPrice/1000.0) ;
                    }
                }
            }
            [btn setTitle:[NSString stringWithFormat:@"%@\n$%.2f",showfood.szDispName,showfood.dwSoldPrice/100.0]forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn setBackgroundImage:[self imageWithColor:KmainColor] forState:UIControlStateSelected];
            [btn setBackgroundImage:[self imageWithColor:[UIColor yellowColor]] forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont systemFontOfSize:12];
            [btn addTarget:self action:@selector(exchangefood:) forControlEvents:UIControlEventTouchUpInside];
            
            btn.tag=100+i;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [cell.contentView addSubview:btn];
            });
           
            self.cellH=btn.frame.origin.y+btn.frame.size.height+10;
        }

        self.cellIndexPath=indexPath;
        self.selectedRow=indexPath.row;
    }
    
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}
-(void)exchangefood:(UIButton*)button{
  
    NSIndexPath*indexPath=[NSIndexPath indexPathForRow:self.selectedRow inSection:0];
    PackageExchangeCell*cell=[self.tableView cellForRowAtIndexPath:indexPath];
    for (UIButton *btn in cell.contentView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.selected=NO;
        }
    }
    button.selected=YES;
    
    ShowFood*exchangeFood=self.sameGroupFoods[button.tag-100];
    exchangeFood.dwDefQuantity=1;
    NSMutableArray*tempArray=[NSMutableArray arrayWithArray:self.showfoods];
    [tempArray replaceObjectAtIndex:self.selectedRow withObject:exchangeFood];
    self.showfoods=tempArray;
    [self.tableView reloadData];
    DLog(@"%ld",self.oldFoodSoldPrice);
    NSInteger total=self.showfood.dwSoldPrice-self.oldFoodSoldPrice+exchangeFood.dwSoldPrice;
    if (total<self.showfood.dwMinPrice) {
        total=self.showfood.dwMinPrice;
    }
    
    self.totalL.text=[NSString stringWithFormat:@"合计:%.2f(优惠:$%.2f)",total/100.0,self.showfood.dwDiscount/100.0];
    if (exchangeFood.dwIncSubFood||exchangeFood.dwFlavorProp) {
        ChosenFoodPropView*propview=[[ChosenFoodPropView alloc]initWithShowFood:exchangeFood isPackage:YES];
        propview.delegate=self;
        [self.navigationController.view addSubviewWithAnimation:propview];
    }
    
}
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f); //宽高 1.0只要有值就够了
    UIGraphicsBeginImageContext(rect.size); //在这个范围内开启一段上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);//在这段上下文中获取到颜色UIColor
    CGContextFillRect(context, rect);//用这个颜色填充这个上下文
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//从这段上下文中获取Image属性,,,结束
    UIGraphicsEndImageContext();
    
    return image;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
    return subPrice;
}

-(NSIndexPath *)cellIndexPath{
    if (!_cellIndexPath) {
        _cellIndexPath=[[NSIndexPath alloc]init];
    }
    return _cellIndexPath;
}
-(NSArray *)orderFoods{
    if (!_orderFoods) {
        _orderFoods=[NSArray array];
    }
    return _orderFoods;
}
@end
