//
//  UITabBar+Badge.m
//  Fruit
//
//  Created by lichenglong on 15/8/4.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "UITabBar+Badge.h"

@implementation UITabBar (Badge)

//自定义点击tanbarItem图标
- (void)showTabItemImageView:(UIImageView *)imageView onItemIndex:(int)index width:(CGFloat)width orgY:(CGFloat)orgY{

    if (!imageView) {
        return;
    }
    
    [self removeBadgeOnItemIndex:index];
    
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    imageView.tag = 888 + index;
    [imageView setTintColor:[UIColor whiteColor]];
    
    CGRect tabFrame = self.frame;
    
    float percentX = index/(float)self.items.count;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    x = x+(tabFrame.size.width/(float)self.items.count-width)/2.0;
    
    imageView.frame = CGRectMake(x, orgY, width, width);
    
    [self addSubview:imageView];
}


- (void)showBadgeOnItemIndex:(int)index{
    
    [self removeBadgeOnItemIndex:index];
    
    UIView *badgeView = [[UIView alloc]init];
    
    badgeView.tag = 888 + index;
    
    badgeView.layer.cornerRadius = 5;
    
    badgeView.backgroundColor = [UIColor redColor];
    
    CGRect tabFrame = self.frame;
    
    float percentX = (index +0.6) / self.items.count;
    
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    
    badgeView.frame = CGRectMake(x, y, 10, 10);
    
    [self addSubview:badgeView];
}

- (void)hideBadgeOnItemIndex:(int)index{
    
    [self removeBadgeOnItemIndex:index];
}

- (void)removeBadgeOnItemIndex:(int)index{
    
    for (UIView *subView in self.subviews) {
        
        if (subView.tag == 888+index) {
            
            [subView removeFromSuperview];
        }
    }
}

@end










