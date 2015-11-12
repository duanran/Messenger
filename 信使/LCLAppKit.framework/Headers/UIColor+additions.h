//
//  UIColor+additions.h
//  碧桂园售楼
//
//  Created by 李程龙 on 14-8-19.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (additions)

#pragma mark -//随机颜色
+ (UIColor *)randomColor;

#pragma mark -//16进制颜色
+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

#pragma mark -//16进制颜色
+ (UIColor*)colorWithHex:(NSInteger)hexValue;

#pragma mark -//16进制颜色
+ (NSString *)hexFromUIColor: (UIColor*) color;

@end
