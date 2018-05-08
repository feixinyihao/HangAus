//
//  OrderView.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/25.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "OrderView.h"
#import "OrderFood.h"
#import "OrderViewCell.h"

@interface OrderView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,OrderViewCellDelegate>
@property(nonatomic,weak)UITableView*tableView;
@property(nonatomic,strong)NSArray*orderfoodsNOchosenFoods;
@property(nonatomic,weak)UIView*toolsView;
@end
@implementation OrderView


-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        if (self) {
             self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
             UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            tapGesturRecognizer.delegate=self;
            [self addGestureRecognizer:tapGesturRecognizer];
        }
    }
    return self;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

    if ([touch.view isDescendantOfView:self.tableView]||[touch.view isDescendantOfView:self.toolsView]) {
        return NO;
    }
    return YES;
}
-(void)tapAction:(id)sender{
    [self removeFromSuperview];
}
-(void)setOrderfoods:(NSMutableArray *)orderfoods{
    _orderfoods=orderfoods;
    if (orderfoods.count) {
        [self setupOrderfoodsNOchosenFoods];
        DLog(@"%@",self.orderfoodsNOchosenFoods);
        [self setupTableView];
    }
    
}
-(void)setupOrderfoodsNOchosenFoods{
    NSMutableArray*temp=[NSMutableArray array];
    for (int i=0; i<self.orderfoods.count; i++) {
        OrderFood*orderfood=self.orderfoods[i];
        if (orderfood.dwFoodType==4&&[orderfood.szMemo isEqualToString:@""]) {
            for (int j=0; j<self.orderfoods.count; j++) {
                OrderFood*packageFood=self.orderfoods[j];
                if (orderfood.dwFoodIndex==packageFood.dwParentIndex) {
                    if (packageFood.dwQuantity>0&&packageFood.dwQuantity<11) {
                        orderfood.szMemo=[orderfood.szMemo stringByAppendingFormat:@"%ld份%@+",
                                          packageFood.dwQuantity,
                                          packageFood.szShowFoodName];
                    }else{
                        orderfood.szMemo=[orderfood.szMemo stringByAppendingFormat:@"1份%@+",
                                          packageFood.szShowFoodName];
                        
                    }
                    
                }
            }
            if (orderfood.szMemo.length>1) {
                orderfood.szMemo=[orderfood.szMemo substringToIndex:orderfood.szMemo.length-1];
            }
            
        }
        if (orderfood.dwFoodType!=2) {
            [temp addObject:orderfood];
        }
    }
    self.orderfoodsNOchosenFoods=temp;
}
-(void)setupTableView{
    CGFloat H=self.orderfoodsNOchosenFoods.count*60;
    if (H>kScreenH/2) {
        H=kScreenH/2;
    }
    UITableView*tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,self.bounds.size.height-H,self.bounds.size.width, H)];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    [self addSubview:self.tableView];
    
    UIView*toolsView=[[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-H-30, self.bounds.size.width, 30)];
    self.toolsView=toolsView;
    toolsView.backgroundColor=KColor(240, 240, 240);
    [self addSubview:toolsView];
    
    UIButton*emptyBtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenW-100, 5, 100, 20)];
    [emptyBtn setImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    emptyBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    emptyBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [emptyBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [emptyBtn setTitle:@"清空购物车" forState:UIControlStateNormal];
    [emptyBtn addTarget:self action:@selector(emptyShopping:) forControlEvents:UIControlEventTouchUpInside];
    [toolsView addSubview:emptyBtn];

}
-(void)emptyShopping:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(OrderViewEmpty:)]) {
        [self.delegate OrderViewEmpty:sender];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderfoodsNOchosenFoods.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderViewCell*cell=[OrderViewCell initWithTableView:tableView];
    cell.delegate=self;
    cell.orderfood=self.orderfoodsNOchosenFoods[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)OrderViewCellAction:(OrderViewCell *)cell withStatus:(BOOL)status withNum:(NSInteger)num{
    NSIndexPath*indexPath=[self.tableView indexPathForCell:cell];
    if ([self.delegate respondsToSelector:@selector(OrderViewActionWithOrderfood:withStatus:withNum:)]) {
        [self.delegate OrderViewActionWithOrderfood:self.orderfoodsNOchosenFoods[indexPath.row] withStatus:status withNum:num];
    }
    
    [self setupOrderfoodsNOchosenFoods];
    if (num==0) {
       
        if (!self.orderfoodsNOchosenFoods.count) {
            [self removeFromSuperview];
            return;
        }
        
        CGFloat H=self.orderfoodsNOchosenFoods.count*60;
        if (H>kScreenH/2) {
            H=kScreenH/2;
        }
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.frame=CGRectMake(0,self.bounds.size.height-H,self.bounds.size.width, H);
            self.toolsView.frame=CGRectMake(0, self.bounds.size.height-H-30, self.bounds.size.width, 30);
        }];
    }
   
    [self.tableView reloadData];
}
-(NSArray *)orderfoodsNOchosenFoods{
    if (!_orderfoodsNOchosenFoods) {
        _orderfoodsNOchosenFoods=[NSArray array];
    }
    return _orderfoodsNOchosenFoods;
}
@end
