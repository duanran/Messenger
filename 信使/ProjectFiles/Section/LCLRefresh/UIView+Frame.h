//
//  UIView+Frame.h
//  测试ARC
//
//  Created by 李程龙 on 15-1-7.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (assign, nonatomic) CGFloat frame_x;
@property (assign, nonatomic) CGFloat frame_y;
@property (assign, nonatomic) CGFloat frame_width;
@property (assign, nonatomic) CGFloat frame_height;
@property (assign, nonatomic) CGSize  frame_size;
@property (assign, nonatomic) CGPoint frame_origin;

@end
