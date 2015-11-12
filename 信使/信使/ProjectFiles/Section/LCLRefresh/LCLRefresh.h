//
//  LCLRefresh.h
//  测试ARC
//
//  Created by 李程龙 on 15-1-6.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "UIView+Frame.h"
#import "UIScrollView+Inset_Offset_Size.h"

#ifndef __ARC_LCLRefresh_h
#define __ARC_LCLRefresh_h

//时间
#define LCLRefreshFastAnimationDuration 0.25
#define LCLRefreshSlowAnimationDuration 0.4

// 文字颜色
#define LCLRefreshLabelTextColor [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0]

//kvo
#define LCLRefreshContentOffset          @"contentOffset"
#define LCLRefreshContentSize            @"contentSize"

#define LCLRefreshFooterPullToRefresh     @"上拉可以加载更多数据";
#define LCLRefreshFooterReleaseToRefresh  @"松开立即加载更多数据";
#define LCLRefreshFooterRefreshing        @"正在努力加载更多数据...";

#define LCLRefreshHeaderPullToRefresh     @"下拉可以刷新";
#define LCLRefreshHeaderReleaseToRefresh  @"松开立即刷新";
#define LCLRefreshHeaderRefreshing        @"正在努力刷新...";


#pragma mark - 控件的刷新状态
typedef enum {
    LCLRefreshStatePulling = 1, // 松开就可以进行刷新的状态
    LCLRefreshStateNormal = 2, // 普通状态
    LCLRefreshStateRefreshing = 3, // 正在刷新中的状态
    LCLRefreshStateWillRefreshing = 4
} LCLRefreshState;

#pragma mark - 控件的类型
typedef enum {
    LCLRefreshViewTypeHeader = -1, // 头部控件
    LCLRefreshViewTypeFooter = 1 // 尾部控件
} LCLRefreshViewType;









#endif







