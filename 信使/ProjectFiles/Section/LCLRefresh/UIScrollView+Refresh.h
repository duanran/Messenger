//
//  UIScrollView+Refresh.h
//  测试ARC
//
//  Created by 李程龙 on 15-1-6.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCLRefreshHeader.h"
#import "LCLRefreshFooter.h"


@interface UIScrollView (Refresh)


#pragma mark - 下拉刷新
/**
 *  添加一个下拉刷新头部控件
 *
 *  @param callback 回调
 */
- (void)addHeaderWithCallback:(void (^)())callback;

/**
 *  移除下拉刷新头部控件
 */
- (void)removeHeader;

/**
 *  主动让下拉刷新头部控件进入刷新状态
 */
- (void)headerBeginRefreshing;

/**
 *  让下拉刷新头部控件停止刷新状态
 */
- (void)headerEndRefreshing;

/**
 *  下拉刷新头部控件的可见性
 */
@property (nonatomic, assign, getter = isHeaderHidden) BOOL headerHidden;

/**
 *  是否正在下拉刷新
 */
@property (nonatomic, assign, readonly, getter = isHeaderRefreshing) BOOL headerRefreshing;





#pragma mark - 上拉刷新
/**
 *  添加一个上拉刷新尾部控件
 *
 *  @param callback 回调
 */
- (void)addFooterWithCallback:(void (^)())callback;

/**
 *  移除上拉刷新尾部控件
 */
- (void)removeFooter;

/**
 *  主动让上拉刷新尾部控件进入刷新状态
 */
- (void)footerBeginRefreshing;

/**
 *  让上拉刷新尾部控件停止刷新状态
 */
- (void)footerEndRefreshing;

/**
 *  上拉刷新头部控件的可见性
 */
@property (nonatomic, assign, getter = isFooterHidden) BOOL footerHidden;

/**
 *  是否正在上拉刷新
 */
@property (nonatomic, assign, readonly, getter = isFooterRefreshing) BOOL footerRefreshing;


@end








