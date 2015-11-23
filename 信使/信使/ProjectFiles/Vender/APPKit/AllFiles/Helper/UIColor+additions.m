//
//  UIColor+additions.m
//  碧桂园售楼
//
//  Created by 李程龙 on 14-8-19.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import "UIColor+additions.h"

@implementation UIColor (additions)

#pragma mark -//随机颜色
+ (UIColor *)randomColor{
    
    CGFloat hue = (arc4random() % 256 / 256.0);
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    return color;
}

#pragma mark -//16进制颜色
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue{
    
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}
#pragma mark -//16进制颜色
+ (UIColor*) colorWithHex:(NSInteger)hexValue{
    
    return [UIColor colorWithHex:hexValue alpha:1.0];
}
#pragma mark -//16进制颜色
+ (NSString *) hexFromUIColor: (UIColor*) color {
    
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    return [NSString stringWithFormat:@"#%x%x%x", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

@end














