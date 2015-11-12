//
//  LCLARCSelectImageCell.m
//  测试ARC
//
//  Created by 李程龙 on 14-6-13.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import "LCLARCSelectImageCell.h"

@implementation LCLARCSelectImageCell

- (void)dealloc{

    [self.lclImageView removeFromSuperview];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.lclImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.lclImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.lclImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.lclImageView.clipsToBounds = TRUE;
        self.lclImageView.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
        [[self contentView] addSubview:self.lclImageView];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
