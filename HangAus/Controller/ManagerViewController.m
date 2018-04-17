//
//  ViewController.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/2/7.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "ManagerViewController.h"

#import "FoodKindTest.h"
#import "FoodTableViewCell.h"
#import "CommonFunc.h"
#import <MapKit/MapKit.h>
#import "UniHttpTool.h"
#import "ShowFood.h"
#import <MJExtension.h>
#import "ShowGroup.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "EditFoodViewController.h"
#import <BGFMDB.h>
@interface ManagerViewController ()<UITableViewDelegate,UITableViewDataSource,FoodTableViewCellDelegate,CLLocationManagerDelegate>
// 用来保存当前左边tableView选中的行数
@property (strong, nonatomic) NSIndexPath *currentSelectIndexPath;
@property (weak, nonatomic) UITableView *leftTableView;
@property (weak, nonatomic) UITableView *rightTableView;
@property(nonatomic,strong)NSMutableArray*foodKindArr;

@property(nonatomic,weak)UIButton*locationBtn;

@property (strong,nonatomic) CLLocationManager* locationManager;

@property(nonatomic,strong)NSArray*showFoodArr;

@property(nonatomic,assign)BOOL isPop;

@property(nonatomic,strong)NSArray*showGroupArr;

@property(nonatomic,assign)NSInteger oldDispOrder;

@end

