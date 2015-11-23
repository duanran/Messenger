//
//  UIView+Badge.h
//  碧桂园售楼
//
//  Created by 李程龙 on 14-8-19.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Badge)

// Badge value to be display
@property (nonatomic) NSString *badgeValue;
// Badge background color
@property (nonatomic) UIColor *badgeBGColor;
// Badge text color
@property (nonatomic) UIColor *badgeTextColor;
// Badge font
@property (nonatomic) UIFont *badgeFont;
// Minimum size badge to small
@property (nonatomic) CGFloat badgeMinSize;
// Values for offseting the badge over the BarButtonItem you picked
@property (nonatomic) CGFloat badgeOriginX;
@property (nonatomic) CGFloat badgeOriginY;
// In case of numbers, remove the badge when reaching zero
@property BOOL shouldHideBadgeAtZero;
// Badge has a bounce animation when value changes
@property BOOL shouldAnimateBadge;
//When > 99 bounce is a dot
@property BOOL shouldAllowMaxNumber;

@end













