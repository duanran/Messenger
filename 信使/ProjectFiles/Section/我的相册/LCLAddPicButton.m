//
//  LCLAddPicButton.m
//  信使
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLAddPicButton.h"

@implementation LCLAddPicButton

- (void)awakeFromNib{

    [self setBackgroundColor:[UIColor clearColor]];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [super drawRect:rect];
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGFloat lengths[] = {2,2};
    CGContextSetLineDash(context, 0, lengths, 2);
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextAddLineToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, 0, 0);
    
    CGContextStrokePath(context);
    CGContextClosePath(context);
}


@end





