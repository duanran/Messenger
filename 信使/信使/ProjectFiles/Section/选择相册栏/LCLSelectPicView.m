//
//  LCLSelectPicView.m
//  信使
//
//  Created by apple on 15/9/15.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLSelectPicView.h"

@implementation LCLSelectPicView

- (void)dealloc{

    self.movieDelegate = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupWithImageArray:(NSArray *)array{

    [self setBackgroundColor:[UIColor clearColor]];
    
    for (UIButton *button in self.subviews) {
        [button removeFromSuperview];
    }
    
    CGFloat height = 80;
    CGFloat width = height*4/3.0;

    for (int i=0; i<array.count; i++) {
        
        NSDictionary *dic = [array objectAtIndex:i];
        LCLPhotoObject *photoObj = [LCLPhotoObject allocModelWithDictionary:dic];

        CGRect frame = CGRectMake(5*(i+1)+width*i, 5, width, height);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
        [button setImageWithURL:photoObj.path defaultImagePath:DefaultImagePath];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:frame];
        
        [self addSubview:button];
    }
    
    [self setContentSize:CGSizeMake(width*array.count+5*(array.count+1), height)];
}

- (IBAction)tapButton:(UIButton *)sender{

    [[LCLAvatarBrowser shareLCLImageController] showImage:sender.imageView];
}

- (void)setupWithMovieArray:(NSArray *)array{

    [self setBackgroundColor:[UIColor clearColor]];
    
    for (UIButton *button in self.subviews) {
        [button removeFromSuperview];
    }
    
    CGFloat height = 80;
    CGFloat width = height*4/3.0;
    
    for (int i=0; i<array.count; i++) {
        
        NSDictionary *dic = [array objectAtIndex:i];
        LCLPhotoObject *photoObj = [LCLPhotoObject allocModelWithDictionary:dic];
        
        CGRect frame = CGRectMake(5*(i+1)+width*i, 5, width, height);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
        [button setImageWithURL:photoObj.pic defaultImagePath:DefaultImagePath];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [button addTarget:self action:@selector(tapMovieButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setRestorationIdentifier:photoObj.path];
        [button setFrame:frame];
        
        [self addSubview:button];
    }
    
    [self setContentSize:CGSizeMake(width*array.count+5*(array.count+1), height)];

}

- (IBAction)tapMovieButton:(UIButton *)sender{
    
    NSString *moveURL = sender.restorationIdentifier;
    
    if (self.movieDelegate && [self.movieDelegate respondsToSelector:@selector(didTapMoviePath:)]) {
        [self.movieDelegate didTapMoviePath:moveURL];
    }
}


@end





