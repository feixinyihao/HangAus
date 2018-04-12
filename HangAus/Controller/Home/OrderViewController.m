//
//  ViewController.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/2/7.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "OrderViewController.h"
#import "FoodKindTest.h"
#import "FoodTableViewCell.h"
#import "CommonFunc.h"
#import <MapKit/MapKit.h>
#import "UniHttpTool.h"
#import "ShowFood.h"
#import <MJExtension.h>
#import "ShowGroup.h"
#import "DataBase.h"
#import "MJRefresh.h"
#import "NewFoodViewController.h"
#import "MBProgressHUD+MJ.h"
#import "JhtAnimationTools.h"
#import "CartView.h"
#import <PPNumberButton.h>
#import "ChosenFoodPropView.h"
#import "ShopFlavor.h"
#import "ShopCookway.h"
#import "OrderFood.h"
#import "OrderInfo.h"
#import "PayViewController.h"
#import "PackageOrderViewController.h"
@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource,FoodTableViewCellDelegate,JhtAnimationToolsDelegate,ChosenFoodPropViewDelegate>
// 用来保存当前左边tableView选中的行数
@property (strong, nonatomic) NSIndexPath *currentSelectIndexPath;
@property (weak, nonatomic) UITableView *leftTableView;
@property (weak, nonatomic) UITableView *rightTableView;
@property(nonatomic,strong)NSMutableArray*foodKindArr;

@property(nonatomic,strong)NSArray*showFoodArr;
@property(nonatomic,strong)NSArray*showGroupArr;
@property(nonatomic,assign)NSInteger orderNum;
@property(nonatomic,weak)CartView*cartView;
@property(nonatomic,weak)UILabel*totalPrice;
@property(nonatomic,strong)NSMutableArray*orderShowfood;

@property(nonatomic,weak)UIButton*payBtn;

@property(nonatomic,weak)UIView*orderBackgroudView;

@property(nonatomic,weak)UIView*shadowView;

@property(nonatomic,strong)NSArray*shopFlavorArray;
@property(nonatomic,strong)NSArray*shopCookWayArray;

