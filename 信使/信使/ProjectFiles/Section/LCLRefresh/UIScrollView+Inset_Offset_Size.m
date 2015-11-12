//
//  UIScrollView+Inset_Offset_Size.m
//  测试ARC
//
//  Created by 李程龙 on 15-1-9.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "UIScrollView+Inset_Offset_Size.h"

@implementation UIScrollView (Inset_Offset_Size)

- (void)setLcl_contentInsetTop:(CGFloat)lcl_contentInsetTop{
    
    UIEdgeInsets inset = self.contentInset;
    inset.top = lcl_contentInsetTop;
    self.contentInset = inset;
}

- (CGFloat)lcl_contentInsetTop{
    
    return self.contentInset.top;
}

- (void)setLcl_contentInsetBottom:(CGFloat)lcl_contentInsetBottom{
    
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = lcl_contentInsetBottom;
    self.contentInset = inset;
}

- (CGFloat)lcl_contentInsetBottom{
    
    return self.contentInset.bottom;
}

- (void)setLcl_contentInsetLeft:(CGFloat)lcl_contentInsetLeft{
    
    UIEdgeInsets inset = self.contentInset;
    inset.left = lcl_contentInsetLeft;
    self.contentInset = inset;
}

- (CGFloat)lcl_contentInsetLeft{
    
    return self.contentInset.left;
}

- (void)setLcl_contentInsetRight:(CGFloat)lcl_contentInsetRight{
    
    UIEdgeInsets inset = self.contentInset;
    inset.right = lcl_contentInsetRight;
    self.contentInset = inset;
}

- (CGFloat)lcl_contentInsetRight{
    
    return self.contentInset.right;
}

- (void)setLcl_contentOffsetX:(CGFloat)lcl_contentOffsetX{
    
    CGPoint offset = self.contentOffset;
    offset.x = lcl_contentOffsetX;
    self.contentOffset = offset;
}

- (CGFloat)lcl_contentOffsetX{
    
    return self.contentOffset.x;
}

- (void)setLcl_contentOffsetY:(CGFloat)lcl_contentOffsetY{
    
    CGPoint offset = self.contentOffset;
    offset.y = lcl_contentOffsetY;
    self.contentOffset = offset;
}

- (CGFloat)lcl_contentOffsetY{
    
    return self.contentOffset.y;
}

- (void)setLcl_contentSizeWidth:(CGFloat)lcl_contentSizeWidth{
    
    CGSize size = self.contentSize;
    size.width = lcl_contentSizeWidth;
    self.contentSize = size;
}

- (CGFloat)lcl_contentSizeWidth{
    
    return self.contentSize.width;
}

- (void)setLcl_contentSizeHeight:(CGFloat)lcl_contentSizeHeight{
    
    CGSize size = self.contentSize;
    size.height = lcl_contentSizeHeight;
    self.contentSize = size;
}

- (CGFloat)lcl_contentSizeHeight{
    
    return self.contentSize.height;
}

@end









