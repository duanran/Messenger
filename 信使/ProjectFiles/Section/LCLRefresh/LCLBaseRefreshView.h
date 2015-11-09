//
//  LCLBaseRefreshView.h
//  测试ARC
//
//  Created by 李程龙 on 15-1-6.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCLRefresh.h"

@interface LCLBaseRefreshView : UIView


#pragma mark - 父控件
@property (nonatomic, weak, readonly) UIScrollView *scrollView;
@property (nonatomic, assign, readonly) UIEdgeInsets scrollViewOriginalInset;

#pragma mark - 内部的控件
@property (nonatomic, weak) UILabel *statusLabel;
@property (nonatomic, weak) UIActivityIndicatorView *activityView;


/**
 *  开始进入刷新状态就会调用
 */
@property (nonatomic, copy) void (^beginRefreshingCallback)();
/**
 *  是否正在刷新
 */
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
/**
 *  开始刷新
 */
- (void)beginRefreshing;
/**
 *  结束刷新
 */
- (void)endRefreshing;


#pragma mark - 交给子类去实现 和 调用
@property (assign, nonatomic) LCLRefreshState state;
@property (strong, nonatomic) NSString *pullToRefreshText;
@property (strong, nonatomic) NSString *releaseToRefreshText;
@property (strong, nonatomic) NSString *refreshingText;


@end











