//
//  OrdersViewController.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/27.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "OrdersViewController.h"
#import "UniHttpTool.h"
#import "ShowGroup.h"
#import <BGFMDB.h>
#import "ShowFood.h"
#import "FoodKindTest.h"
#import <MJExtension.h>
#import "MBProgressHUD+MJ.h"
#import "FoodTableViewCell.h"
#import "OrderBottonView.h"
#import "JhtAnimationTools.h"
#import "OrderFood.h"
#import "PackageOrderViewController.h"
#import "ShopSubFood.h"
#import "ShopCookway.h"
#import "ShopFlavor.h"
#import "PropSelectView.h"
#import "OrderView.h"
#import "OrderPackageViewController.h"
@interface OrdersViewController ()<UITableViewDelegate,UITableViewDataSource,FoodTableViewCellDelegate,JhtAnimationToolsDelegate,PropSelectViewDelegate,OrderBottonViewDelegate,OrderViewDelegate>
// 用来保存当前左边tableView选中的行数
@property (strong, nonatomic) NSIndexPath *currentSelectIndexPath;
@property (weak, nonatomic) UITableView *leftTableView;
@property (weak, nonatomic) UITableView *rightTableView;
@property(nonatomic,strong)NSMutableArray*foodKindArr;

@property(nonatomic,strong)NSArray*showFoodArr;
@property(nonatomic,strong)NSArray*showGroupArr;
@property(nonatomic,strong)NSMutableArray*orderFoods;

/**
 底部view
 */
@property(nonatomic,weak)OrderBottonView*bottomView;

@property(nonatomic,weak)OrderView*orderview;


/**
 购物车食物索引，一直往上增长，删除购物车食物在添加也增加
 */
@property(nonatomic,assign)NSInteger foodIndex;

@end

@implementation OrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseTableView];
    self.view.backgroundColor=[UIColor whiteColor];
    [self setupData2];
    
    //底部view
    OrderBottonView *bottomView=[[OrderBottonView alloc]initWithFrame:CGRectMake(0, kScreenH-64-49, kScreenW, 49)];
    [self.view addSubview:bottomView];
    bottomView.delegate=self;
    self.bottomView=bottomView;
}

/**
 设值
 */
-(void)setData{
    NSMutableArray*temp=[NSMutableArray array];
    for (int i=0; i<self.showGroupArr.count; i++) {
        ShowGroup*showGroup=self.showGroupArr[i];
        NSMutableArray*kindFoodArr=[NSMutableArray array];
        for (int j=0; j<self.showFoodArr.count; j++) {
            ShowFood*showFood=self.showFoodArr[j];
            
            if (showFood.dwGroupID==showGroup.dwGroupID) {
                if (showFood.dwSoldPrice>0) {
                     [kindFoodArr addObject:showFood];
                }
            }
        }
        FoodKindTest*test=[[FoodKindTest alloc]init];
        test.foodKindName=showGroup.szGroupName;
        test.foodArr=kindFoodArr;
        test.showGroup=showGroup;
        [temp addObject:test];
    }
    self.foodKindArr=temp;
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
    
}

/**
 从本地获取数据
 */
-(void)setupData2{
    self.showGroupArr=[ShowGroup bg_findAll:nil];
    ShowGroup*showgroup=[self.showGroupArr firstObject];

    self.showFoodArr=bg_executeSql(@"select * from ShowFood order by bg_dwDispOrder", @"ShowFood", [ShowFood class]);
    [self setData];
    
    //如果数据大于一天就更新
    if (([CommonFunc getCurrentDate]-[CommonFunc getTimestanps:showgroup.bg_updateTime])>86400) {
        [UniHttpTool getwithparameters:nil option:GetShowGroup success:^(id json) {
            for (NSDictionary*dict in json[@"data"]) {
                ShowGroup*showgroup=[ShowGroup mj_objectWithKeyValues:dict];
                [showgroup bg_saveOrUpdate];
            }
            
            [UniHttpTool getwithparameters:nil option:GetShowFood success:^(id json) {
                for (NSDictionary*dict in json[@"data"]) {
                    ShowFood*showFood=[ShowFood mj_objectWithKeyValues:dict];
                    [showFood bg_saveOrUpdate];
                }
            }];
        }];
    }
    
}

/**
 从服务器获取数据
 */
