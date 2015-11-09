//
//  LCLPhotoButton.m
//  信使
//
//  Created by apple on 15/9/23.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLPhotoButton.h"

@implementation LCLPhotoButton


- (void)awakeFromNib{

    [self.photoButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
