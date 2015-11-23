//
//  UIView+Util.h
//  LCLAppKit
//
//  Created by lichenglong on 15/7/15.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Util)

//创建progressBar
+ (UIView *)allocProgressButtonWithFrame:(CGRect)frame percentage:(CGFloat)percentage frontStrokeColor:(UIColor *)frontStrokeColor frontFillColor:(UIColor *)frontFillColor backgroundStrokeColor:(UIColor *)backgroundStrokeColor backgroundFillColor:(UIColor *)backgroundFillColor;

//加载xib view
+ (id)loadXibView;


//显示暂无数据提示界面
- (void)showEmptyDataTips:(NSString *)text tipsFrame:(CGRect)tipsFrame;
//隐藏暂无数据提示界面
- (void)hideEmptyDataTips;

// identify
@property (strong, nonatomic) NSString *lclIndentify;

@end







