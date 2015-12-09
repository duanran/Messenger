//
//  UIScrollView+Refresh.m
//  测试ARC
//
//  Created by 李程龙 on 15-1-6.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import <objc/runtime.h>

@interface UIScrollView()
@property (weak, nonatomic) LCLBaseRefreshView *header;
@property (weak, nonatomic) LCLBaseRefreshView *footer;
@end

#pragma mark - 运行时相关
static char LCLRefreshHeaderViewKey;
static char LCLRefreshFooterViewKey;

@implementation UIScrollView (Refresh)

#pragma mark - property

-(LCLBaseRefreshView *)header{
    return objc_getAssociatedObject(self, &LCLRefreshHeaderViewKey);
}
-(void)setHeader:(UIView *)header{
    objc_setAssociatedObject(self, &LCLRefreshHeaderViewKey, header, OBJC_ASSOCIATION_ASSIGN);
}

-(LCLBaseRefreshView *)footer{
    return objc_getAssociatedObject(self, &LCLRefreshFooterViewKey);
}
-(void)setFooter:(UIView *)footer{
    objc_setAssociatedObject(self, &LCLRefreshFooterViewKey, footer, OBJC_ASSOCIATION_ASSIGN);
}



#pragma mark - 下拉刷新
/**
 *  添加一个下拉刷新头部控件
 *
 *  @param callback 回调
 */
- (void)addHeaderWithCallback:(void (^)())callback{
    
    // 1.创建新的header
    if (!self.header) {
        LCLBaseRefreshView *header = [LCLRefreshHeader header];
        [self addSubview:header];
        self.header = header;
    }
    
    // 2.设置block回调
    self.header.beginRefreshingCallback = callback;
}

/**
 *  移除下拉刷新头部控件
 */
- (void)removeHeader{
    
    if (self.header) {
        [self.header removeFromSuperview];
        self.header = nil;
    }
}

/**
 *  主动让下拉刷新头部控件进入刷新状态
 */
- (void)headerBeginRefreshing{
    
    if (![self.header isRefreshing]) {
        [self.header beginRefreshing];
    }
}

/**
 *  让下拉刷新头部控件停止刷新状态
 */
- (void)headerEndRefreshing{
    
    if ([self.header isRefreshing]) {
        [self.header endRefreshing];
    }
}

/**
 *  下拉刷新头部控件的可见性
 */
- (void)setHeaderHidden:(BOOL)hidden{
    
    self.header.hidden = hidden;
}

- (BOOL)isHeaderHidden{
    
    return self.header.isHidden;
}

- (BOOL)isHeaderRefreshing{
    
    return self.header.state == LCLRefreshStateRefreshing;
}




#pragma mark - 上拉刷新
/**
 *  添加一个上拉刷新尾部控件
 *
 *  @param callback 回调
 */
- (void)addFooterWithCallback:(void (^)())callback{
    
    // 1.创建新的footer
    if (!self.footer) {
        LCLBaseRefreshView *footer = [LCLRefreshFooter footer];
        [self addSubview:footer];
        self.footer = footer;
    }
    
    // 2.设置block回调
    self.footer.beginRefreshingCallback = callback;
}

/**
 *  移除上拉刷新尾部控件
 */
- (void)removeFooters{
    
    if (self.footer) {
        [self.footer removeFromSuperview];
        self.footer = nil;
    }
}

/**
 *  主动让上拉刷新尾部控件进入刷新状态
 */
- (void)footerBeginRefreshing{
    
    if (![self.footer isRefreshing]) {
        [self.footer beginRefreshing];
    }
}

/**
 *  让上拉刷新尾部控件停止刷新状态
 */
- (void)footerEndRefreshing{
    
    if ([self.footer isRefreshing]) {
        [self.footer endRefreshing];
    }
}

/**
 *  下拉刷新头部控件的可见性
 */
- (void)setFooterHidden:(BOOL)hidden{
    
    self.footer.hidden = hidden;
}

- (BOOL)isFooterHidden{
    
    return self.footer.isHidden;
}

- (BOOL)isFooterRefreshing{
    
    return self.footer.state == LCLRefreshStateRefreshing;
}



@end
















