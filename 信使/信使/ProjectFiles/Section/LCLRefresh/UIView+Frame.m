//
//  UIView+Frame.m
//  测试ARC
//
//  Created by 李程龙 on 15-1-7.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setFrame_x:(CGFloat)frame_x{
    CGRect frame = self.frame;
    frame.origin.x = frame_x;
    self.frame = frame;
}

- (CGFloat)frame_x{
    return self.frame.origin.x;
}

- (void)setFrame_y:(CGFloat)frame_y{
    CGRect frame = self.frame;
    frame.origin.y = frame_y;
    self.frame = frame;
}

- (CGFloat)frame_y{
    return self.frame.origin.y;
}

- (void)setFrame_width:(CGFloat)frame_width{
    CGRect frame = self.frame;
    frame.size.width = frame_width;
    self.frame = frame;
}

- (CGFloat)frame_width{
    return self.frame.size.width;
}

- (void)setFrame_height:(CGFloat)frame_height{
    CGRect frame = self.frame;
    frame.size.height = frame_height;
    self.frame = frame;
}

- (CGFloat)frame_height{
    return self.frame.size.height;
}

- (void)setFrame_size:(CGSize)frame_size{
    CGRect frame = self.frame;
    frame.size = frame_size;
    self.frame = frame;
}

- (CGSize)frame_size{
    return self.frame.size;
}

- (void)setFrame_origin:(CGPoint)frame_origin{
    CGRect frame = self.frame;
    frame.origin = frame_origin;
    self.frame = frame;
}

- (CGPoint)frame_origin{
    return self.frame.origin;
}



@end












