//
//  JhtAnimationTools.h
//  JhtShopCarAnimation
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 16/5/17.
//  Copyright © 2016年 JhtAnimationTools. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol JhtAnimationToolsDelegate <NSObject>
/** 委托
 *  type == 0 购物车的动画
 *  type == 1 阻尼动画
 *  isStop：Yes动画结束，No动画过程中
 */
- (void)JhtAnimationWithType:(NSInteger)type isDidStop:(BOOL)isStop;

@end


/** 黑色背景的tag值 */
extern NSInteger const ATBlackViewTag;

/** 动画工具类 */
@interface JhtAnimationTools : NSObject

#pragma mark - property
/** 动画层 */
@property (strong, nonatomic) CALayer *shopLayer;
/** 代理 */
@property (assign, nonatomic) id<JhtAnimationToolsDelegate> toolsDelegate;



#pragma mark - Public Method
/** 单例 */
+ (instancetype)sharedInstance;


#pragma mark 购物车上抛动画
/** 购物车上抛动画
 *  rect：动画开始的坐标；如果rect传CGRectZero，则用默认开始坐标
 *  imageView：动画对应的imageView
 *  view：在哪个view上显示（一般传self.view）
 *  lastPoint：动画结束的坐标点
 *  controlPoint：动画过程中抛物线的中间转折点
 *  per：决定控制点，起点和终点X坐标之间距离 1/per；注：如果per <= 0，则控制点由controlPoint决定，否则控制点由per决定
 *  expandAnimationTime：动画变大的时间
 *  narrowAnimationTime：动画变小的时间
 *  animationValue：动画变大过程中，变为原来的几倍大
 *  注意：如果动画过程中，你不想让图片变大变小，保持原来的大小运动，传值如下：
 *       expandAnimationTime：0.0f
 *       narrowAnimationTime：动画总共的时间
 *       animationValue：1.0f
 */
- (void)aniStartShopCarAnimationWithStartRect:(CGRect)rect withImageView:(UIImageView *)imageView withView:(UIView *)view withEndPoint:(CGPoint)lastPoint withControlPoint:(CGPoint)controlPoint withStartToEndSpacePercentage:(NSInteger)per withExpandAnimationTime:(CFTimeInterval)expandAnimationTime withNarrowAnimationTime:(CFTimeInterval)narrowAnimationTime withAnimationValue:(CGFloat)animationValue;


#pragma mark 阻尼动画
/** 获取的阻尼动画的View
 *  view：黑色背景View的父view（例如：self.view）
 *  frame：这个阻尼View的坐标
 *  isBlack：YES 需要出现黑色背景，NO 不需要出现黑色背景
 *  bgColor：背景颜色
 */
- (UIView *)aniDampingAnimationWithFView:(UIView *)view withFrame:(CGRect)frame withBackgroundColor:(UIColor *)bgColor isNeedBlackView:(BOOL)isBlack;
/** 开始动画阻尼动画 */
- (void)aniStartDampingAnimation;
/** 关闭阻尼动画 */
- (void)aniCloseDampingAnimation;
/** 获取阻尼动画的黑色背景 */
- (UIView *)aniGetDampingBlackView;


@end
