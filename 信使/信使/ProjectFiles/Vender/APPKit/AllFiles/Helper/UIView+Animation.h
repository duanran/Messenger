//
//  UIView+Animation.h
//  碧桂园售楼
//
//  Created by 李程龙 on 14-8-19.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)

#pragma - 抖动动画
-(void)shakeView;

#pragma - 旋转
- (void)rotateRound:(BOOL)flag;
- (void)rotateAnimationWithDuration:(float)duration piFloat:(float)piFloat;

#pragma - 碎片
- (void)explodeWithCompletionHandler:(void (^)())completionHandler;

#pragma - 设置圆角图片
- (void)setRoundedRadius:(CGFloat)radius;

#pragma - 设置阴影
- (void)setShadowLayer:(BOOL)flag;
#pragma - 设置阴影
- (void)setShadowLayerWithSize:(CGSize)size radius:(CGFloat)radius alpha:(CGFloat)alpha color:(UIColor *)color;

#pragma mark - 设置边框
- (void)setBorderWithBorderColor:(UIColor *)color borderWidth:(float)borderWidth;

#pragma mark- 放大缩小动画
- (void)scaleAnimattionWithDuration:(float)duration from:(float)from to:(float)to;

#pragma mark- 透明-不透明
- (void)alphaAnimattionWithDuration:(float)duration fromAlpha:(float)fromAlpha toAlpha:(float)toAlpha;


#pragma mark - morph
- (void)morphAnimationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;

#pragma mark - bounce
- (void)bounceAninationWithDuration:(NSTimeInterval)duration;

#pragma mark - bounceLeft
- (void)bounceLeftAnimationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;

#pragma mark - bounceRight
- (void)bounceRightAnimationWithDduration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;

#pragma mark - bounceDown
- (void)bounceDownAnimationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;

#pragma mark - bounceUp
- (void)bounceUpAnimationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;


#pragma mark - fadeInLeft
- (void)fadeInLeftAnimationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;

#pragma mark - fadeInRight
- (void)fadeInRightAnimationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;

#pragma mark - fadeInDown
- (void)fadeInDownAnimationWithDduration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;

#pragma mark - fadeInUp
- (void)fadeInUpAnimationWithDduration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;

#pragma mark - zoomOut
- (void)zoomOutAnimationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;


@end