@property(nonatomic,strong)NSMutableArray*orderFoods;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    // [self setBaseTableView];
    self.title=@"Order";

    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title =@"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    [self setBaseTableView];
    [self setupData2];
    [self setupBottom];
    
    [self setupshopFlavor];
    
    
}
-(void)setupshopFlavor{
    [UniHttpTool getwithparameters:nil option:GetShopFlavor success:^(id json) {
        if ([json[@"ret"] integerValue]==0) {
            NSMutableArray*temp=[NSMutableArray array];
            for (NSDictionary*dict in json[@"data"]) {
                ShopFlavor*shopflavor=[ShopFlavor mj_objectWithKeyValues:dict];
                [temp addObject:shopflavor];
            }
            self.shopFlavorArray=temp;
        }
        
    }];
    
    [UniHttpTool getwithparameters:nil option:GetShopCookWay success:^(id json) {
        if ([json[@"ret"] integerValue]==0) {
            NSMutableArray*temp=[NSMutableArray array];
            for (NSDictionary*dict in json[@"data"]) {
                ShopCookway*cookway=[ShopCookway mj_objectWithKeyValues:dict];
                [temp addObject:cookway];
            }
            self.shopCookWayArray=temp;
        }
        
    }];
}
-(void)setupBottom{
    UIView*shadowview=[[UIView alloc]init];
    UITapGestureRecognizer* shadowTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowTap:)];
    [shadowview addGestureRecognizer:shadowTap];
    shadowview.frame=CGRectMake(0, 0, kScreenW, kScreenH);
    shadowview.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.4];
    self.shadowView=shadowview;
    self.shadowView.hidden=YES;
    [self.navigationController.view addSubview:self.shadowView];
    
     UIView*backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-64, kScreenW, 50*self.orderShowfood.count)];
    self.orderBackgroudView=backgroundView;
    [self.view addSubview:self.orderBackgroudView];
    UIView*bottom=[[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-64-49, kScreenW, 49)];
    bottom.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.4];
    [self.view addSubview:bottom];
    CartView*cart=[[CartView alloc]initWithFrame:CGRectMake(5, -5, 40, 40)];
    self.cartView=cart;
    [bottom addSubview:self.cartView];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [bottom addGestureRecognizer:singleTap];
    
    UILabel*totalPrice=[[UILabel alloc]initWithFrame:CGRectMake(80, 0, 100, 30)];
    totalPrice.textColor=[UIColor whiteColor];
    totalPrice.font=[UIFont systemFontOfSize:20];
    self.totalPrice=totalPrice;
    [bottom addSubview:self.totalPrice];
    
    UIButton*payBtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenW-80, 0, 80, 49)];
    [payBtn setTitle:@"选好了" forState:UIControlStateNormal];
    [payBtn setBackgroundColor:KmainColor];
    [payBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    payBtn.hidden=YES;
    self.payBtn=payBtn;
    [bottom addSubview:self.payBtn];
    
}
-(void)shadowTap:(id)sender{
    [UIView animateWithDuration:0.25 animations:^{
        self.orderBackgroudView.frame=CGRectMake(0, kScreenH-64, kScreenW, 50*self.orderShowfood.count);
        for (UIView*view in self.orderBackgroudView.subviews) {
            [view removeFromSuperview];
        }
    }];
    self.shadowView.hidden=YES;
}
-(void)handleSingleTap:(id)sender{
    if (self.orderShowfood.count>0) {
        
        self.orderBackgroudView.backgroundColor=[UIColor whiteColor];
        for (int i=0; i<self.orderShowfood.count; i++) {
            ShowFood*showfood=self.orderShowfood[i];
            UIView*cellView=[[UIView alloc]initWithFrame:CGRectMake(0, i*50, kScreenW, 50)];
            UILabel*nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, kScreenW-120, 50)];
            nameLabel.font=[UIFont systemFontOfSize:15];
            nameLabel.text=[NSString stringWithFormat:@"%@  $%.2f",showfood.szDispName,showfood.dwUnitPrice*showfood.orderNum/100.0];
            [cellView addSubview:nameLabel];
            [self.orderBackgroudView addSubview:cellView];
            
            PPNumberButton*ppBtn=[[PPNumberButton alloc]initWithFrame:CGRectMake(kScreenW-100, 10, 80, 20)];
            ppBtn.increaseImage = [UIImage imageNamed:@"increase"];
            ppBtn.decreaseImage = [UIImage imageNamed:@"decrease"];
            ppBtn.currentNumber=showfood.orderNum;
            [cellView addSubview:ppBtn];
            
            
        }
        self.shadowView.alpha=0;
        [UIView animateWithDuration:0.25 animations:^{
            self.orderBackgroudView.frame=CGRectMake(0, kScreenH-64-49-50*self.orderShowfood.count, kScreenW, 50*self.orderShowfood.count);
            self.shadowView.alpha=0.8;
        }];
        
        self.shadowView.frame=CGRectMake(0, 0, kScreenW, kScreenH-49-50*self.orderShowfood.count);
        self.shadowView.hidden=NO;
    }
}
-(void)setupData2{
    self.showGroupArr=[[DataBase sharedDataBase]getAllShowGroup];
    self.showFoodArr=[[DataBase sharedDataBase]getAllShowFood];
    NSMutableArray*temp=[NSMutableArray array];
    for (int i=0; i<self.showGroupArr.count; i++) {
        ShowGroup*showGroup=self.showGroupArr[i];
        NSMutableArray*kindFoodArr=[NSMutableArray array];
        for (int j=0; j<self.showFoodArr.count; j++) {
            ShowFood*showFood=self.showFoodArr[j];
            
            if (showFood.dwGroupID==showGroup.dwGroupID) {
                [kindFoodArr addObject:showFood];
            }
        }
        FoodKindTest*test=[[FoodKindTest alloc]init];
        test.foodKindName=showGroup.szGroupName;
        test.foodArr=kindFoodArr;
        test.showGroup=showGroup;
        [temp addObject:test];
    }
    self.foodKindArr=temp;
    if (self.foodKindArr.count<1) {
        [self setupData];
    }
    
}
-(void)setupData{
    
    [MBProgressHUD showHUDAddedTo:nil animated:YES];
//    [[DataBase sharedDataBase]deleteAllShowFood];
//    [[DataBase sharedDataBase]deleteAllShowGroup];
//    [[DataBase sharedDataBase]deleteAllChosenFood];
    NSDictionary*parm=@{@"dwStat":@(2)};
    [UniHttpTool getwithparameters:parm option:GetShowGroup success:^(id json) {
        
        if ([json[@"ret"] integerValue]==0) {
            NSMutableArray*temp=[NSMutableArray array];
            ShowGroup*maxGroup=[[[DataBase sharedDataBase]getAllShowGroup] lastObject];
            for (NSDictionary*dict in json[@"data"]) {
                ShowGroup*showgroup=[ShowGroup mj_objectWithKeyValues:dict];
                [temp addObject:showgroup];
                if (showgroup.dwGroupID>maxGroup.dwGroupID) {
                   // [[DataBase sharedDataBase]addshowGroup:showgroup];
                }
            }
            self.showGroupArr=temp;
            [UniHttpTool getwithparameters:nil option:GetShowFood success:^(id json) {
                if ([json[@"ret"] intValue]==0) {
                    NSMutableArray*testArr=[NSMutableArray array];
                    ShowFood*maxShowFood=[[[DataBase sharedDataBase]getAllShowFood]lastObject];
                    for (int i=0; i<self.showGroupArr.count; i++) {
                        
                        ShowGroup*group=self.showGroupArr[i];
                        NSMutableArray*kindFoodArr=[NSMutableArray array];
                        NSMutableArray*foodtemp=[NSMutableArray array];
                        for (NSDictionary*dict in json[@"data"]) {
                            ShowFood*showFood=[ShowFood mj_objectWithKeyValues:dict];
                            if (showFood.dwGroupID==group.dwGroupID) {
                                
                                [kindFoodArr addObject:showFood];
                            }
                            
                            if (i==0&&showFood.dwShowFoodID>maxShowFood.dwShowFoodID) {
                                
                               // [[DataBase sharedDataBase] addShowFood:showFood];
                            }
                            
                            [foodtemp addObject:showFood];
                        }
                        self.showFoodArr=foodtemp;
                        FoodKindTest*test=[[FoodKindTest alloc]init];
                        test.foodArr=kindFoodArr;
                        test.foodKindName=group.szGroupName;
                        test.showGroup=group;
                        [testArr addObject:test];
                    }
                    self.foodKindArr=testArr;
                    [self.leftTableView reloadData];
                    [self.rightTableView reloadData];
                    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                }
            }];
            [MBProgressHUD hideHUDForView:nil animated:YES];
        }else{
            [MBProgressHUD hideHUDForView:nil animated:YES];
            KShowServerMessage(json[@"error"])
        }
    }];
}


