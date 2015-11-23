//
//  LCLBoundarySlipViewController.h
//  LCLAppKit
//
//  Created by lichenglong on 15/8/11.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BoundaryViewType) {
    BoundaryViewTypeMain = 1,
    BoundaryViewTypeLeft = 2,
    BoundaryViewTypeRight = 3,
};

extern NSString *BoundarySlipControllerDidShowLeftNotification;
extern NSString *BoundarySlipControllerDidShowMainNotification;
extern NSString *BoundarySlipControllerDidShowRightNotification;

@interface LCLBoundarySlipViewController : UIViewController

//滑动速度系数:0-1。默认为0.5
@property (assign, nonatomic) CGFloat boundarySpeed;

//左右侧width 默认150
@property (assign, nonatomic) CGFloat slideWidth;

//是否允许点击视图恢复视图位置。默认为yes
@property (assign, nonatomic) BOOL enableBoundaryTap;

//是否允许显示statusBar，默认yes
@property (assign, nonatomic) BOOL showStatusBar;

//是否允许缩放.默认为yes
@property (assign, nonatomic) BOOL enableScale;

//当前显示的视图类型
@property (readonly, nonatomic) BoundaryViewType viewType;


//初始化
-(instancetype)initWithLeftView:(UIViewController *)leftView
                    mainView:(UIViewController *)mainView
                   rightView:(UIViewController *)righView
             backgroundImage:(UIImage *)image;


//恢复位置
-(void)showMainView;

//显示左视图
-(void)showLeftView;

//显示右视图
-(void)showRighView;

@end










