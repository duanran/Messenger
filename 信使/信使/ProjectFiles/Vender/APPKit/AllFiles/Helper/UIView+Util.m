//
//  UIView+Util.m
//  LCLAppKit
//
//  Created by lichenglong on 15/7/15.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "UIView+Util.h"
#import <objc/runtime.h>

NSString const *EmptyDataKey = @"EmptyDataKey";
NSString const *IdentifyKey  = @"IdentifyKey";

@interface UIView ()

@property (strong, nonatomic) UILabel *emptyDataLabel;

@end

@implementation UIView (Util)

//创建progressBar
+ (UIView *)allocProgressButtonWithFrame:(CGRect)frame percentage:(CGFloat)percentage frontStrokeColor:(UIColor *)frontStrokeColor frontFillColor:(UIColor *)frontFillColor backgroundStrokeColor:(UIColor *)backgroundStrokeColor backgroundFillColor:(UIColor *)backgroundFillColor{

    if (!frontFillColor) {
        frontFillColor = [UIColor colorWithRed:240./255.0 green:35./255.0 blue:135./255.0 alpha:1.0];
    }
    
    if (!backgroundFillColor) {
        backgroundFillColor = [UIColor whiteColor];
    }
    
    if (!frontStrokeColor) {
        frontStrokeColor = [UIColor clearColor];
    }
    
    if (!backgroundStrokeColor) {
        backgroundStrokeColor = [UIColor clearColor];
    }
    
    UIView *backButton = [[UIView alloc] initWithFrame:frame];
    [backButton setBackgroundColor:[UIColor clearColor]];
    
    UIRectCorner backCorners = UIRectCornerBottomLeft | UIRectCornerTopLeft | UIRectCornerBottomRight | UIRectCornerTopRight;
    UIBezierPath *backMaskPath = [UIBezierPath bezierPathWithRoundedRect:backButton.bounds byRoundingCorners:backCorners cornerRadii:CGSizeMake(frame.size.height/2.0, frame.size.height/2.0)];
    CAShapeLayer *backMaskLayer = [CAShapeLayer layer];
    backMaskLayer.frame         = backButton.bounds;
    
    backMaskLayer.lineWidth     = 0.5;
    [backMaskLayer setStrokeColor:backgroundStrokeColor.CGColor];
    [backMaskLayer setFillColor:backgroundFillColor.CGColor];
    backMaskLayer.path          = backMaskPath.CGPath;
    
    backButton.layer.mask = backMaskLayer;
    [backButton.layer addSublayer:backMaskLayer];
    
    
    UIView *frontButton = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width*percentage, frame.size.height)];
    [frontButton setBackgroundColor:[UIColor clearColor]];
    
    UIRectCorner frontCorners = UIRectCornerBottomLeft | UIRectCornerTopLeft | UIRectCornerBottomRight | UIRectCornerTopRight;
    UIBezierPath *frontMaskPath = [UIBezierPath bezierPathWithRoundedRect:frontButton.bounds byRoundingCorners:frontCorners cornerRadii:CGSizeMake(frame.size.height/2.0, frame.size.height/2.0)];
    CAShapeLayer *frontMaskLayer = [CAShapeLayer layer];
    frontMaskLayer.frame         = frontButton.bounds;
    
    frontMaskLayer.lineWidth     = 0.5;
    [frontMaskLayer setStrokeColor:frontStrokeColor.CGColor];
    [frontMaskLayer setFillColor:frontFillColor.CGColor];
    frontMaskLayer.path          = frontMaskPath.CGPath;
    
    frontButton.layer.mask = frontMaskLayer;
    [frontButton.layer addSublayer:frontMaskLayer];
    
    [backButton addSubview:frontButton];
    
    return backButton;
}

//加载xib view
+ (id)loadXibView{

    return [[[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"%@", [self class]] owner:self options:nil] lastObject];
}



#pragma mark - 显示暂无数据提示界面
-(UILabel *)emptyDataLabel{
    return objc_getAssociatedObject(self, &EmptyDataKey);
}
-(void)setEmptyDataLabel:(UILabel *)emptyDataLabel{
    objc_setAssociatedObject(self, &EmptyDataKey, emptyDataLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//显示暂无数据提示界面
- (void)showEmptyDataTips:(NSString *)text tipsFrame:(CGRect)tipsFrame{
    
    if (!text|| [text isEqualToString:@""]) {
        text = @"暂无数据";
    }
    if (self.emptyDataLabel==nil) {
        self.emptyDataLabel = [[UILabel alloc] initWithFrame:tipsFrame];
        [self.emptyDataLabel setTextColor:[UIColor darkGrayColor]];
        [self.emptyDataLabel setNumberOfLines:0];
        [self.emptyDataLabel setFont:[UIFont systemFontOfSize:18.0]];
        [self.emptyDataLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.emptyDataLabel];
    }
    [self.emptyDataLabel setText:text];
    [self bringSubviewToFront:self.emptyDataLabel];
    [self.emptyDataLabel setHidden:NO];
}
//隐藏暂无数据提示界面
- (void)hideEmptyDataTips{
    [self.emptyDataLabel setHidden:YES];
}


// identify
-(NSString *)lclIndentify {
    return objc_getAssociatedObject(self, &IdentifyKey);
}

-(void)setLclIndentify:(NSString *)lclIndentify{
    
    objc_setAssociatedObject(self, &IdentifyKey, lclIndentify, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end