#pragma mark - private
- (void)setBaseTableView {
    // leftTableView
    UITableView *leftTableView = [[UITableView alloc] initWithFrame:(CGRect){0, 0,kScreenW * 0.25f, kScreenH-64-49}];
    //    leftTableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:leftTableView];
    leftTableView.tableFooterView=[[UIView alloc]init];
    self.leftTableView = leftTableView;
    self.leftTableView.showsVerticalScrollIndicator=NO;
    
    // rightTableView
    UITableView *rightTableView = [[UITableView alloc] initWithFrame:(CGRect){kScreenW * 0.25f, 0, kScreenW * 0.75f, kScreenH-64-49}];
    rightTableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:rightTableView];
    self.rightTableView = rightTableView;
//    self.rightTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//        [self setupData];
//        [self.rightTableView.mj_header endRefreshing];
//        
//    }];
    // delegate && dataSource
    rightTableView.delegate = leftTableView.delegate = self;
    rightTableView.dataSource = leftTableView.dataSource = self;
    

    
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.leftTableView) {
        if (self.foodKindArr.count>0) {
            return 1;
        }else{
            return 0;
        }
        
        
    }
    return self.foodKindArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTableView){
        return self.foodKindArr.count;
    }else{
        if (self.foodKindArr.count>0) {
            FoodKindTest*foodkind=self.foodKindArr[section];
            NSArray*tempArr=foodkind.foodArr;
            return tempArr.count;
        }else{
            return 0;
        }
        
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.leftTableView){
        return nil;
    }else{
        FoodKindTest*foodkind=self.foodKindArr[section];
        return foodkind.foodKindName;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == self.leftTableView) {
        static NSString *ID = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        if (self.foodKindArr.count>0) {
            FoodKindTest*foodkind=self.foodKindArr[indexPath.row];
            cell.textLabel.text =foodkind.foodKindName;
            cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor=[UIColor whiteColor];
            cell.backgroundColor=KColor(233, 237, 240);
            cell.textLabel.font=[UIFont systemFontOfSize:15];
            cell.textLabel.numberOfLines=0;
        }
        return cell;
    }else {
        FoodTableViewCell*cell=[FoodTableViewCell initWithTableView:tableView];
        cell.delegate=self;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (self.foodKindArr.count>0) {
            FoodKindTest*foodkind=self.foodKindArr[indexPath.section];
            NSArray*tempArr=foodkind.foodArr;
            cell.isSales=YES;
            ShowFood*showfood=tempArr[indexPath.row];
            showfood.imagePath=@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1518005336571&di=fdbc1c5b14d803c6d14a3341bb067eae&imgtype=0&src=http%3A%2F%2Fimg.line0.com%2Fstatic%2Fimage%2F1703%2FSHNS0401428473271790.jpg";
            cell.food=showfood;
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 如果点击的是右边的tableView，不做任何处理
    if (tableView == self.rightTableView){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else{
        // 点击左边的tableView，设置选中右边的tableView某一行。左边的tableView的每一行对应右边tableView的每个分区
        //NSLog(@"%ld",indexPath.row);
        [self.rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] animated:YES scrollPosition:UITableViewScrollPositionTop];
        self.currentSelectIndexPath = indexPath;
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.leftTableView) {
        return 60;
    }else{
        return 110;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.leftTableView) return 0;
    return 20;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{// 监听tableView滑动
    [self selectLeftTableViewWithScrollView:scrollView];
    
}
- (void)selectLeftTableViewWithScrollView:(UIScrollView *)scrollView {
    if (self.currentSelectIndexPath) {
        return;
    }
    // 如果现在滑动的是左边的tableView，不做任何处理
    if ((UITableView *)scrollView == self.leftTableView) return;
    // 滚动右边tableView，设置选中左边的tableView某一行。indexPathsForVisibleRows属性返回屏幕上可见的cell的indexPath数组，利用这个属性就可以找到目前所在的分区
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.rightTableView.indexPathsForVisibleRows.firstObject.section inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    // NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 重新选中一下当前选中的行数，不然会有bug
    if (self.currentSelectIndexPath) {
        self.currentSelectIndexPath = nil;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray *)foodKindArr{
    if (!_foodKindArr) {
        _foodKindArr=[NSMutableArray array];
    }
    return _foodKindArr;
}




-(void)ppNumDidClickWithCell:(FoodTableViewCell *)cell withIncreaseStatus:(BOOL)status{
    
     NSIndexPath*indexPath=[self.rightTableView indexPathForCell:cell];
     FoodKindTest*foodkind=self.foodKindArr[indexPath.section];
     NSArray*tempArr=foodkind.foodArr;
     ShowFood*showfood=tempArr[indexPath.row];
    
    if (status) {
        if (!showfood.dwFlavorProp&&!showfood.dwCookWayProp&&!showfood.dwSubFoodProp) {
            showfood.orderNum=showfood.orderNum+1;
            CGRect cellFrame=[self.rightTableView rectForRowAtIndexPath:indexPath];
            CGRect lastrect = [self.rightTableView  convertRect:cellFrame toView:[self.rightTableView  superview]];
            JhtAnimationTools*tools=[[JhtAnimationTools alloc]init];
            tools.toolsDelegate=self;
            CGRect rect=CGRectMake(kScreenW-35, lastrect.origin.y+65, 10, 10);
            UIImageView*aniImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"round"]];
            aniImage.frame=CGRectMake(rect.origin.x, rect.origin.y, 10, 10);
            
            [tools aniStartShopCarAnimationWithStartRect:rect withImageView:aniImage withView:self.view withEndPoint:CGPointMake(30, kScreenH-40-65) withControlPoint:CGPointMake(rect.origin.x-80, rect.origin.y-80) withStartToEndSpacePercentage:0 withExpandAnimationTime:0 withNarrowAnimationTime:0.4 withAnimationValue:1];
            
            if (showfood.orderNum==1) {
                [self.orderShowfood addObject:showfood];
            }
            
            DLog(@"%@--%ld",self.orderShowfood,showfood.orderNum);
        }else{
            showfood.orderNum=showfood.orderNum-1;
            NSArray<NSIndexPath*>*indexArray=@[indexPath];
            [self.rightTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
            ChosenFoodPropView*propView=[[ChosenFoodPropView alloc]initWithShowFood:showfood withFlavorArray:self.shopFlavorArray withCookwayArray:self.shopCookWayArray];
            propView.delegate=self;
            [self.navigationController.view addSubview:propView];
           
        }
        
    }else{
        
      
        showfood.orderNum=showfood.orderNum-1;
        self.orderNum=self.orderNum-1;
        self.cartView.num=self.orderNum;
        [self.cartView reload];
       
        if (showfood.orderNum==0) {
            [self.orderShowfood removeObject:showfood];
        }
        if (self.orderShowfood.count==0) {
            [self.totalPrice setText:@""];
            self.payBtn.hidden=YES;
        }else{
            [self.totalPrice setText:[NSString stringWithFormat:@"$%.2f",[self returnPriceFromOrderFoods:self.orderShowfood]/100.0]];
        }
        DLog(@"%@--%ld",self.orderShowfood,showfood.orderNum);
    }
   
    
}
-(NSInteger)returnPriceFromOrderFoods:(NSArray*)orderfoods{
    NSInteger total=0;
    for (OrderFood*orderfood in orderfoods) {
        total=total+orderfood.dwFoodPrice+orderfood.dwCookPrice+orderfood.dwFlavorPrice+orderfood.dwSubFoodPrice-orderfood.dwFoodDiscount-orderfood.dwSubFoodDiscount;
    }
    return total;
}
-(void)JhtAnimationWithType:(NSInteger)type isDidStop:(BOOL)isStop{

    self.orderNum=self.orderNum+1;
    self.cartView.num=self.orderNum;
    [UIView animateWithDuration:0.1 animations:^{
        self.cartView.transform=CGAffineTransformMakeScale(1.2,1.2);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.1 animations:^{
                self.cartView.transform=CGAffineTransformMakeScale(1,1);
            }];
           
        });
    }];
    [self.cartView reload];
    if (self.orderFoods.count>0) {
        self.payBtn.hidden=NO;
    }
    [self.totalPrice setText:[NSString stringWithFormat:@"$%.2f",[self returnPriceFromOrderFoods:self.orderFoods]/100.0]];
    
}

