//
//  LCLWaitView.m
//  JoeRhymeLive
//
//  Created by 李程龙 on 15/5/11.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLWaitView.h"

@interface LCLWaitView ()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation LCLWaitView

- (void)dealloc{
    
    [_indicatorView stopAnimating];
    [_indicatorView removeFromSuperview];
    _indicatorView = nil;
}

- (void)layoutSubviews{

    [self.indicatorView setCenter:self.center];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//创建单例模式
+ (id)standerWaitView{

    static dispatch_once_t waitToken;
    static id waitView = nil;
    
    dispatch_once(&waitToken, ^{
        
        waitView = [[[self class] alloc] init];
        [waitView setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.2]];
    });
    return waitView;
}

/**
 * 显示等待控件.
 */
+ (void)showIndicatorView:(BOOL)show{
    
    LCLWaitView *wait = [LCLWaitView standerWaitView];
    [wait setFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    [wait setTag:888];
    
    if (show) {
        
        [wait.indicatorView startAnimating];
        [wait.indicatorView setHidden:NO];
        
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        if (![keyWindow viewWithTag:888]) {
            [keyWindow addSubview:wait];
        }
    }else{
        [wait.indicatorView stopAnimating];
        [wait.indicatorView setHidden:YES];
        
        [wait removeFromSuperview];
    }
}

- (UIActivityIndicatorView *)indicatorView{

    if (!_indicatorView) {
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_indicatorView setCenter:self.center];
        [_indicatorView stopAnimating];
        [_indicatorView setHidden:YES];
        [_indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_indicatorView setTintColor:[UIColor whiteColor]];
        [_indicatorView setColor:[UIColor whiteColor]];
        [_indicatorView setRoundedRadius:4.0];
        [_indicatorView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.9]];
        
        [self addSubview:_indicatorView];
    }
    
    return _indicatorView;
}

@end