-(void)setupData{
    
    [MBProgressHUD showHUDAddedTo:nil animated:YES];
    [UniHttpTool getwithparameters:nil option:GetShowGroup success:^(id json) {
        NSMutableArray*temp=[NSMutableArray array];
        for (NSDictionary*dict in json[@"data"]) {
            ShowGroup*showgroup=[ShowGroup mj_objectWithKeyValues:dict];
            [temp addObject:showgroup];
            //插入数据库
            [showgroup bg_saveOrUpdate];
            
        }
        self.showGroupArr=temp;
        [UniHttpTool getwithparameters:nil option:GetShowFood success:^(id json){
            NSMutableArray*foodTemp=[NSMutableArray array];
            for (NSDictionary*dict in json[@"data"]) {
                ShowFood*showFood=[ShowFood mj_objectWithKeyValues:dict];
                //插入数据库
                [showFood bg_saveOrUpdate];
                [foodTemp addObject:showFood];
            }
            self.showFoodArr=foodTemp;
            [self setData];
            [MBProgressHUD hideHUD];
        }];
    }];
   
}

#pragma mark - private
- (void)setBaseTableView {
    UITableView *leftTableView = [[UITableView alloc] initWithFrame:(CGRect){0, 0,kScreenW * 0.25f, kScreenH-64-49}];
    [self.view addSubview:leftTableView];
    leftTableView.tableFooterView=[[UIView alloc]init];
    self.leftTableView = leftTableView;
    self.leftTableView.showsVerticalScrollIndicator=NO;
    
    UITableView *rightTableView = [[UITableView alloc] initWithFrame:(CGRect){kScreenW * 0.25f, 0, kScreenW * 0.75f, kScreenH-64-49}];
    rightTableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:rightTableView];
    self.rightTableView = rightTableView;
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
    if (self.foodKindArr.count<1) {
        return;
    }
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.rightTableView.indexPathsForVisibleRows.firstObject.section inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    // NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 重新选中一下当前选中的行数，不然会有bug
    if (self.currentSelectIndexPath) {
        self.currentSelectIndexPath = nil;
    }
}
//基础食物加入购物车
-(void)addCartWithCell:(UITableViewCell*)cell{
    NSIndexPath*indexPath=[self.rightTableView indexPathForCell:cell];
    FoodKindTest*foodkind=self.foodKindArr[indexPath.section];
    NSArray*tempArr=foodkind.foodArr;
    ShowFood*showfood=tempArr[indexPath.row];
    
    OrderFood*orderfood=[[OrderFood alloc]init];
    orderfood.dwFoodIndex=self.foodIndex+1;
    self.foodIndex=self.foodIndex+1;
    orderfood.szSelFlavor=@"";
    orderfood.szSelSubFood=@"";
    orderfood.szSelCookWay=@"";
    orderfood.dwShowFoodID=showfood.dwShowFoodID;
    orderfood.dwSelCookWay=0;
    orderfood.dwFoodType=1;
    orderfood.dwParentIndex=0;
    orderfood.dwQuantity=1;
    orderfood.dwFoodPrice=showfood.dwSoldPrice;
    orderfood.dwCookPrice=0;
    orderfood.dwSubFoodPrice=0;

    orderfood.dwFlavorPrice=0;
    orderfood.dwFoodDiscount=0;
    orderfood.dwSubFoodDiscount=0;
    [self.orderFoods addObject:orderfood];
    orderfood.szShowFoodName=showfood.szDispName;
    orderfood.dwGroupID=showfood.dwGroupID;
    DLog(@"%@",orderfood.mj_keyValues);
}
#pragma mark cell代理
-(void)ppNumDidClickWithCell:(FoodTableViewCell*)cell withIncreaseNum:(CGFloat)num Status:(BOOL)status{
    NSIndexPath*indexPath=[self.rightTableView indexPathForCell:cell];
    FoodKindTest*foodkind=self.foodKindArr[indexPath.section];
    NSArray*tempArr=foodkind.foodArr;
    ShowFood*showfood=tempArr[indexPath.row];
    //如果是添加食物
    if (status) {
        showfood.orderNum=showfood.orderNum+1;
        CGRect cellFrame=[self.rightTableView rectForRowAtIndexPath:indexPath];
        CGRect lastrect = [self.rightTableView  convertRect:cellFrame toView:[self.rightTableView  superview]];
        JhtAnimationTools*tools=[[JhtAnimationTools alloc]init];
        tools.toolsDelegate=self;
        CGRect rect=CGRectMake(kScreenW-35, lastrect.origin.y+65, 10, 10);
        UIImageView*aniImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"round"]];
        aniImage.frame=CGRectMake(rect.origin.x, rect.origin.y, 10, 10);
        [tools aniStartShopCarAnimationWithStartRect:rect withImageView:aniImage withView:self.view withEndPoint:CGPointMake(30, kScreenH-40-65) withControlPoint:CGPointMake(rect.origin.x-80, rect.origin.y-80) withStartToEndSpacePercentage:0 withExpandAnimationTime:0 withNarrowAnimationTime:0.4 withAnimationValue:1];
        if (num>1) {
            for (int i=0; i<self.orderFoods.count; i++) {
                OrderFood*orderfood=self.orderFoods[i];
                if (orderfood.dwShowFoodID==showfood.dwShowFoodID) {
                    orderfood.dwQuantity=orderfood.dwQuantity+1;
                }
            }
        }else{
            [self addCartWithCell:cell];
        }
        
    }else{
        showfood.orderNum=showfood.orderNum-1;
        for (int i=0; i<self.orderFoods.count; i++) {
            OrderFood*orderfood=self.orderFoods[i];
            if (orderfood.dwShowFoodID==showfood.dwShowFoodID) {
                if (orderfood.dwQuantity==1) {
                    [self.orderFoods removeObject:orderfood];
                }else{
                    orderfood.dwQuantity=orderfood.dwQuantity-1;
                }
            }
        }
        self.bottomView.orderfoods=self.orderFoods;
    }
    
}


