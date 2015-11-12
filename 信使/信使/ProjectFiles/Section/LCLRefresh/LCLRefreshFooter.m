//
//  LCLRefreshFooter.m
//  测试ARC
//
//  Created by 李程龙 on 15-1-9.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLRefreshFooter.h"

@interface LCLRefreshFooter()

@property (assign, nonatomic) int lastRefreshCount;

@end

@implementation LCLRefreshFooter

+ (instancetype)footer{
    
    return [[LCLRefreshFooter alloc] init];
}

- (id)init{
    
    self = [super init];
    if (self) {
        self.pullToRefreshText = LCLRefreshFooterPullToRefresh;
        self.releaseToRefreshText = LCLRefreshFooterReleaseToRefresh;
        self.refreshingText = LCLRefreshFooterRefreshing;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.pullToRefreshText = LCLRefreshFooterPullToRefresh;
        self.releaseToRefreshText = LCLRefreshFooterReleaseToRefresh;
        self.refreshingText = LCLRefreshFooterRefreshing;
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.statusLabel.frame = self.bounds;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    
    [super willMoveToSuperview:newSuperview];
        
    if (newSuperview) { // 新的父控件
        // 重新调整frame
        [self adjustFrameWithContentSize];
    }
}

- (void)drawRect:(CGRect)rect{

    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);//线条颜色
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}

#pragma mark 重写调整frame
- (void)adjustFrameWithContentSize{
    
    // 内容的高度
    CGFloat contentHeight = self.scrollView.lcl_contentSizeHeight;
    // 表格的高度
    CGFloat scrollHeight = self.scrollView.frame_height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom;
    // 设置位置和尺寸
    self.frame_y = MAX(contentHeight, scrollHeight);
}

#pragma mark 监听UIScrollView的属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
        
    // 不能跟用户交互，直接返回
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) return;
    
    if ([LCLRefreshContentSize isEqualToString:keyPath]) {
        
        // 调整frame
        [self adjustFrameWithContentSize];
        
    } else if ([LCLRefreshContentOffset isEqualToString:keyPath]) {
        
#warning 这个返回一定要放这个位置
        // 如果正在刷新，直接返回
        if (self.state == LCLRefreshStateRefreshing) return;
        
        // 调整状态
        [self adjustStateWithContentOffset];
    }
}

/**
 *  调整状态
 */
- (void)adjustStateWithContentOffset{
    
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.lcl_contentOffsetY;
    // 尾部控件刚好出现的offsetY
    CGFloat happenOffsetY = [self happenOffsetY];
    
    // 如果是向下滚动到看不见尾部控件，直接返回
    if (currentOffsetY <= happenOffsetY) return;
    
    if (self.scrollView.isDragging) {
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetY = happenOffsetY + self.frame_height;
        
        if (self.state == LCLRefreshStateNormal && currentOffsetY > normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = LCLRefreshStatePulling;
        } else if (self.state == LCLRefreshStatePulling && currentOffsetY <= normal2pullingOffsetY) {
            // 转为普通状态
            self.state = LCLRefreshStateNormal;
        }
    } else if (self.state == LCLRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        self.state = LCLRefreshStateRefreshing;
    }
}

#pragma mark - 状态相关
#pragma mark 设置状态
- (void)setState:(LCLRefreshState)state{
    
    // 1.一样的就直接返回
    if (self.state == state) return;
    
    // 2.保存旧状态
    LCLRefreshState oldState = self.state;
    
    // 3.调用父类方法
    [super setState:state];
    
    // 4.根据状态来设置属性
    switch (state)
    {
        case LCLRefreshStateNormal:
        {
            // 刷新完毕
            if (LCLRefreshStateRefreshing == oldState) {
                [UIView animateWithDuration:LCLRefreshSlowAnimationDuration animations:^{
                    self.scrollView.lcl_contentInsetBottom = self.scrollViewOriginalInset.bottom;
                }];
            }
            CGFloat deltaH = [self heightForContentBreakView];
            int currentCount = [self totalDataCountInScrollView];
            // 刚刷新完毕
            if (LCLRefreshStateRefreshing == oldState && deltaH > 0 && currentCount != self.lastRefreshCount) {
                self.scrollView.lcl_contentOffsetY = self.scrollView.lcl_contentOffsetY;
            }
            break;
        }
            
        case LCLRefreshStatePulling:
        {
            break;
        }
            
        case LCLRefreshStateRefreshing:
        {
            // 记录刷新前的数量
            self.lastRefreshCount = [self totalDataCountInScrollView];
            
            [UIView animateWithDuration:LCLRefreshFastAnimationDuration animations:^{
                CGFloat bottom = self.frame_height + self.scrollViewOriginalInset.bottom;
                CGFloat deltaH = [self heightForContentBreakView];
                if (deltaH < 0) { // 如果内容高度小于view的高度
                    bottom -= deltaH;
                }
                self.scrollView.lcl_contentInsetBottom = bottom;
            }];
            break;
        }
            
        default:
            break;
    }
}

- (int)totalDataCountInScrollView{
    
    int totalCount = 0;
    if ([self.scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.scrollView;
        
        for (int section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self.scrollView;
        
        for (int section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}


#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)heightForContentBreakView{
    
    CGFloat h = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
    return self.scrollView.contentSize.height - h;
}

#pragma mark - 在父类中用得上
/**
 *  刚好看到上拉刷新控件时的contentOffset.y
 */
- (CGFloat)happenOffsetY{
    
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0) {
        return deltaH - self.scrollViewOriginalInset.top;
    } else {
        return - self.scrollViewOriginalInset.top;
    }
}



@end










