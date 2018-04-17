//
//  PackageBtn.m
//  HangAus
//
//  Created by 陈鑫荣 on 2018/4/17.
//  Copyright © 2018年 HangAus. All rights reserved.
//

#import "PackageBtn.h"
@interface PackageBtn()
@property(nonatomic,weak)UILabel*numL;
@end
@implementation PackageBtn


-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        if (self) {
            UILabel*numL=[[UILabel alloc]initWithFrame:CGRectMake(frame.size.width-10, -10, 20, 20)];
            numL.layer.masksToBounds=YES;
            numL.layer.cornerRadius=10;
            numL.textAlignment=NSTextAlignmentCenter;
            numL.textColor=[UIColor whiteColor];
            numL.font=[UIFont systemFontOfSize:15];
            numL.backgroundColor=[UIColor redColor];
            self.numL=numL;
            self.numL.hidden=YES;
            [self addSubview:self.numL];
        }
    }
    return self;
}

-(void)setOrderNum:(NSInteger)orderNum{
    _orderNum=orderNum;
    if (orderNum>0) {
        self.numL.text=[NSString stringWithFormat:@"%ld",self.orderNum];
        self.numL.hidden=NO;
    }else{
        self.numL.hidden=YES;
    }
}
@end
