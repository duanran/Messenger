//
//  LCLBaseRefreshView.m
//  测试ARC
//
//  Created by 李程龙 on 15-1-6.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLBaseRefreshView.h"

@implementation LCLBaseRefreshView

- (void)dealloc{
  
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:LCLRefreshContentOffset context:nil];
    [self.superview removeObserver:self forKeyPath:LCLRefreshContentSize context:nil];

    [_statusLabel removeFromSuperview];
    _statusLabel = nil;
    
    [_activityView removeFromSuperview];
    _activityView = nil;
    
    _scrollView = nil;
}

/**
 *  状态标签
 */
- (UILabel *)statusLabel{
    
    if (!_statusLabel) {
        UILabel *statusLabel = [[UILabel alloc] init];
        statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        statusLabel.font = [UIFont boldSystemFontOfSize:13];
        statusLabel.textColor = LCLRefreshLabelTextColor;
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_statusLabel = statusLabel];
    }
    return _statusLabel;
}

/**
 *  状态标签
 */
- (UIActivityIndicatorView *)activityView{
    
    if (!_activityView) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.frame = CGRectMake(0, 0, 25, 25);
        activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_activityView = activityView];
    }
    return _activityView;
}

#pragma mark - 初始化方法
- (id)init{

    self = [super init];
    if (self) {
       
        // 1.自己的属性
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:245/255.0
                                               green:245/255.0
                                                blue:245/255.0
                                               alpha:0.95];
        
        // 2.设置默认状态
        self.state = LCLRefreshStateNormal;
        
        self.pullToRefreshText = LCLRefreshHeaderPullToRefresh;
        self.releaseToRefreshText = LCLRefreshHeaderReleaseToRefresh;
        self.refreshingText = LCLRefreshHeaderRefreshing;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // 1.自己的属性
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:245/255.0
                                               green:245/255.0
                                                blue:245/255.0
                                               alpha:0.95];
        // 2.设置默认状态
        self.state = LCLRefreshStateNormal;
        
        self.pullToRefreshText = LCLRefreshHeaderPullToRefresh;
        self.releaseToRefreshText = LCLRefreshHeaderReleaseToRefresh;
        self.refreshingText = LCLRefreshHeaderRefreshing;
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.activityView.center = CGPointMake(33, self.frame_height * 0.5);
    
    // 1.状态标签
    CGFloat statusX = 0;
    CGFloat statusY = 0;
    CGFloat statusHeight = self.frame_height * 0.5;
    CGFloat statusWidth = self.frame_width;
    self.statusLabel.frame = CGRectMake(statusX, statusY, statusWidth, statusHeight);
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    
    [super willMoveToSuperview:newSuperview];
    
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:LCLRefreshContentOffset context:nil];
    [self.superview removeObserver:self forKeyPath:LCLRefreshContentSize context:nil];

    if (newSuperview) { // 新的父控件
        
        [newSuperview addObserver:self forKeyPath:LCLRefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
        [newSuperview addObserver:self forKeyPath:LCLRefreshContentSize options:NSKeyValueObservingOptionNew context:nil];
        
        // 设置宽度
        self.frame_width = newSuperview.frame.size.width;
        self.frame_height = 44.0;
        // 设置位置
        self.frame_x = 0;
        self.frame_y = -self.frame_height;

        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.contentInset;
    }
}

#pragma mark - 显示到屏幕上
- (void)drawRect:(CGRect)rect{
    
    if (self.state == LCLRefreshStateWillRefreshing) {
        self.state = LCLRefreshStateRefreshing;
    }
}

#pragma mark 是否正在刷新
- (BOOL)isRefreshing{
    
    return LCLRefreshStateRefreshing == self.state;
}

- (void)beginRefreshing{
    
    if (self.state == LCLRefreshStateRefreshing) {
        if (self.beginRefreshingCallback) {
            self.beginRefreshingCallback();
        }
    } else {
        if (self.window) {
            _state = LCLRefreshStateRefreshing;
        } else {
            // 不能调用set方法,因为会不断刷新
            _state = LCLRefreshStateWillRefreshing;
            [super setNeedsDisplay];
        }
    }
}

#pragma mark 结束刷新
- (void)endRefreshing{
    
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.state = LCLRefreshStateNormal;
    });
}

#pragma mark - 设置状态文字
- (void)setPullToRefreshText:(NSString *)pullToRefreshText{
    _pullToRefreshText = pullToRefreshText;
    [self settingLabelText];
}
- (void)setReleaseToRefreshText:(NSString *)releaseToRefreshText{
    _releaseToRefreshText = releaseToRefreshText;
    [self settingLabelText];
}
- (void)setRefreshingText:(NSString *)refreshingText{
    _refreshingText = refreshingText;
    [self settingLabelText];
}

- (void)settingLabelText{
    
    switch (self.state) {
        case LCLRefreshStateNormal:
            // 设置文字
            self.statusLabel.text = self.pullToRefreshText;
            break;
        case LCLRefreshStatePulling:
            // 设置文字
            self.statusLabel.text = self.releaseToRefreshText;
            break;
        case LCLRefreshStateRefreshing:
            // 设置文字
            self.statusLabel.text = self.refreshingText;
            break;
        default:
            break;
    }
}

#pragma mark - 设置状态
- (void)setState:(LCLRefreshState)state{
    
    // 0.存储当前的contentInset
    if (self.state != LCLRefreshStateRefreshing) {
        _scrollViewOriginalInset = self.scrollView.contentInset;
    }
    
    // 1.一样的就直接返回(暂时不返回)
    if (self.state == state) return;
    
    // 2.根据状态执行不同的操作
    switch (state) {
        case LCLRefreshStateNormal: // 普通状态
        {
            if (self.state == LCLRefreshStateRefreshing) {
                [UIView animateWithDuration:LCLRefreshSlowAnimationDuration * 0.6 animations:^{
                    self.activityView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    // 停止转圈圈
                    [self.activityView stopAnimating];
                    // 恢复alpha
                    self.activityView.alpha = 1.0;
                }];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(LCLRefreshSlowAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 再次设置回normal
                    _state = LCLRefreshStatePulling;
                    self.state = LCLRefreshStateNormal;
                });
                // 直接返回
                return;
            } else {
            
                // 停止转圈圈
                [self.activityView stopAnimating];
            }
            break;
        }
            
        case LCLRefreshStatePulling:
            break;
            
        case LCLRefreshStateRefreshing:
        {
            // 开始转圈圈
            [self.activityView startAnimating];
            
            if (self.beginRefreshingCallback) {
                self.beginRefreshingCallback();
            }
            break;
        }
        default:
            break;
    }
    
    // 3.存储状态
    _state = state;
    
    // 4.设置文字
    [self settingLabelText];
}

#pragma mark 监听UIScrollView的属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
}

@end












