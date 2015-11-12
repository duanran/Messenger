//
//  LCLRefreshHeader.m
//  测试ARC
//
//  Created by 李程龙 on 15-1-9.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLRefreshHeader.h"

@interface LCLRefreshHeader()

// 最后的更新时间
@property (nonatomic, weak) UILabel *lastUpdateTimeLabel;

@end

@implementation LCLRefreshHeader

- (void)dealloc{
    
    [_lastUpdateTimeLabel removeFromSuperview];
    _lastUpdateTimeLabel = nil;
}

/**
 *  时间标签
 */
- (UILabel *)lastUpdateTimeLabel{
    
    if (!_lastUpdateTimeLabel) {
        // 1.创建控件
        UILabel *lastUpdateTimeLabel = [[UILabel alloc] init];
        lastUpdateTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lastUpdateTimeLabel.font = [UIFont boldSystemFontOfSize:12];
        lastUpdateTimeLabel.textColor = LCLRefreshLabelTextColor;
        lastUpdateTimeLabel.backgroundColor = [UIColor clearColor];
        lastUpdateTimeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lastUpdateTimeLabel = lastUpdateTimeLabel];
    }
    return _lastUpdateTimeLabel;
}

+ (instancetype)header{
    
    return [[LCLRefreshHeader alloc] init];
}

- (id)init{
    
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    // 2.时间标签
    CGFloat lastUpdateY = self.statusLabel.frame_y+self.statusLabel.frame_height;
    CGFloat lastUpdateX = 0;
    CGFloat lastUpdateHeight = self.statusLabel.frame_height;
    CGFloat lastUpdateWidth = self.statusLabel.frame_width;
    self.lastUpdateTimeLabel.frame = CGRectMake(lastUpdateX, lastUpdateY, lastUpdateWidth, lastUpdateHeight);
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    
    [super willMoveToSuperview:newSuperview];
    
    [self updateTimeLabel];
}

- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    
//    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);//线条颜色
//    CGContextMoveToPoint(context, 0, rect.size.height);
//    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
//    CGContextStrokePath(context);
//    
//    CGContextRestoreGState(context);
}

#pragma mark 更新时间字符串
- (void)updateTimeLabel{
    
    // 2.格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM-dd HH:mm";
    NSString *time = [formatter stringFromDate:[NSDate date]];
    formatter = nil;
    
    // 3.显示日期
    self.lastUpdateTimeLabel.text = [NSString stringWithFormat:@"最后更新：%@", time];
}

#pragma mark - 监听UIScrollView的contentOffset属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    // 不能跟用户交互就直接返回
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) return;
    
    // 如果正在刷新，直接返回
    if (self.state == LCLRefreshStateRefreshing) return;
    
    if ([LCLRefreshContentOffset isEqualToString:keyPath]) {
        [self adjustStateWithContentOffset];
    }
}

/**
 *  调整状态
 */
- (void)adjustStateWithContentOffset{
    
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.lcl_contentOffsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    if (currentOffsetY >= happenOffsetY) return;
    
    if (self.scrollView.isDragging) {
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetY = happenOffsetY - self.frame_height;
        
        if (self.state == LCLRefreshStateNormal && currentOffsetY < normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = LCLRefreshStatePulling;
        } else if (self.state == LCLRefreshStatePulling && currentOffsetY >= normal2pullingOffsetY) {
            // 转为普通状态
            self.state = LCLRefreshStateNormal;
        }
    } else if (self.state == LCLRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        self.state = LCLRefreshStateRefreshing;
    }
}

#pragma mark 设置状态
- (void)setState:(LCLRefreshState)state{
    
    // 1.一样的就直接返回
    if (self.state == state) return;
    
    // 2.保存旧状态
    LCLRefreshState oldState = self.state;
    
    // 3.调用父类方法
    [super setState:state];
    
    // 4.根据状态执行不同的操作
    switch (state) {
        case LCLRefreshStateNormal: // 下拉可以刷新
        {
            // 刷新完毕
            if (LCLRefreshStateRefreshing == oldState) {
                
                [self updateTimeLabel];
                
                [UIView animateWithDuration:LCLRefreshSlowAnimationDuration animations:^{
                    NSLog(@"%f", self.scrollView.lcl_contentInsetTop);
                    if (self.scrollView.lcl_contentInsetTop>0.0) {
                        self.scrollView.lcl_contentInsetTop -= self.frame_height;
                    }
                }];
            }
            
            break;
        }
            
        case LCLRefreshStatePulling: // 松开可立即刷新
        {
            break;
        }
            
        case LCLRefreshStateRefreshing: // 正在刷新中
        {
            // 执行动画
            [UIView animateWithDuration:LCLRefreshFastAnimationDuration animations:^{
                // 1.增加滚动区域
                CGFloat top = self.scrollViewOriginalInset.top + self.frame_height;
                self.scrollView.lcl_contentInsetTop = top;
                
                // 2.设置滚动位置
                self.scrollView.lcl_contentOffsetY = - top;
            }];
            break;
        }
            
        default:
            break;
    }
}

@end















