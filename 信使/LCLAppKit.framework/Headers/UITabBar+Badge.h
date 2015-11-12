//
//  UITabBar+Badge.h
//  Fruit
//
//  Created by lichenglong on 15/8/4.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)

//显示tabItem的badge红点
- (void)showBadgeOnItemIndex:(int)index;

//隐藏tabItem的badge红点
- (void)hideBadgeOnItemIndex:(int)index;

@end