-(void)ChosenFoodPropViewOrderWithOrderFood:(OrderFood *)orderfood{
    orderfood.dwFoodIndex=self.orderFoods.count+1;
    NSDictionary*dict=orderfood.mj_keyValues;
    DLog(@"%@",dict);
    JhtAnimationTools*tools=[[JhtAnimationTools alloc]init];
    tools.toolsDelegate=self;
    CGRect rect=CGRectMake(kScreenW-100, kScreenH-200, 10, 10);
    UIImageView*aniImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"round"]];
    aniImage.frame=CGRectMake(rect.origin.x, rect.origin.y, 10, 10);
    [tools aniStartShopCarAnimationWithStartRect:rect withImageView:aniImage withView:self.navigationController.view withEndPoint:CGPointMake(30, kScreenH-40) withControlPoint:CGPointMake(rect.origin.x-60, rect.origin.y-60) withStartToEndSpacePercentage:0 withExpandAnimationTime:0 withNarrowAnimationTime:0.4 withAnimationValue:1];
    [self.orderFoods addObject:orderfood];
}
-(void)FoodTableViewCellOrderPackages:(FoodTableViewCell *)cell withShowfood:(ShowFood *)showfood{
  
    PackageOrderViewController*package=[[PackageOrderViewController alloc]init];
    package.showfood=showfood;
    [self.navigationController pushViewController:package animated:YES];
}
-(void)pay{

    [UniHttpTool getwithparameters:nil option:GetOrderno success:^(id json) {
        NSDictionary*dict=json[@"data"];
        OrderInfo*orderInfo=[[OrderInfo alloc]init];
        orderInfo.szOrderNo=dict[@"szOrderNo"];
        orderInfo.dwOrderType=10;
        orderInfo.dwPayType=1;
        orderInfo.dwOrderStat=18;
        orderInfo.dwOrderDate=[[self getCurrentDate:YES onlytime:NO] integerValue];
        orderInfo.dwOrderTime=[[self getCurrentDate:NO onlytime:YES] integerValue];
        orderInfo.dwTakeDate=[[self getCurrentDate:YES onlytime:NO] integerValue];
        orderInfo.dwWantTakeTime=[[self getCurrentDate:NO onlytime:YES] integerValue]+100;
        orderInfo.dwTotalPrice=[self returnPriceFromOrderFoods:self.orderFoods];
        orderInfo.szMobilePhone=@"13372827999";
        NSDictionary*parm=[orderInfo mj_keyValues];
        [parm setValue:[CommonFunc returnStringWithArray:self.orderFoods] forKey:@"OrderFoods"];
        [UniHttpTool postwithparameters:parm option:SetOrder success:^(id json) {
            
        }];
        
    }];
}
-(NSString*)getCurrentDate:(BOOL)onlyDate onlytime:(BOOL)onlyTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (onlyDate) {
        [formatter setDateFormat:@"YYYYMMdd"];
    }else if (onlyTime){
        [formatter setDateFormat:@"HHMM"];
    }else{
         [formatter setDateFormat:@"YYYYMMddHHMM"];
    }
    

    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];

    
    return currentTimeString;
    
}
-(NSMutableArray *)orderShowfood{
    if (!_orderShowfood) {
        _orderShowfood=[NSMutableArray array];
    }
    return _orderShowfood;
}
-(NSArray *)shopFlavorArray{
    if (!_shopFlavorArray) {
        _shopFlavorArray=[NSArray array];
    }
    return _shopFlavorArray;
}
-(NSArray *)shopCookWayArray{
    if (!_shopCookWayArray) {
        _shopCookWayArray=[NSArray array];
    }
    return _shopCookWayArray;
}
-(NSMutableArray *)orderFoods{
    if (!_orderFoods) {
        _orderFoods=[NSMutableArray array];
    }
    return _orderFoods;
}
@end