@implementation ManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isPop=NO;
   // [self setBaseTableView];
  
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title =@"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    UIButton*locationBtn=[[UIButton alloc]init];
   // [locationBtn setTitle:@"定位中..." forState:UIControlStateNormal];
    [locationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    locationBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    locationBtn.frame=CGRectMake(0, 0, 100, 40);
    self.locationBtn=locationBtn;
    UIBarButtonItem*leftButton=[[UIBarButtonItem alloc]initWithCustomView:self.locationBtn];
    self.navigationItem.leftBarButtonItem=leftButton;
    //[self startLocation];
    [self setBaseTableView];
    if ([ShowGroup bg_findAll:nil].count==0) {
        [self setupData];
    }else{
        [self setupData2];
    }
    DLog(@"%@",KLocalizedString(@"test"));
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isPop) {
        
        if (self.foodKindArr.count>0) {
            [self.rightTableView reloadData];
            [self.leftTableView reloadData];
            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
       
    }else{
        
    }
    _isPop=YES;
}
-(void)setupData2{
    self.showGroupArr=[ShowGroup bg_findAll:nil];
    ShowGroup*showgroup=[self.showGroupArr firstObject];
    self.showFoodArr=bg_executeSql(@"select * from ShowFood order by bg_dwDispOrder", @"ShowFood", [ShowFood class]);
    NSMutableArray*temp=[NSMutableArray array];
    for (int i=0; i<self.showGroupArr.count; i++) {
        ShowGroup*showGroup=self.showGroupArr[i];
         NSMutableArray*kindFoodArr=[NSMutableArray array];
        for (int j=0; j<self.showFoodArr.count; j++) {
            ShowFood*showFood=self.showFoodArr[j];
           
            if (showFood.dwGroupID==showGroup.dwGroupID) {
                if (!(showFood.dwSoldProp==2&&showFood.dwDefQuantity==0)) {
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
-(void)setupData{

    [MBProgressHUD showHUDAddedTo:nil animated:YES];
    [UniHttpTool getwithparameters:nil option:GetShowGroup success:^(id json) {
        
        if ([json[@"ret"] integerValue]==0) {
            NSMutableArray*temp=[NSMutableArray array];
            for (NSDictionary*dict in json[@"data"]) {
                ShowGroup*showgroup=[ShowGroup mj_objectWithKeyValues:dict];
                [temp addObject:showgroup];
                [showgroup bg_saveOrUpdate];
                
            }
            self.showGroupArr=temp;
            [UniHttpTool getwithparameters:nil option:GetShowFood success:^(id json) {
                if ([json[@"ret"] intValue]==0) {
                    NSMutableArray*testArr=[NSMutableArray array];
                    for (int i=0; i<self.showGroupArr.count; i++) {
                       
                        ShowGroup*group=self.showGroupArr[i];
                        NSMutableArray*kindFoodArr=[NSMutableArray array];
                         NSMutableArray*foodtemp=[NSMutableArray array];
                        for (NSDictionary*dict in json[@"data"]) {
                            ShowFood*showFood=[ShowFood mj_objectWithKeyValues:dict];
                            if (showFood.dwGroupID==group.dwGroupID) {
                                if (!(showFood.dwDefQuantity==0&&showFood.dwSoldProp==2)) {
                                    [kindFoodArr addObject:showFood];
                                }   
                               
                            }
                            if (i==0) {
                                 [showFood bg_saveOrUpdate];
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
    self.rightTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self setupData];
        [self.rightTableView.mj_header endRefreshing];
        
    }];
    // delegate && dataSource
    rightTableView.delegate = leftTableView.delegate = self;
    rightTableView.dataSource = leftTableView.dataSource = self;
    
   
    //UILongPressGestureRecognizer *longPressRight = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizedRight:)];
   // [self.rightTableView addGestureRecognizer:longPressRight];

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

- (void)longPressGestureRecognizedRight:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.rightTableView];
    NSIndexPath *indexPath = [self.rightTableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                self.oldDispOrder=indexPath.row+1;
                UITableViewCell *cell = [self.rightTableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [CommonFunc customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.rightTableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            if (indexPath.section==sourceIndexPath.section) {
                center.y = location.y;
            }
            
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]&&indexPath.section==sourceIndexPath.section) {
                
                // ... update data source.
                FoodKindTest*food=self.foodKindArr[indexPath.section];
                NSMutableArray*temp=food.foodArr;
                [temp exchangeObjectAtIndex:indexPath.row
                          withObjectAtIndex:sourceIndexPath.row];
                // ... move the rows.
                [self.rightTableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            
            
            // Clean up.
            UITableViewCell *cell = [self.rightTableView cellForRowAtIndexPath:sourceIndexPath];
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                if (self.oldDispOrder!=(sourceIndexPath.row+1)) {
                    FoodKindTest*food=self.foodKindArr[sourceIndexPath.section];
                    NSMutableArray*temp=food.foodArr;
                    ShowFood*showfood=temp[sourceIndexPath.row];
                    NSDictionary*parm=@{@"dwShopID":@(showfood.dwShopID),
                                        @"dwGroupID":@(showfood.dwGroupID),
                                        @"dwShowFoodID":@(showfood.dwShowFoodID),
                                        @"dwOldDispOrder":@(self.oldDispOrder),
                                        @"dwNewDispOrder":@(sourceIndexPath.row+1)};
                    
                    [UniHttpTool getwithparameters:parm option:SetShowFoodorder success:^(id json) {
                        
                    }];
                }
                cell.hidden = NO;
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            
            break;
        }
    }
}

-(void)edit{
//    EditFoodKindViewController*edit=[[EditFoodKindViewController alloc]init];
//    edit.foodWithGroupArr=self.foodKindArr;
//    [self.navigationController pushViewController:edit animated:YES];
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

-(void)FoodTableViewCelleditBtnClick:(UIButton *)button withCell:(FoodTableViewCell *)cell{
    NSIndexPath *indexpath=[self.rightTableView indexPathForCell:cell];
    FoodKindTest*foodkind=self.foodKindArr[indexpath.section];
    NSArray*tempArr=foodkind.foodArr;
    
    ShowFood*showfood=tempArr[indexpath.row];
    //编辑
    if (button.tag==800) {
//        NewFoodViewController*food=[[NewFoodViewController alloc]init];
//        food.showFood=showfood;
        EditFoodViewController*edit=[[EditFoodViewController alloc]init];
        edit.showFood=showfood;
        [self.navigationController pushViewController:edit animated:YES];
       
        //下架/上架
    }else if(button.tag==801){
        if ((showfood.dwStat&2)==2) {
            showfood.dwStat=1;
        }else{
            showfood.dwStat=2;
        }

        NSMutableDictionary*parm=showfood.mj_keyValues;
        
        [parm removeObjectForKey:@"imagePath"];
       // [parm setValue:[CommonFunc returnStringWithArray:showfood.ChosenFoods] forKey:@"ChosenFoods"];
        [UniHttpTool postwithparameters:parm option:SetShowFood success:^(id json) {
            if ([json[@"ret"] integerValue]==0) {
                NSArray<NSIndexPath*>*indexPathArray=@[indexpath];
                [self.rightTableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    }
    
    
}


//开始定位
-(void)startLocation{
    DLog(@"开始定位");
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100.0f;
    if ([[[UIDevice currentDevice]systemVersion]doubleValue] >8.0){
        [self.locationManager requestWhenInUseAuthorization];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        _locationManager.allowsBackgroundLocationUpdates =YES;
    }
    [self.locationManager startUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
            
        casekCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }break;
        default:break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    
    DLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    
    
    
    [manager stopUpdatingLocation];
    
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError * _Nullable error) {
        
        
        
        for (CLPlacemark *place in placemarks) {
            
            NSLog(@"name,%@",place.name);                      // 位置名
            [self.locationBtn setTitle:place.locality forState:UIControlStateNormal];;
            NSLog(@"thoroughfare,%@",place.thoroughfare);      // 街道
            
            NSLog(@"subThoroughfare,%@",place.subThoroughfare);// 子街道
            
            NSLog(@"locality,%@",place.locality);              // 市
            
            NSLog(@"subLocality,%@",place.subLocality);        // 区
            
            NSLog(@"country,%@",place.country);                // 国家
            
        }
        
    }];
    
}
@end
