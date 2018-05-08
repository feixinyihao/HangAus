//
//  CartView.m
//  DIHOManager
//
//  Created by 陈鑫荣 on 2018/3/30.
//  Copyright © 2018年 DIHO. All rights reserved.
//

#import "CartView.h"
@interface CartView()
@property(nonatomic,weak)UIImageView*cartImageview;

@property(nonatomic,weak)UILabel*numLabel;
@end
@implementation CartView


-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        if (self) {
            self.backgroundColor=KColor(240, 240, 240);
            UIImageView*cartImage=[[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-30)/2, (frame.size.width-30)/2, 30, 30)];
            [cartImage setImage:[UIImage imageNamed:@"cart_air"]];
            self.cartImageview=cartImage;
            [self addSubview:self.cartImageview];
            self.layer.cornerRadius=frame.size.width/2;
            UILabel*numLabel=[[UILabel alloc]initWithFrame:CGRectMake(frame.size.width-5, -5, 16, 16)];
            numLabel.backgroundColor=[UIColor redColor];
            numLabel.layer.masksToBounds=YES;
            numLabel.layer.cornerRadius=8;
            numLabel.font=[UIFont systemFontOfSize:12];
            numLabel.textColor=[UIColor whiteColor];
            numLabel.textAlignment=NSTextAlignmentCenter;
            self.numLabel=numLabel;
            self.numLabel.hidden=YES;
            [self addSubview:self.numLabel];
        }
    }
    return self;
}
-(void)setNum:(NSInteger)num{
    _num=num;
    if (num>0) {
        [self.cartImageview setImage:[UIImage imageNamed:@"cart_full"]];
        self.numLabel.text=[NSString stringWithFormat:@"%ld",self.num];
        self.numLabel.hidden=NO;
    }else{
        [self.cartImageview setImage:[UIImage imageNamed:@"cart_air"]];
        self.numLabel.hidden=YES;
    }
}
-(void)reload{
    if (self.num>0) {
        [self.cartImageview setImage:[UIImage imageNamed:@"cart_full"]];
        self.numLabel.text=[NSString stringWithFormat:@"%ld",self.num];
        self.numLabel.hidden=NO;
    }else{
         [self.cartImageview setImage:[UIImage imageNamed:@"cart_air"]];
        self.numLabel.hidden=YES;
    }
   
}
@end