-(void)FoodTableViewCellOrderPackages:(FoodTableViewCell *)cell withShowfood:(ShowFood *)showfood{
    NSIndexPath*indexPath=[self.rightTableView indexPathForCell:cell];
    //选择套餐
    if (showfood.dwShowProp==2) {
//        PackageOrderViewController*package=[[PackageOrderViewController alloc]init];
//        package.VCBlock = ^(NSArray *orderfoods) {
//            [self.orderFoods addObjectsFromArray:orderfoods];
//            self.foodIndex=self.foodIndex+orderfoods.count;
//            self.bottomView.orderfoods=self.orderFoods;
//
//            NSArray<NSIndexPath*>*indexPathArray=@[indexPath];
//            [self.rightTableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
//
//        };
//        package.orderfoodscount=self.foodIndex;
//        package.showfood=showfood;
        OrderPackageViewController*package=[[OrderPackageViewController alloc]init];
        package.foodIndex=self.foodIndex;
        package.showfood=showfood;
        package.VCBlock = ^(NSArray *orderfoods) {
            DLog(@"%@",orderfoods);
            [self.orderFoods addObjectsFromArray:orderfoods];
            self.foodIndex=self.foodIndex+orderfoods.count;
            self.bottomView.orderfoods=self.orderFoods;
            [self.rightTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:package animated:YES];
        //选择口味
    }else{
        PropSelectView*prop=[[PropSelectView alloc]initWithShowFood:showfood withOrderfoods:self.orderFoods isPackage:NO];
        prop.indexPath=indexPath;
        prop.delegate=self;
        [self.navigationController.view addSubview:prop];
    }
}

//加入购物车
-(void)PropSelectViewFinish:(OrderFood *)orderfood withView:(UIView*)view withIndexPath:(NSIndexPath *)indexPath withTag:(NSInteger)tag{
    FoodKindTest*foodkind=self.foodKindArr[indexPath.section];
    NSArray*tempArr=foodkind.foodArr;
    ShowFood*showfood=tempArr[indexPath.row];
    if (tag==-1) {
        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
        CGRect viewRect=[view convertRect: view.bounds toView:window];
        orderfood.dwFoodIndex=self.foodIndex+1;
        [self.orderFoods addObject:orderfood];
        
        JhtAnimationTools*tools=[[JhtAnimationTools alloc]init];
        tools.toolsDelegate=self;
        CGRect rect=CGRectMake(viewRect.origin.x+40, viewRect.origin.y+10, 10, 10);
        UIImageView*aniImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"round"]];
        aniImage.frame=CGRectMake(rect.origin.x, rect.origin.y, 10, 10);
        [tools aniStartShopCarAnimationWithStartRect:rect withImageView:aniImage withView:self.navigationController.view withEndPoint:CGPointMake(30, kScreenH-40) withControlPoint:CGPointMake(rect.origin.x-80, rect.origin.y-80) withStartToEndSpacePercentage:0 withExpandAnimationTime:0 withNarrowAnimationTime:0.4 withAnimationValue:1];
        showfood.orderNum=showfood.orderNum+1;
         DLog(@"%@",orderfood.szSelSubFood);
    }else if(tag==1){
        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
        CGRect viewRect=[view convertRect: view.bounds toView:window];
        JhtAnimationTools*tools=[[JhtAnimationTools alloc]init];
        tools.toolsDelegate=self;
        CGRect rect=CGRectMake(viewRect.origin.x+40, viewRect.origin.y+10, 10, 10);
        UIImageView*aniImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"round"]];
        aniImage.frame=CGRectMake(rect.origin.x, rect.origin.y, 10, 10);
        [tools aniStartShopCarAnimationWithStartRect:rect withImageView:aniImage withView:self.navigationController.view withEndPoint:CGPointMake(30, kScreenH-40) withControlPoint:CGPointMake(rect.origin.x-80, rect.origin.y-80) withStartToEndSpacePercentage:0 withExpandAnimationTime:0 withNarrowAnimationTime:0.4 withAnimationValue:1];
    }else if (tag==0){
         DLog(@"%@",self.orderFoods);
        for (OrderFood*orderfood in self.orderFoods) {
            if (orderfood.dwQuantity==0) {
                [self.orderFoods removeObject:orderfood];
                DLog(@"%@",orderfood.szSelSubFood);
                break;
            }
        }DLog(@"%@",self.orderFoods);
         self.bottomView.orderfoods=self.orderFoods;
    }//刷新
 
    [self.rightTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    
}

