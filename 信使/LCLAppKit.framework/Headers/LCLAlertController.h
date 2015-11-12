//
//  LCLAlertController.h
//  JoeRhymeLive
//
//  Created by lichenglong on 15/7/14.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>

//类型
typedef NS_ENUM(NSInteger, LCLAlertStyle) {
    
    LCLAlertStyleCustom = 1,         //自定义位置window全屏
    LCLAlertStyleCustomBounceWindow = 20,  //自定义位置,window和view大小一致

    LCLAlertStyleFadeLeftFull = 2,
    LCLAlertStyleFadeLeftMiddle = 3,
    LCLAlertStyleFadeRightFull = 4,
    LCLAlertStyleFadeRightMiddle = 5,
    LCLAlertStyleFadeTopFull = 6,
    LCLAlertStyleFadeTopMiddle = 7,
    LCLAlertStyleFadeBottomFull = 8,
    LCLAlertStyleFadeBottomMiddle = 9,
    LCLAlertStyleFadeCenter = 10,

    LCLAlertStyleMoveLeftFull = 11,
    LCLAlertStyleMoveLeftMiddle = 12,
    LCLAlertStyleMoveRightFull = 13,
    LCLAlertStyleMoveRightMiddle = 14,
    LCLAlertStyleMoveTopFull = 15,
    LCLAlertStyleMoveTopMiddle = 16,
    LCLAlertStyleMoveBottomFull = 17,
    LCLAlertStyleMoveBottomMiddle = 18,
    LCLAlertStyleMoveCenter = 19,
};

typedef void(^LCLAlertAnimationBolck)(UIView *view, id bgView);

@interface LCLAlertController : NSObject

//显示view
+ (void)alertFromWindowWithView:(UIView *)view animationBlock:(LCLAlertAnimationBolck)animationBlock tag:(NSInteger)tag;

//显示view
+ (void)alertFromWindowWithView:(UIView *)view alertStyle:(LCLAlertStyle)alertStyle tag:(NSInteger)tag;

//显示Controller
+ (void)alertFromWindowWithController:(UIViewController *)controller alertStyle:(LCLAlertStyle)alertStyle tag:(NSInteger)tag;


//移除
+ (void)dismissAlertViewWithTag:(NSInteger)tag;
//移除
+ (void)dismissAlertView:(UIView *)view;
////移除
//+ (void)dismissAlertViewWithAnimationBolck:(LCLAlertAnimationBolck)animationBlock tag:(NSInteger)tag;

//移除所有界面
+ (void)dismissAllAlertView;


//是否隐藏状态栏
+ (void)setHideStatusBar:(BOOL)hide;

@end






