//
//  UIScrollView+Inset_Offset_Size.h
//  测试ARC
//
//  Created by 李程龙 on 15-1-9.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Inset_Offset_Size)

@property (assign, nonatomic) CGFloat lcl_contentInsetTop;
@property (assign, nonatomic) CGFloat lcl_contentInsetBottom;
@property (assign, nonatomic) CGFloat lcl_contentInsetLeft;
@property (assign, nonatomic) CGFloat lcl_contentInsetRight;

@property (assign, nonatomic) CGFloat lcl_contentOffsetX;
@property (assign, nonatomic) CGFloat lcl_contentOffsetY;

@property (assign, nonatomic) CGFloat lcl_contentSizeWidth;
@property (assign, nonatomic) CGFloat lcl_contentSizeHeight;

@end