-(void)JhtAnimationWithType:(NSInteger)type isDidStop:(BOOL)isStop{
    self.bottomView.orderfoods=self.orderFoods;
}

-(void)getProps{
}
-(NSMutableArray *)orderFoods{
    if (!_orderFoods) {
        _orderFoods=[NSMutableArray array];
    }
    return _orderFoods;
}

-(void)OrderBottonViewClick:(id)sender{
    if (!self.orderFoods.count) {
        return;
    }
    if ([self.navigationController.view.subviews containsObject:self.orderview]) {
        [self.orderview removeFromSuperview];
    }else{
        CGFloat H= kScreenH-49;
        if (KIsiPhoneX) {
            H=kScreenH-49+24;
        }
        OrderView*orderview=[[OrderView alloc]initWithFrame:CGRectMake(0, 0, kScreenW,H)];
        orderview.delegate=self;
        self.orderview=orderview;
        orderview.orderfoods=self.orderFoods;
        [self.navigationController.view addSubview:orderview];
    }
}
#pragma mark OrderViewDelegate
//清空购物车
-(void)OrderViewEmpty:(UIButton *)button{
    [self.orderview removeFromSuperview];
    [self.orderFoods removeAllObjects];
    self.bottomView.orderfoods=self.orderFoods;
    for (ShowFood*showfood in self.showFoodArr) {
        showfood.orderNum=0;
    }
    [self.rightTableView reloadData];
}
//点击加号减号
-(void)OrderViewActionWithOrderfood:(OrderFood *)orderfood withStatus:(BOOL)status withNum:(NSInteger)num{
    if (num==0) {
        if (orderfood.dwFoodType==4) {
            NSMutableArray*temp=[NSMutableArray array];
            for (OrderFood*chosenOrderfood in self.orderFoods) {
                if (chosenOrderfood.dwParentIndex==orderfood.dwFoodIndex) {
                    [temp addObject:chosenOrderfood];
                }
            }
            [self.orderFoods removeObjectsInArray:temp];
        }
        [self.orderFoods removeObject:orderfood];
    }else{
       
        status?(orderfood.dwQuantity=orderfood.dwQuantity+1):(orderfood.dwQuantity=orderfood.dwQuantity-1);
    }
    for (int i=0; i<self.showFoodArr.count; i++) {
        ShowFood*showfood=self.showFoodArr[i];
        if (showfood.dwShowFoodID==orderfood.dwShowFoodID) {
            status?(showfood.orderNum=showfood.orderNum+1):(showfood.orderNum=showfood.orderNum-1);
            break;
        }
    }
    [self.rightTableView reloadData];
    self.bottomView.orderfoods=self.orderFoods;
}
@end
